import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/database/app_database_provider.dart';
import '../../../data/database/mappers.dart';
import '../domain/app_settings.dart';
import '../data/settings_repository.dart';

// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return SettingsRepository(db);
});

// Provider for current settings
final settingsProvider = StreamProvider<AppSettings>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.appSettings)..limit(1)).watchSingleOrNull().map((s) {
    return s?.toDomain() ?? AppSettings();
  });
});

// Provider for cache size
final cacheSizeProvider = FutureProvider<int>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.calculateCacheSize();
});

// Provider for recommended max downloads
final recommendedMaxDownloadsProvider = Provider<int>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.getRecommendedMaxDownloads();
});
