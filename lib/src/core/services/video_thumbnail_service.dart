import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vidra/src/core/utils/log.dart';
import '../utils/path.dart';
import '../utils/helper.dart';

/// -----------------------------
/// VideoThumbnailService v4
/// -----------------------------
final videoThumbnailServiceProvider =
    Provider.autoDispose<VideoThumbnailService>((ref) {
      final service = VideoThumbnailService();
      ref.onDispose(() => service.dispose());
      return service;
    });

class CancelableTask {
  bool _isCanceled = false;
  bool get isCanceled => _isCanceled;
  void cancel() => _isCanceled = true;
}

class VideoThumbnailService {
  static const int _maxMemoryCacheSize = 50;

  final LinkedHashMap<String, Uint8List> _memoryCache = LinkedHashMap();
  final Map<String, CancelableTask> _activeTasks = {};
  Uint8List? _lastSuccessfulFrame;

  bool _isDisposed = false;

  /// 获取预览图
  Future<Uint8List?> getThumbnail({
    required String videoId,
    required String videoUrl,
    required Duration time,
  }) async {
    if (_isDisposed) return null;

    final timeMs = time.inMilliseconds;
    final key = '${videoId}_$timeMs';
    debugPrint('[VideoThumbnailService] getThumbnail called: $key');

    // 1. 高频请求，直接返回 lastSuccessfulFrame
    if (_activeTasks.containsKey(key)) {
      debugPrint(
        '[VideoThumbnailService] High-frequency request skipped: $key',
      );
      return _lastSuccessfulFrame;
    }

    // 2. 内存缓存
    if (_memoryCache.containsKey(key)) {
      _promoteKey(key);
      return _memoryCache[key];
    }

    // 3. 创建 cancelable 任务
    final task = CancelableTask();
    _activeTasks[key] = task;

    try {
      // 3.1 构建缓存路径
      final tempDir = await PathHelper.getCacheDirectory();
      final thumbnailDir = Directory('${tempDir.path}/thumbnails');
      if (!await thumbnailDir.exists()) {
        await thumbnailDir.create(recursive: true);
      }

      final safeKey = key.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final destPath = '${thumbnailDir.path}/$safeKey.jpg';
      final destFile = File(destPath);

      // 3.2 磁盘缓存存在直接返回
      if (await destFile.exists()) {
        final bytes = await destFile.readAsBytes();
        _addToMemoryCache(key, bytes);
        _lastSuccessfulFrame = bytes;
        _activeTasks.remove(key);
        debugPrint('[VideoThumbnailService] Reusing existing file: $destPath');
        return bytes;
      }

      // 3.3 FFmpeg 生成
      final shellPath = UtilHelper.getShellPath();
      final ffmpegPath = PathHelper.join(shellPath, 'ffmpeg');
      final args = [
        '-loglevel',
        'error',
        '-reconnect',
        '1',
        '-reconnect_streamed',
        '1',
        '-reconnect_delay_max',
        '2',
        '-analyzeduration',
        '1000000',
        '-probesize',
        '1000000',
        '-ss',
        (time.inMilliseconds / 1000.0).toStringAsFixed(2),
        '-i',
        videoUrl,
        '-vframes',
        '1',
        '-threads',
        '1',
        '-vf',
        'scale=160:-1',
        '-q:v',
        '5',
        '-f',
        'image2',
        '-atomic_writing',
        '1',
        '-y',
        destPath,
      ];

      logR('[VideoThumbnailService]  ', "Starting ffmpeg process:  $args");

      final process = await Process.start(ffmpegPath, args);
      logR('[VideoThumbnailService]  ', "Started ffmpeg process:  $process");
      // stderr listener
      // process.stderr
      //     .transform(utf8.decoder)
      //     .listen((data) => debugPrint('[FFmpeg STDERR] $data'));

      final exitCode = await process.exitCode.timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          process.kill(ProcessSignal.sigkill);
          return -1;
        },
      );

      logR('[VideoThumbnailService]  ', "Started ffmpeg process:  $exitCode");
      // Task canceled or disposed → 安全退出
      if (_isDisposed || task.isCanceled) {
        logR('[VideoThumbnailService] ', "Task canceled/disposed: $key");
        _activeTasks.remove(key);
        return _lastSuccessfulFrame;
      }

      // 文件生成检查
      if (await destFile.exists() && await destFile.length() > 0) {
        final bytes = await destFile.readAsBytes();
        _addToMemoryCache(key, bytes);
        _lastSuccessfulFrame = bytes;
        _activeTasks.remove(key);
        logR(
          '[VideoThumbnailService] ',
          "Saved image: $key, size=${bytes.length}",
        );
        return bytes;
      }

      // FFmpeg 未生成成功，返回 lastSuccessfulFrame
      logR(
        '[VideoThumbnailService] ',
        "Frame generation failed or empty file: $key",
      );
      _activeTasks.remove(key);
      return _lastSuccessfulFrame;
    } catch (e, st) {
      logR('[VideoThumbnailService] ', "Error: $e\n$st");
      _activeTasks.remove(key);
      return _lastSuccessfulFrame;
    }
  }

  void _addToMemoryCache(String key, Uint8List bytes) {
    if (_memoryCache.length >= _maxMemoryCacheSize) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[key] = bytes;
  }

  void _promoteKey(String key) {
    if (_memoryCache.containsKey(key)) {
      final val = _memoryCache.remove(key)!;
      _memoryCache[key] = val;
    }
  }

  Future<void> dispose() async {
    _isDisposed = true;
    logR('[VideoThumbnailService] ', "disposing");
    try {
      for (final task in _activeTasks.values) {
        task.cancel();
      }
      _activeTasks.clear();
      _memoryCache.clear();
    } catch (e) {
      logR('[VideoThumbnailService] ', "Error: $e");
    }
    logR('[VideoThumbnailService] ', "disposed");
  }
}
