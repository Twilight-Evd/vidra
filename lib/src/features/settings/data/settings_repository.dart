import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/utils/path.dart';
import '../domain/app_settings.dart';

class SettingsRepository {
  final Isar _isar;

  SettingsRepository(this._isar);

  /// Get current settings (creates default if not exists)
  Future<AppSettings> getSettings() async {
    var settings = await _isar.appSettings.get(0);
    if (settings == null) {
      settings = AppSettings();
      await _isar.writeTxn(() async {
        await _isar.appSettings.put(settings!);
      });
    }
    return settings;
  }

  /// Update settings
  Future<void> updateSettings(AppSettings settings) async {
    settings.id = 0; // Ensure singleton
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings);
    });
  }

  /// Update locale
  Future<void> updateLocale(String locale) async {
    final settings = await getSettings();
    settings.locale = locale;
    await updateSettings(settings);
  }

  /// Get default download path
  Future<String> getDefaultDownloadPath() async {
    final downloadsDir = await getDownloadsDirectory();
    return downloadsDir?.path ??
        (await getApplicationDocumentsDirectory()).path;
  }

  /// Get effective download path (custom or default)
  Future<String> getEffectiveDownloadPath() async {
    final settings = await getSettings();
    if (settings.downloadPath != null && settings.downloadPath!.isNotEmpty) {
      return settings.downloadPath!;
    }
    return getDefaultDownloadPath();
  }

  /// Calculate cache size in bytes
  Future<int> calculateCacheSize() async {
    try {
      final tempDir = await PathHelper.getCacheDirectory();
      return await _calculateDirectorySize(tempDir);
    } catch (e) {
      return 0;
    }
  }

  Future<int> _calculateDirectorySize(Directory dir) async {
    int totalSize = 0;
    try {
      if (await dir.exists()) {
        await for (var entity in dir.list(
          recursive: true,
          followLinks: false,
        )) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
      }
    } catch (e) {
      // Ignore errors
    }
    return totalSize;
  }

  /// Clear cache directory
  Future<void> clearCache() async {
    try {
      final tempDir = await PathHelper.getCacheDirectory();
      if (await tempDir.exists()) {
        await for (var entity in tempDir.list()) {
          await entity.delete(recursive: true);
        }
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get recommended max concurrent downloads based on CPU cores
  int getRecommendedMaxDownloads() {
    final cores = Platform.numberOfProcessors;
    // Recommend half of CPU cores, min 2, max 6
    return (cores / 2).ceil().clamp(2, 6);
  }
}
