import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/services/video_thumbnail_service.dart';
import '../domain/video_collection.dart';
import '../domain/video_settings.dart';
import '../domain/play_history.dart';
import 'package:vidra/src/features/video/domain/category.dart';
import '../../settings/domain/app_settings.dart';
import 'video_data_source.dart';
import 'demo_olevod/olevod_data_source.dart';
import 'mock/mock_data_source.dart';

// Providers
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('isarProvider must be overridden');
});

final initialDataSourceIdProvider = Provider<String>((ref) {
  throw UnimplementedError('initialDataSourceIdProvider must be overridden');
});

final availableDataSourcesProvider = Provider<List<VideoDataSource>>((ref) {
  final dio = ref.watch(dioProvider);
  final thumbnailService = ref.watch(videoThumbnailServiceProvider);
  return [
    OlevodDataSource(dio, thumbnailService),
    MockDataSource(thumbnailService),
  ];
});

class DataSourceIdNotifier extends Notifier<String> {
  @override
  String build() {
    return ref.watch(initialDataSourceIdProvider);
  }

  Future<void> setSource(String id) async {
    state = id;
    final isar = ref.read(isarProvider);
    await isar.writeTxn(() async {
      final settings = await isar.appSettings.get(0) ?? AppSettings();
      settings.lastDataSourceId = id;
      await isar.appSettings.put(settings);
    });
  }
}

final activeDataSourceIdProvider =
    NotifierProvider<DataSourceIdNotifier, String>(DataSourceIdNotifier.new);

final activeDataSourceProvider = Provider<VideoDataSource>((ref) {
  final sources = ref.watch(availableDataSourcesProvider);
  final activeId = ref.watch(activeDataSourceIdProvider);
  return sources.firstWhere(
    (s) => s.id == activeId,
    orElse: () => sources.first,
  );
});

final videoRepositoryProvider = Provider<VideoRepository>((ref) {
  final dataSource = ref.watch(activeDataSourceProvider);
  final allSources = ref.watch(availableDataSourcesProvider);
  final isar = ref.watch(isarProvider);
  return VideoRepository(dataSource, allSources, isar);
});

class VideoRepository {
  final VideoDataSource _defaultDataSource;
  final List<VideoDataSource> _allDataSources;
  final Isar _isar;

  Isar get isar => _isar;

  VideoRepository(this._defaultDataSource, this._allDataSources, this._isar);

  VideoDataSource _getDataSource(String? sourceId) {
    if (sourceId == null) return _defaultDataSource;
    return _allDataSources.firstWhere(
      (s) => s.id == sourceId,
      orElse: () => _defaultDataSource,
    );
  }

  // App Settings
  Future<AppSettings> getAppSettings() async {
    final settings = await _isar.appSettings.get(0);
    return settings ?? AppSettings();
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.appSettings.put(settings); // ID 0 is set in class
    });
  }

  Future<void> updateLastDataSource(String sourceId) async {
    await _isar.writeTxn(() async {
      final settings = await _isar.appSettings.get(0) ?? AppSettings();
      settings.lastDataSourceId = sourceId;
      await _isar.appSettings.put(settings);
    });
  }

  Future<List<Category>> getCategories() => _defaultDataSource.getCategories();

  Future<Map<String, dynamic>> fetchVideos({
    required int categoryId,
    int? subTypeId,
    String? area,
    String? year,
    int page = 1,
  }) async {
    final response = await _defaultDataSource.fetchVideos(
      categoryId: categoryId,
      subTypeId: subTypeId,
      area: area,
      year: year,
      page: page,
    );
    return {
      'list': response.list,
      'total': response.total,
      'page': response.page,
    };
  }

  Future<Video?> getVideo(
    int apiId, {
    bool forceRefresh = false,
    String? sourceId,
  }) async {
    final sid = sourceId ?? _defaultDataSource.id;
    // 1. Check Isar local cache if not forcing refresh
    if (!forceRefresh) {
      try {
        final cached = await _isar.videos
            .filter()
            .sourceIdEqualTo(sid)
            .and()
            .apiIdEqualTo(apiId)
            .findFirst();
        if (cached != null && (cached.urls?.isNotEmpty ?? false)) {
          return cached;
        }
      } catch (e) {}
    }

    final ds = _getDataSource(sid);
    final video = await ds.getVideoDetail(apiId);
    if (video != null) {
      // 2. Save to Isar for future use (and other windows)
      try {
        await _isar.writeTxn(() async {
          await _isar.videos.put(video);
        });
      } catch (e) {}
    }
    return video;
  }

  // Local Database methods for favorites/history (kept for future use)
  Future<void> toggleFavorite(int id) async {
    final video = await _isar.videos.get(id);
    if (video != null) {
      await _isar.writeTxn(() async {
        // video.isFavorite = !video.isFavorite;
        await _isar.videos.put(video);
      });
    }
  }

  // Video Settings methods
  Future<VideoSettings> getVideoSettings(int videoId, String? sourceId) async {
    final sid = sourceId ?? _defaultDataSource.id;
    final settings = await _isar.videoSettings
        .filter()
        .sourceIdEqualTo(sid)
        .and()
        .videoIdEqualTo(videoId)
        .findFirst();
    return settings ??
        VideoSettings.withValues(videoId: videoId, sourceId: sid);
  }

  Future<void> saveVideoSettings(VideoSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.videoSettings.put(settings);
    });
  }

  // Video History (for "Recent" list)
  Future<List<VideoHistory>> getAllVideoHistory() async {
    return await _isar.videoHistorys.where().sortByUpdatedAtDesc().findAll();
  }

  Stream<List<VideoHistory>> watchAllVideoHistory() {
    return _isar.videoHistorys.where().sortByUpdatedAtDesc().watch(
      fireImmediately: true,
    );
  }

  Future<VideoHistory?> getVideoHistory(int videoId, String? sourceId) async {
    final sid = sourceId ?? _defaultDataSource.id;
    return await _isar.videoHistorys
        .filter()
        .sourceIdEqualTo(sid)
        .and()
        .videoIdEqualTo(videoId)
        .findFirst();
  }

  Future<void> saveVideoHistory(VideoHistory history) async {
    await _isar.writeTxn(() async {
      await _isar.videoHistorys.put(history);
    });
  }

  Future<void> deleteVideoHistory(int id) async {
    final history = await _isar.videoHistorys.get(id);
    if (history == null) return;

    final videoId = history.videoId;
    final sourceId = history.sourceId;

    await _isar.writeTxn(() async {
      // 1. Delete history entry itself
      await _isar.videoHistorys.delete(id);

      // 2. Delete cached video details
      final video = await _isar.videos
          .filter()
          .sourceIdEqualTo(sourceId)
          .and()
          .apiIdEqualTo(videoId)
          .findFirst();
      if (video != null) {
        await _isar.videos.delete(video.id);
      }

      // 3. Delete video-specific settings (intro/outro skip, etc.)
      await _isar.videoSettings
          .filter()
          .sourceIdEqualTo(sourceId)
          .and()
          .videoIdEqualTo(videoId)
          .deleteAll();

      // 4. Delete all episode progress for this video
      await _isar.episodeHistorys
          .filter()
          .sourceIdEqualTo(sourceId)
          .and()
          .videoIdEqualTo(videoId)
          .deleteAll();
    });
  }

  Future<EpisodeHistory?> getEpisodeHistory(
    int videoId,
    int episodeIndex,
    String? sourceId,
  ) async {
    final sid = sourceId ?? _defaultDataSource.id;
    return await _isar.episodeHistorys
        .filter()
        .sourceIdEqualTo(sid)
        .and()
        .videoIdEqualTo(videoId)
        .and()
        .episodeIndexEqualTo(episodeIndex)
        .findFirst();
  }

  Future<List<EpisodeHistory>> getEpisodeHistories(
    int videoId,
    String? sourceId,
  ) async {
    final sid = sourceId ?? _defaultDataSource.id;
    return await _isar.episodeHistorys
        .filter()
        .sourceIdEqualTo(sid)
        .and()
        .videoIdEqualTo(videoId)
        .findAll();
  }

  Future<void> saveEpisodeHistory(EpisodeHistory history) async {
    // Check if entry exists for this video+episode
    final existing = await getEpisodeHistory(
      history.videoId,
      history.episodeIndex,
      history.sourceId,
    );
    if (existing != null) {
      history.id = existing.id;
    }

    await _isar.writeTxn(() async {
      await _isar.episodeHistorys.put(history);
    });
  }

  Future<void> deleteEpisodeHistory(
    int videoId,
    int episodeIndex,
    String? sourceId,
  ) async {
    final existing = await getEpisodeHistory(videoId, episodeIndex, sourceId);
    if (existing != null) {
      await _isar.writeTxn(() async {
        await _isar.episodeHistorys.delete(existing.id);
      });
    }
  }

  Future<void> clearAllHistory() async {
    await _isar.writeTxn(() async {
      await _isar.videoHistorys.clear();
      await _isar.episodeHistorys.clear();
      await _isar.videos.clear();
      await _isar.videoSettings.clear();
    });
  }

  Future<List<Video>> searchVideos(String keyword) =>
      _defaultDataSource.searchVideos(keyword);

  String resolveUrl(String url, {String? sourceId}) {
    final ds = _getDataSource(sourceId);
    return ds.resolveUrl(url);
  }

  Future<String?> getDownloadUrl(Video video, {VideoEpisode? episode}) =>
      _getDataSource(video.sourceId).getDownloadUrl(video, episode: episode);

  Future<Uint8List?> getThumbnail(
    Video video, {
    VideoEpisode? episode,
    required Duration time,
  }) => _getDataSource(
    video.sourceId,
  ).getThumbnail(video, episode: episode, time: time);
}

final videoSettingsProvider = FutureProvider.autoDispose
    .family<VideoSettings, ({int videoId, String? sourceId})>((ref, arg) async {
      final repo = ref.watch(videoRepositoryProvider);
      return await repo.getVideoSettings(arg.videoId, arg.sourceId);
    });

final searchVideosProvider = FutureProvider.autoDispose
    .family<List<Video>, String>((ref, keyword) async {
      final repo = ref.watch(videoRepositoryProvider);
      return await repo.searchVideos(keyword);
    });

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(videoRepositoryProvider);
  return await repo.getCategories();
});

final videoByIdProvider = FutureProvider.autoDispose
    .family<Video?, ({int id, String? sourceId})>((ref, arg) async {
      final repo = ref.watch(videoRepositoryProvider);
      return await repo.getVideo(
        arg.id,
        forceRefresh: true,
        sourceId: arg.sourceId,
      );
    });
