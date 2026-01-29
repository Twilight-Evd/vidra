import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'm3u8_downloader.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../../data/database/app_database.dart'; // Relative: ../../../data/database...

class DownloadService {
  final M3U8Downloader _downloader = M3U8Downloader(maxConcurrentDownloads: 5);
  SettingsRepository? _settingsRepo;

  void initialize(AppDatabase db) {
    _settingsRepo = SettingsRepository(db);
  }

  /// Download and convert m3u8 to mp4 using pure Dart implementation
  /// Returns the path to the downloaded file
  Future<String?> downloadM3u8ToMp4({
    required String url,
    required String filename,
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
      // Get downloads directory from settings or use default
      Directory downloadsDir;
      if (_settingsRepo != null) {
        final downloadPath = await _settingsRepo!.getEffectiveDownloadPath();
        downloadsDir = Directory(downloadPath);
      } else {
        final dir = await getDownloadsDirectory();
        if (dir == null) {
          throw Exception('Could not access downloads directory');
        }
        downloadsDir = dir;
      }

      // Ensure directory exists
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Create output path
      final outputPath = '${downloadsDir.path}/$filename.ts';

      // Delete existing file if it exists
      final outputFile = File(outputPath);
      if (await outputFile.exists()) {
        await outputFile.delete();
      }

      if (kDebugMode) {
        print('Starting download: $url');
        print('Output path: $outputPath');
      }

      // Download using pure Dart m3u8 downloader
      await _downloader.downloadM3U8(
        m3u8Url: url,
        outputPath: outputPath,
        onProgress: onProgress,
        shouldCancel: shouldCancel,
      );

      if (kDebugMode) {
        print('Download completed successfully: $outputPath');
      }

      return outputPath;
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading video: $e');
      }
      rethrow;
    }
  }

  /// Get the downloads directory
  /// Uses app's Documents/Downloads folder to avoid sandbox permission issues
  Future<Directory?> getDownloadsDirectory() async {
    // For sandboxed apps, use the app's Documents directory
    final appDocDir = await getApplicationDocumentsDirectory();

    // Create a Downloads subdirectory within Documents
    final downloadsDir = Directory('${appDocDir.path}/Downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }

    if (kDebugMode) {
      print('Downloads will be saved to: ${downloadsDir.path}');
    }

    return downloadsDir;
  }
}
