import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/app_settings.dart';
import '../data/settings_repository.dart';
import '../../video/data/video_repository.dart';

// Provider for SettingsRepository
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return SettingsRepository(isar);
});

// Provider for current settings
final settingsProvider = StreamProvider<AppSettings>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.appSettings.watchObject(0, fireImmediately: true).map((settings) {
    return settings ?? AppSettings();
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
