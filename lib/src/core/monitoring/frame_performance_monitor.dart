import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'sentry_config.dart';

/// Performance monitoring for Flutter frame rendering
///
/// 优化版本：使用异步队列处理，避免阻塞渲染线程
class FramePerformanceMonitor {
  static bool _isInitialized = false;

  // Thresholds for frame performance (in milliseconds)
  static const double _slowFrameThreshold = 16.0;
  static const double _jankFrameThreshold = 32.0;

  // Statistics
  static int _totalFrames = 0;
  static int _slowFrames = 0;
  static int _jankFrames = 0;
  static double _totalBuildTime = 0;
  static double _totalRasterTime = 0;

  // 🆕 添加队列和批处理
  static final List<FrameTiming> _pendingFrames = [];
  static Timer? _processingTimer;
  static const _batchProcessInterval = Duration(milliseconds: 100);
  static const _maxBatchSize = 50; // 限制单次处理数量

  FramePerformanceMonitor._();

  static void initialize() {
    if (_isInitialized) {
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'FramePerformanceMonitor: Skipping initialization in debug mode',
      );
      return;
    }

    _isInitialized = true;

    // Register frame timing callback
    SchedulerBinding.instance.addTimingsCallback(_onFrameTimings);

    // 🆕 启动批处理定时器
    _startProcessingTimer();

    debugPrint('FramePerformanceMonitor: Initialized');
  }

  static void dispose() {
    if (!_isInitialized) {
      return;
    }

    SchedulerBinding.instance.removeTimingsCallback(_onFrameTimings);

    // 🆕 清理定时器
    _processingTimer?.cancel();
    _processingTimer = null;
    _pendingFrames.clear();

    _isInitialized = false;

    debugPrint('FramePerformanceMonitor: Disposed');
  }

  // 🆕 启动异步批处理定时器
  static void _startProcessingTimer() {
    _processingTimer = Timer.periodic(_batchProcessInterval, (_) {
      _processPendingFrames();
    });
  }

  /// Callback for frame timings - 现在只是入队，不做处理
  static void _onFrameTimings(List<FrameTiming> timings) {
    // 🆕 快速入队，避免阻塞渲染线程
    _pendingFrames.addAll(timings);

    // 🆕 如果队列过大，立即触发处理（防止内存积压）
    if (_pendingFrames.length > _maxBatchSize * 2) {
      // 使用 scheduleMicrotask 在下一个微任务中处理
      scheduleMicrotask(_processPendingFrames);
    }
  }

  // 🆕 异步批处理待处理的帧
  static void _processPendingFrames() {
    if (_pendingFrames.isEmpty) {
      return;
    }

    // Safety: Cap queue size to prevent unbounded growth during high load
    if (_pendingFrames.length > 500) {
      // Optimization: Clear the entire list instead of shifting elements (removeRange)
      // This is O(1) vs O(N) and better for "lossy sampling" under pressure.
      _pendingFrames.clear();
      debugPrint(
        'FramePerformanceMonitor: Cleared frame queue to prevent memory leak and CPU spike',
      );
      return;
    }

    // 取出一批待处理的帧（限制数量）
    final batchSize = _pendingFrames.length > _maxBatchSize
        ? _maxBatchSize
        : _pendingFrames.length;
    final batch = _pendingFrames.sublist(0, batchSize);
    _pendingFrames.removeRange(0, batchSize);

    // 异步处理这批帧
    _processBatch(batch);

    // Optimization: Explicitly help GC by clearing reference
    // batch = null; // (Implicit in Dart as it goes out of scope, but good practice mentally)
  }

  // 🆕 处理一批帧
  static void _processBatch(List<FrameTiming> batch) {
    int slowFramesInBatch = 0;
    int jankFramesInBatch = 0;

    // ... processing ...

    for (final timing in batch) {
      final buildDuration = timing.buildDuration.inMicroseconds / 1000.0;
      final rasterDuration = timing.rasterDuration.inMicroseconds / 1000.0;
      final totalDuration = timing.totalSpan.inMicroseconds / 1000.0;

      // Update statistics
      _totalFrames++;
      _totalBuildTime += buildDuration;
      _totalRasterTime += rasterDuration;

      final isSlowFrame = totalDuration > _slowFrameThreshold;
      final isJankFrame = totalDuration > _jankFrameThreshold;

      if (isSlowFrame) {
        _slowFrames++;
        slowFramesInBatch++;
      }
      if (isJankFrame) {
        _jankFrames++;
        jankFramesInBatch++;
      }

      // 🆕 减少单个帧的 breadcrumb（改为批量汇总）
      // 只有严重的 jank 才单独记录
      if (isJankFrame && totalDuration > 50.0) {
        _addFrameBreadcrumb(
          buildDuration: buildDuration,
          rasterDuration: rasterDuration,
          totalDuration: totalDuration,
          isSlowFrame: isSlowFrame,
          isJankFrame: isJankFrame,
        );
      }
    }

    // 🆕 批量报告：如果这批帧中有问题，记录一个汇总
    if (slowFramesInBatch > 0) {
      _reportBatchSummary(batch.length, slowFramesInBatch, jankFramesInBatch);
    }

    // Periodically log statistics
    if (_totalFrames % 300 == 0) {
      _logStatistics();
    }
  }

  // 🆕 报告批次汇总
  static void _reportBatchSummary(
    int batchSize,
    int slowFrames,
    int jankFrames,
  ) {
    SentryConfig.addBreadcrumb(
      message: 'Frame batch processed',
      category: 'ui.render.batch',
      data: {
        'batchSize': batchSize,
        'slowFramesInBatch': slowFrames,
        'jankFramesInBatch': jankFrames,
        'totalFrames': _totalFrames,
      },
      level: jankFrames > 0 ? SentryLevel.warning : SentryLevel.info,
    );

    // 🆕 只有当 jank 帧比例较高时才创建 transaction
    if (jankFrames > batchSize * 0.1) {
      // 超过 10% 的帧是 jank
      _trackSlowFrameBatch(batchSize, slowFrames, jankFrames);
    }
  }

  static void _addFrameBreadcrumb({
    required double buildDuration,
    required double rasterDuration,
    required double totalDuration,
    required bool isSlowFrame,
    required bool isJankFrame,
  }) {
    SentryConfig.addBreadcrumb(
      message: 'Severe jank frame',
      category: 'ui.render',
      data: {
        'buildMs': buildDuration.toStringAsFixed(2),
        'rasterMs': rasterDuration.toStringAsFixed(2),
        'totalMs': totalDuration.toStringAsFixed(2),
        'frameNumber': _totalFrames,
      },
      level: SentryLevel.warning,
    );
  }

  // 🆕 批量报告慢帧，而不是每帧都报告
  static void _trackSlowFrameBatch(
    int batchSize,
    int slowFrames,
    int jankFrames,
  ) {
    final transaction = SentryConfig.startTransaction(
      name: 'frame_render_slow_batch',
      operation: 'ui.render',
      tags: {'severity': jankFrames > batchSize * 0.2 ? 'high' : 'medium'},
      data: {
        'batchSize': batchSize,
        'slowFramesInBatch': slowFrames,
        'jankFramesInBatch': jankFrames,
        'totalFrames': _totalFrames,
        'slowFramePercent': (_slowFrames / _totalFrames * 100).toStringAsFixed(
          2,
        ),
        'jankFramePercent': (_jankFrames / _totalFrames * 100).toStringAsFixed(
          2,
        ),
      },
    );

    transaction.status = const SpanStatus.ok();
    transaction.finish();
  }

  static void _logStatistics() {
    // 🆕 预计算以避免重复计算
    if (_totalFrames == 0) return;

    final avgBuildTime = _totalBuildTime / _totalFrames;
    final avgRasterTime = _totalRasterTime / _totalFrames;
    final slowFramePercent = _slowFrames / _totalFrames * 100;
    final jankFramePercent = _jankFrames / _totalFrames * 100;

    SentryConfig.addBreadcrumb(
      message: 'Frame statistics',
      category: 'ui.render.stats',
      data: {
        'totalFrames': _totalFrames,
        'slowFrames': _slowFrames,
        'jankFrames': _jankFrames,
        'slowFramePercent': slowFramePercent.toStringAsFixed(2),
        'jankFramePercent': jankFramePercent.toStringAsFixed(2),
        'avgBuildMs': avgBuildTime.toStringAsFixed(2),
        'avgRasterMs': avgRasterTime.toStringAsFixed(2),
        'pendingFrames': _pendingFrames.length, // 🆕 监控队列大小
      },
      level: SentryLevel.info,
    );
  }

  static Map<String, dynamic> getStatistics() {
    final avgBuildTime = _totalFrames > 0 ? _totalBuildTime / _totalFrames : 0;
    final avgRasterTime = _totalFrames > 0
        ? _totalRasterTime / _totalFrames
        : 0;
    final slowFramePercent = _totalFrames > 0
        ? (_slowFrames / _totalFrames * 100)
        : 0;
    final jankFramePercent = _totalFrames > 0
        ? (_jankFrames / _totalFrames * 100)
        : 0;

    return {
      'totalFrames': _totalFrames,
      'slowFrames': _slowFrames,
      'jankFrames': _jankFrames,
      'slowFramePercent': slowFramePercent,
      'jankFramePercent': jankFramePercent,
      'avgBuildMs': avgBuildTime,
      'avgRasterMs': avgRasterTime,
      'pendingFrames': _pendingFrames.length, // 🆕
    };
  }

  static void resetStatistics() {
    _totalFrames = 0;
    _slowFrames = 0;
    _jankFrames = 0;
    _totalBuildTime = 0;
    _totalRasterTime = 0;
    _pendingFrames.clear(); // 🆕

    SentryConfig.addBreadcrumb(
      message: 'Frame statistics reset',
      category: 'ui.render.stats',
      level: SentryLevel.info,
    );
  }

  static Future<T> trackRenderOperation<T>({
    required String name,
    required Future<T> Function() operation,
    Map<String, String>? tags,
    Map<String, dynamic>? data,
  }) async {
    if (kDebugMode) {
      return await operation();
    }

    final transaction = SentryConfig.startTransaction(
      name: name,
      operation: 'ui.render',
      tags: tags,
      data: data,
    );

    try {
      final result = await operation();
      transaction.status = const SpanStatus.ok();
      return result;
    } catch (e, stackTrace) {
      transaction.status = const SpanStatus.internalError();
      transaction.throwable = e;

      await SentryConfig.captureException(
        e,
        stackTrace: stackTrace,
        tags: {'operation': name},
      );

      rethrow;
    } finally {
      await transaction.finish();
    }
  }
}
