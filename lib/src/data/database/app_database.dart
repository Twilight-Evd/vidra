import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../../features/video/domain/video_collection.dart';
import '../../features/download/domain/download_task.dart';

part 'app_database.g.dart';

// Type Converters

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) => List<String>.from(json.decode(fromDb));
  @override
  String toSql(List<String> value) => json.encode(value);
}

class VideoEpisodeListConverter
    extends TypeConverter<List<VideoEpisode>, String> {
  const VideoEpisodeListConverter();
  @override
  List<VideoEpisode> fromSql(String fromDb) {
    final list = json.decode(fromDb) as List;
    return list.map((e) {
      final map = e as Map<String, dynamic>;
      final ep = VideoEpisode();
      ep.index = map['index'];
      ep.title = map['title'];
      ep.vip = map['vip'];
      ep.isNew = map['isNew'];
      if (map['qualities'] != null) {
        ep.qualities = (map['qualities'] as List).map((q) {
          final qMap = q as Map<String, dynamic>;
          return VideoQuality.withValues(name: qMap['name'], url: qMap['url']);
        }).toList();
      }
      return ep;
    }).toList();
  }

  @override
  String toSql(List<VideoEpisode> value) {
    return json.encode(
      value
          .map(
            (e) => {
              'index': e.index,
              'title': e.title,
              'vip': e.vip,
              'isNew': e.isNew,
              'qualities': e.qualities
                  ?.map((q) => {'name': q.name, 'url': q.url})
                  .toList(),
            },
          )
          .toList(),
    );
  }
}

class EpisodeDownloadListConverter
    extends TypeConverter<List<EpisodeDownloadInfo>, String> {
  const EpisodeDownloadListConverter();
  @override
  List<EpisodeDownloadInfo> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    final list = json.decode(fromDb) as List;
    return list.map((e) => EpisodeDownloadInfo.fromJson(e)).toList();
  }

  @override
  String toSql(List<EpisodeDownloadInfo> value) =>
      json.encode(value.map((e) => e.toJson()).toList());
}

// Tables

@TableIndex(name: 'videos_idx', columns: {#sourceId, #apiId}, unique: true)
class Videos extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text().nullable()(); // Removed unique()
  IntColumn get apiId => integer()();

  TextColumn get title => text()();
  TextColumn get coverUrl => text()();
  TextColumn get thumbUrl => text().nullable()();
  TextColumn get backdropUrl => text().nullable()();
  RealColumn get rating => real()();
  TextColumn get year => text().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get type => text()();

  IntColumn get typeId => integer().nullable()();
  IntColumn get typeId1 => integer().nullable()();
  TextColumn get actor => text().nullable()();
  TextColumn get blurb => text().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get version => text().nullable()();
  BoolColumn get vip => boolean().nullable()();
  IntColumn get vodTime => integer().nullable()();
  IntColumn get hits => integer().nullable()();

  TextColumn get genres => text().map(const StringListConverter()).nullable()();

  TextColumn get description => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get director => text().nullable()();
  TextColumn get writer => text().nullable()();
  TextColumn get lang => text().nullable()();

  TextColumn get urls =>
      text().map(const VideoEpisodeListConverter()).nullable()();
}

@TableIndex(
  name: 'video_settings_idx',
  columns: {#sourceId, #videoId},
  unique: true,
)
class VideoSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text().nullable()(); // Removed unique()
  IntColumn get videoId => integer()();
  IntColumn get introDuration => integer().withDefault(const Constant(0))();
  IntColumn get outroDuration => integer().withDefault(const Constant(0))();
}

@TableIndex(
  name: 'video_history_idx',
  columns: {#sourceId, #videoId},
  unique: true,
)
class VideoHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text().nullable()(); // Removed unique()
  IntColumn get videoId => integer()();

  TextColumn get videoTitle => text()();
  TextColumn get coverUrl => text()();

  TextColumn get rating => text().nullable()();
  TextColumn get type => text()();
  TextColumn get region => text().nullable()();
  TextColumn get year => text().nullable()();
  TextColumn get actor => text().nullable()();
  TextColumn get version => text().nullable()();
  IntColumn get hits => integer().nullable()();
  TextColumn get remarks => text().nullable()();
  TextColumn get blurb => text().nullable()();

  IntColumn get lastEpisodeIndex => integer()();
  TextColumn get lastEpisodeTitle => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();
}

@TableIndex(
  name:
      'episode_history_idx', // Renamed for consistency (was episode_lookup_idx)
  columns: {
    #videoId,
    #episodeIndex,
    #sourceId,
  }, // Added sourceId to unique constraint?
  unique: true,
)
// Wait, Isar EpisodeHistory was unique on (videoId, episodeIndex)?
// But what if same video ID in different source?
// Yes, sourceId MUST be part of uniqueness if videoId is not globally unique.
// Isar `EpisodeHistorySchema` had Id id = Isar.autoIncrement.
// Indices?
// Schema Plan Step 130: `columns: {#videoId, #episodeIndex}, unique: true`.
// But Drift Table definition had `sourceId`.
// If `videoId` collides between sources, this is a bug in my plan.
// I should add `sourceId` to uniqueness for EpisodeHistory too.
class EpisodeHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceId => text().nullable()();

  IntColumn get videoId => integer()();
  IntColumn get episodeIndex => integer()();

  IntColumn get positionMillis => integer()();
  IntColumn get durationMillis => integer()();

  DateTimeColumn get updatedAt => dateTime()();
}

class DownloadTasks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get taskId => text().unique()();
  IntColumn get videoId => integer()();

  TextColumn get videoTitle => text()();
  TextColumn get coverUrl => text().nullable()();

  TextColumn get episodes => text().map(const EpisodeDownloadListConverter())();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
}

class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get downloadPath => text().nullable()();
  BoolColumn get enableThumbnailPreview =>
      boolean().withDefault(const Constant(false))();
  IntColumn get maxConcurrentDownloads =>
      integer().withDefault(const Constant(3))();
  TextColumn get lastDataSourceId => text().nullable()();

  IntColumn get themeMode => integer().withDefault(const Constant(0))();

  RealColumn get playerNormalWidth => real().nullable()();
  RealColumn get playerNormalHeight => real().nullable()();
  RealColumn get playerPipWidth => real().nullable()();
  RealColumn get playerPipHeight => real().nullable()();

  TextColumn get locale => text().nullable()();
}

@DriftDatabase(
  tables: [
    Videos,
    VideoSettings,
    VideoHistory,
    EpisodeHistory,
    DownloadTasks,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'vidradb.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
