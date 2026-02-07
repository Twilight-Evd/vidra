import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:vidra/src/core/utils/log.dart';

/// M3U8 playlist parser
class M3U8Parser {
  /// Parse m3u8 content and extract TS segment URLs or sub-playlist URLs
  static Future<List<String>> parsePlaylist(
    String content,
    String baseUrl,
    Dio dio,
  ) async {
    final lines = content.split('\n');
    final segments = <String>[];
    bool isMediaPlaylist = false;

    // Check if this is a media playlist (contains #EXTINF) or master playlist (contains #EXT-X-STREAM-INF)
    for (final line in lines) {
      if (line.trim().startsWith('#EXTINF')) {
        isMediaPlaylist = true;
        break;
      }
    }

    // If it's a master playlist, we need to fetch the first sub-playlist
    if (!isMediaPlaylist && content.contains('#EXT-X-STREAM-INF')) {
      if (kDebugMode) {
        print('Detected master playlist, fetching sub-playlist...');
      }

      // Find the first sub-playlist URL (usually the best quality)
      for (final line in lines) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) {
          continue;
        }

        // This is a sub-playlist URL
        final subPlaylistUrl = _resolveUrl(trimmed, baseUrl);
        if (kDebugMode) {
          print('Fetching sub-playlist: $subPlaylistUrl');
        }

        // Fetch and parse the sub-playlist
        final response = await dio.get(subPlaylistUrl);
        final subBaseUrl = subPlaylistUrl.substring(
          0,
          subPlaylistUrl.lastIndexOf('/') + 1,
        );
        return await parsePlaylist(response.data.toString(), subBaseUrl, dio);
      }
    }

    // Parse media playlist to extract TS segments
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        continue;
      }

      // This should be a TS segment URL
      final segmentUrl = _resolveUrl(trimmed, baseUrl);
      segments.add(segmentUrl);
    }

    return segments;
  }

  /// Resolve relative URL to absolute URL
  static String _resolveUrl(String url, String baseUrl) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      final uri = Uri.parse(baseUrl);
      final segmentUri = uri.resolve(url);
      return segmentUri.toString();
    }
  }
}

/// M3U8 Downloader with concurrent TS segment downloads
class M3U8Downloader {
  final int maxConcurrentDownloads;

  M3U8Downloader({this.maxConcurrentDownloads = 5});

  /// Download m3u8 video and convert to MP4
  Future<String> downloadM3U8({
    required String m3u8Url,
    required String outputPath,
    Function(
      double progress,
      int bytesDownloaded,
      int? totalBytes,
      String status,
    )?
    onProgress,
    bool Function()? shouldCancel,
  }) async {
    try {
      onProgress?.call(0.0, 0, null, 'Fetching playlist...');

      // 1. Download m3u8 playlist
      final dio = Dio();
      final response = await dio.get(m3u8Url);
      final playlistContent = response.data.toString();

      if (kDebugMode) {
        print(
          'M3U8 Content preview:\n${playlistContent.substring(0, playlistContent.length > 500 ? 500 : playlistContent.length)}',
        );
      }

      // 2. Parse playlist to get TS segments (handles master and media playlists)
      final baseUrl = m3u8Url.substring(0, m3u8Url.lastIndexOf('/') + 1);
      final segments = await M3U8Parser.parsePlaylist(
        playlistContent,
        baseUrl,
        dio,
      );

      if (segments.isEmpty) {
        throw Exception('No segments found in playlist');
      }

      if (kDebugMode) {
        print('Found ${segments.length} segments');
        print('First segment: ${segments.first}');
        print('Last segment: ${segments.last}');
      }

      onProgress?.call(0.05, 0, null, 'Found ${segments.length} segments');

      // 3. Create temp directory for TS files
      final outputFile = File(outputPath);
      final tempDir = Directory(
        '${outputFile.parent.path}/.temp_${DateTime.now().millisecondsSinceEpoch}',
      );
      await tempDir.create(recursive: true);

      try {
        // 4. Download all TS segments with concurrency control
        final segmentFiles = await _downloadSegmentsConcurrently(
          segments: segments,
          tempDir: tempDir,
          shouldCancel: shouldCancel,
          onProgress: (downloaded, total, bytesDownloaded) {
            final progress = 0.05 + (downloaded / total) * 0.90;

            // Estimate total bytes based on average segment size
            int? estimatedTotalBytes;
            if (downloaded > 0) {
              final avgSegmentSize = bytesDownloaded / downloaded;
              estimatedTotalBytes = (avgSegmentSize * total).round();
            }

            onProgress?.call(
              progress,
              bytesDownloaded,
              estimatedTotalBytes,
              'Downloading: $downloaded/$total',
            );
          },
        );

        onProgress?.call(0.95, 0, null, 'Merging segments...');

        // 5. Concatenate TS files into single file
        await _concatenateSegments(segmentFiles, outputPath);

        final fileSize = await File(outputPath).length();
        if (kDebugMode) {
          print(
            'Final file size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
          );
        }

        onProgress?.call(1.0, fileSize, null, 'Complete!');

        return outputPath;
      } finally {
        // 6. Cleanup temp directory
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error downloading m3u8: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Download segments with concurrency control
  Future<List<File>> _downloadSegmentsConcurrently({
    required List<String> segments,
    required Directory tempDir,
    required Function(int downloaded, int total, int bytesDownloaded)
    onProgress,
    bool Function()? shouldCancel,
  }) async {
    final segmentFiles = <File>[];
    int downloadedCount = 0;
    int totalBytesDownloaded = 0;

    // Download segments in batches
    for (int i = 0; i < segments.length; i += maxConcurrentDownloads) {
      if (shouldCancel?.call() ?? false) {
        throw Exception('Download cancelled');
      }
      final batch = segments.skip(i).take(maxConcurrentDownloads).toList();
      final batchTasks = <Future<File>>[];

      for (int j = 0; j < batch.length; j++) {
        final segmentIndex = i + j;
        final segmentUrl = batch[j];
        final segmentPath =
            '${tempDir.path}/segment_${segmentIndex.toString().padLeft(6, '0')}.ts';

        batchTasks.add(_downloadSegment(segmentUrl, segmentPath, segmentIndex));
      }

      // Wait for batch to complete
      final batchFiles = await Future.wait(batchTasks);
      segmentFiles.addAll(batchFiles);

      // Calculate bytes from this batch
      for (final file in batchFiles) {
        totalBytesDownloaded += await file.length();
      }

      downloadedCount += batch.length;
      onProgress(downloadedCount, segments.length, totalBytesDownloaded);
    }

    return segmentFiles;
  }

  /// Download a single TS segment
  Future<File> _downloadSegment(
    String url,
    String outputPath,
    int index,
  ) async {
    try {
      final dio = Dio();
      await dio.download(
        url,
        outputPath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) => status! < 500,
        ),
      );

      final file = File(outputPath);
      final size = await file.length();

      if (kDebugMode && index % 10 == 0) {
        logR(
          'Downloaded',
          'Downloaded segment $index: ${(size / 1024).toStringAsFixed(2)} KB',
        );
      }

      return file;
    } catch (e) {
      if (kDebugMode) {
        logR("Downloaded", "Error downloading segment $index from $url: $e");
      }
      rethrow;
    }
  }

  /// Concatenate TS segments into a single file
  Future<void> _concatenateSegments(
    List<File> segmentFiles,
    String outputPath,
  ) async {
    final outputFile = File(outputPath);
    final sink = outputFile.openWrite();

    try {
      int totalBytes = 0;
      for (int i = 0; i < segmentFiles.length; i++) {
        final segmentFile = segmentFiles[i];
        final bytes = await segmentFile.readAsBytes();
        sink.add(bytes);
        totalBytes += bytes.length;

        if (kDebugMode && i % 50 == 0) {
          logR(
            'Downloaded',
            'Merged ${i + 1}/${segmentFiles.length} segments, total: ${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB',
          );
        }
      }

      if (kDebugMode) {
        logR(
          'Downloaded',
          'Total merged: ${(totalBytes / 1024 / 1024).toStringAsFixed(2)} MB',
        );
      }
    } finally {
      await sink.close();
    }
  }
}
