import 'package:drift/drift.dart'; // For Value, OrderingTerm, etc.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/log.dart';
import '../../../data/database/app_database.dart' as db;
import '../../../data/database/app_database_provider.dart';
import '../../../data/database/mappers.dart';
import '../../../core/network/dio_provider.dart';
import '../../../core/services/video_thumbnail_service.dart';
import '../domain/video_collection.dart';
import '../domain/video_settings.dart';
import '../domain/play_history.dart';
import '../domain/category.dart'; // Relative to this file
import '../../settings/domain/app_settings.dart';
import 'video_data_source.dart';
import 'demo_olevod/olevod_data_source.dart';
import 'mock/mock_data_source.dart';

// Providers
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
    final database = ref.read(appDatabaseProvider);
    await database.transaction(() async {
      // Find existing settings or create default
      // Usually only 1 row for AppSettings.
      final list = await (database.select(
        database.appSettings,
      )..limit(1)).get();
      final existing = list.isEmpty ? null : list.first;
      var settings = existing != null ? existing.toDomain() : AppSettings();

      settings.lastDataSourceId = id;

      // Save back
      await database
          .into(database.appSettings)
          .insert(settings.toCompanion(), mode: InsertMode.insertOrReplace);
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
  final database = ref.watch(appDatabaseProvider);
  return VideoRepository(dataSource, allSources, database);
});

class VideoRepository {
  final VideoDataSource _defaultDataSource;
  final List<VideoDataSource> _allDataSources;
  final db.AppDatabase _db;

  db.AppDatabase get database => _db;

  VideoRepository(this._defaultDataSource, this._allDataSources, this._db);

  VideoDataSource _getDataSource(String? sourceId) {
    if (sourceId == null) return _defaultDataSource;
    return _allDataSources.firstWhere(
      (s) => s.id == sourceId,
      orElse: () => _defaultDataSource,
    );
  }

  // App Settings
  Future<AppSettings> getAppSettings() async {
    final list = await (_db.select(_db.appSettings)..limit(1)).get();
    final s = list.isEmpty ? null : list.first;
    return s?.toDomain() ?? AppSettings();
  }

  Future<void> saveAppSettings(AppSettings settings) async {
    await _db
        .into(_db.appSettings)
        .insert(settings.toCompanion(), mode: InsertMode.insertOrReplace);
  }

  Future<void> updateLastDataSource(String sourceId) async {
    await _db.transaction(() async {
      final list = await (_db.select(_db.appSettings)..limit(1)).get();
      final existing = list.isEmpty ? null : list.first;
      var settings = existing?.toDomain() ?? AppSettings();
      settings.lastDataSourceId = sourceId;
      final id = await _db
          .into(_db.appSettings)
          .insert(settings.toCompanion(), mode: InsertMode.insertOrReplace);
      settings.id = id;
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
    // 1. Check local cache if not forcing refresh
    if (!forceRefresh) {
      try {
        final cached =
            await (_db.select(
                  _db.videos,
                )..where((t) => t.sourceId.equals(sid) & t.apiId.equals(apiId)))
                .getSingleOrNull();

        // Check if urls exist efficiently?
        // cached.urls is loaded.
        if (cached != null) {
          final domainVideo = cached.toDomain();
          if (domainVideo.urls?.isNotEmpty ?? false) {
            return domainVideo;
          }
        }
      } catch (e) {
        // Log error?
      }
    }

    final ds = _getDataSource(sid);
    final video = await ds.getVideoDetail(apiId);
    if (video != null) {
      video.sourceId = sid; // Ensure sourceId is set for the local DB
      // 2. Save to DB
      try {
        await _db.transaction(() async {
          final existing =
              await (_db.select(_db.videos)..where(
                    (t) => t.sourceId.equals(sid) & t.apiId.equals(apiId),
                  ))
                  .getSingleOrNull();

          if (existing != null) {
            video.id = existing.id; // Preserve Local ID
          }

          final newId = await _db
              .into(_db.videos)
              .insert(video.toCompanion(), mode: InsertMode.insertOrReplace);
          video.id = newId;
        });
      } catch (e) {
        logR("getVideo", e.toString());
      }
    }
    return video;
  }

  // Local Database methods for favorites/history
  Future<void> toggleFavorite(int id) async {
    // Unused
  }

  // Video Settings methods
  Future<VideoSettings> getVideoSettings(int videoId, String? sourceId) async {
    final sid = sourceId ?? _defaultDataSource.id;
    final settings =
        await (_db.select(
              _db.videoSettings,
            )..where((t) => t.sourceId.equals(sid) & t.videoId.equals(videoId)))
            .getSingleOrNull();

    return settings?.toDomain() ??
        VideoSettings.withValues(videoId: videoId, sourceId: sid);
  }

  Future<void> saveVideoSettings(VideoSettings settings) async {
    final id = await _db
        .into(_db.videoSettings)
        .insert(settings.toCompanion(), mode: InsertMode.insertOrReplace);
    settings.id = id;
  }

  // Video History (for "Recent" list)
  Future<List<VideoHistory>> getAllVideoHistory() async {
    final history =
        await (_db.select(_db.videoHistory)..orderBy([
              (t) => OrderingTerm(
                expression: t.updatedAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();
    return history.map((h) => h.toDomain()).toList();
  }

  Stream<List<VideoHistory>> watchAllVideoHistory() {
    return (_db.select(_db.videoHistory)..orderBy([
          (t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
        ]))
        .watch()
        .map((rows) => rows.map((h) => h.toDomain()).toList());
  }

  Future<VideoHistory?> getVideoHistory(int videoId, String? sourceId) async {
    final sid = sourceId ?? _defaultDataSource.id;
    final h =
        await (_db.select(
              _db.videoHistory,
            )..where((t) => t.sourceId.equals(sid) & t.videoId.equals(videoId)))
            .getSingleOrNull();
    return h?.toDomain();
  }

  Future<void> saveVideoHistory(VideoHistory history) async {
    // Normalize sourceId before saving
    final sid = history.sourceId ?? _defaultDataSource.id;
    history.sourceId = sid;

    final existing = await getVideoHistory(history.videoId, sid);
    if (existing != null) {
      history.id = existing.id;
    }

    final id = await _db
        .into(_db.videoHistory)
        .insert(history.toCompanion(), mode: InsertMode.insertOrReplace);

    history.id = id;
  }

  Future<void> deleteVideoHistory(int id) async {
    final history = await (_db.select(
      _db.videoHistory,
    )..where((t) => t.id.equals(id))).getSingleOrNull();

    if (history != null) {
      final videoId = history.videoId;
      final sourceId = history.sourceId;

      await _db.transaction(() async {
        // 1. Delete history
        await (_db.delete(
          _db.videoHistory,
        )..where((t) => t.id.equals(id))).go();

        // 2. Delete related videos
        // sourceId can be null. Safe check.
        if (sourceId != null) {
          await (_db.delete(_db.videos)..where(
                (t) => t.sourceId.equals(sourceId) & t.apiId.equals(videoId),
              ))
              .go();

          // 3. Delete settings
          await (_db.delete(_db.videoSettings)..where(
                (t) => t.sourceId.equals(sourceId) & t.videoId.equals(videoId),
              ))
              .go();

          // 4. Delete episode history
          await (_db.delete(_db.episodeHistory)..where(
                (t) => t.sourceId.equals(sourceId) & t.videoId.equals(videoId),
              ))
              .go();
        } else {
          // Handle null sourceId: check t.sourceId.isNull()
          // Video Repository usually requires sourceId.
          // If sourceId is null, we might skip deleting related or query with isNull()
          // Assuming if null, we only delete history.
        }
      });
    }
  }

  Future<EpisodeHistory?> getEpisodeHistory(
    int videoId,
    int episodeIndex,
    String? sourceId,
  ) async {
    final sid = sourceId ?? _defaultDataSource.id;
    final h =
        await (_db.select(_db.episodeHistory)..where(
              (t) =>
                  t.sourceId.equals(sid) &
                  t.videoId.equals(videoId) &
                  t.episodeIndex.equals(episodeIndex),
            ))
            .getSingleOrNull();
    return h?.toDomain();
  }

  Future<List<EpisodeHistory>> getEpisodeHistories(
    int videoId,
    String? sourceId,
  ) async {
    final sid = sourceId ?? _defaultDataSource.id;
    final list = await (_db.select(
      _db.episodeHistory,
    )..where((t) => t.sourceId.equals(sid) & t.videoId.equals(videoId))).get();
    return list.map((h) => h.toDomain()).toList();
  }

  Future<void> saveEpisodeHistory(EpisodeHistory history) async {
    // Normalize sourceId before saving
    final sid = history.sourceId ?? _defaultDataSource.id;
    history.sourceId = sid;

    final existing = await getEpisodeHistory(
      history.videoId,
      history.episodeIndex,
      sid,
    );
    if (existing != null) {
      history.id = existing.id;
    }

    final id = await _db
        .into(_db.episodeHistory)
        .insert(history.toCompanion(), mode: InsertMode.insertOrReplace);

    history.id = id;
  }

  Future<void> deleteEpisodeHistory(
    int videoId,
    int episodeIndex,
    String? sourceId,
  ) async {
    final existing = await getEpisodeHistory(videoId, episodeIndex, sourceId);
    if (existing != null) {
      await (_db.delete(
        _db.episodeHistory,
      )..where((t) => t.id.equals(existing.id))).go();
    }
  }

  Future<void> clearAllHistory() async {
    await _db.transaction(() async {
      await _db.delete(_db.videoHistory).go();
      await _db.delete(_db.episodeHistory).go();
      await _db.delete(_db.videos).go();
      await _db.delete(_db.videoSettings).go();
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
