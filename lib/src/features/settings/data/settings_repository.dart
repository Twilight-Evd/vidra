import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../src/core/utils/path.dart'; // ../../../../ = lib. lib/src/core...
import '../../../data/database/app_database.dart' hide AppSettings;
import '../../../data/database/mappers.dart';
import '../domain/app_settings.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  /// Get current settings (creates default if not exists)
  Future<AppSettings> getSettings() async {
    final list = await (_db.select(_db.appSettings)..limit(1)).get();
    final s = list.isEmpty ? null : list.first;
    if (s == null) {
      final newSettings = AppSettings();
      final id = await _db
          .into(_db.appSettings)
          .insert(newSettings.toCompanion(), mode: InsertMode.insertOrReplace);
      newSettings.id = id;
      return newSettings;
    }
    return s.toDomain();
  }

  /// Update settings
  Future<void> updateSettings(AppSettings settings) async {
    // Ensure we use the correct ID or Singleton logic
    final id = await _db
        .into(_db.appSettings)
        .insert(settings.toCompanion(), mode: InsertMode.insertOrReplace);
    settings.id = id;
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
