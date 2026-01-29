// ignore_for_file: avoid_print, unnecessary_brace_in_string_interps
import 'package:isar/isar.dart';
import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../../src/features/video/domain/video_collection.dart';
import '../../src/features/video/domain/video_settings.dart';
import '../../src/features/video/domain/play_history.dart';
import '../../src/features/download/domain/download_task.dart';
import '../../src/features/settings/domain/app_settings.dart';

import 'app_database.dart';

Future<void> migrateFromIsar(AppDatabase driftDb) async {
  final dir = await getApplicationDocumentsDirectory();
  final isarDir = dir.path;

  // Check if Isar DB exists
  // Isar creates 'default.isar' and 'default.isar.lock' usually
  final isarFile = File('${isarDir}/default.isar');
  if (!isarFile.existsSync()) {
    print('No Isar database found at ${isarFile.path}. Skipping migration.');
    return;
  }

  print('Starting migration from Isar...');

  late Isar isar;
  try {
    isar = await Isar.open(
      [
        VideoSchema,
        VideoSettingsSchema,
        VideoHistorySchema,
        EpisodeHistorySchema,
        DownloadTaskSchema,
        AppSettingsSchema,
      ],
      directory: isarDir,
      name: 'default', // Default name used in main.dart
      inspector: false,
    );
  } catch (e) {
    print('Failed to open Isar for migration: $e');
    return;
  }

  // Transaction for safety
  await driftDb.transaction(() async {
    // 1. AppSettings
    final appSettingsList = await isar.appSettings.where().findAll();
    if (appSettingsList.isNotEmpty) {
      final s = appSettingsList.first;
      await driftDb
          .into(driftDb.appSettings)
          .insert(
            AppSettingsCompanion(
              // Singleton ID usually 0 or 1. Isar uses 0. Drift autoInc starts at 1 usually but we can force.
              // Let's force ID 1 for Drift singletons or just use whatever.
              // But to be safe, let's let Drift decide or keep mapping.
              // Isar appSettings usually has id = 0.
              id: drift.Value(1),
              downloadPath: drift.Value(s.downloadPath),
              enableThumbnailPreview: drift.Value(s.enableThumbnailPreview),
              maxConcurrentDownloads: drift.Value(s.maxConcurrentDownloads),
              lastDataSourceId: drift.Value(s.lastDataSourceId),
              themeMode: drift.Value(s.themeMode.index), // Enum index
              playerNormalWidth: drift.Value(s.playerNormalWidth),
              playerNormalHeight: drift.Value(s.playerNormalHeight),
              playerPipWidth: drift.Value(s.playerPipWidth),
              playerPipHeight: drift.Value(s.playerPipHeight),
              locale: drift.Value(s.locale),
            ),
            mode: drift.InsertMode.insertOrReplace,
          );
    }
    print('Migrated AppSettings');

    // 2. Videos
    final videos = await isar.videos.where().findAll();
    if (videos.isNotEmpty) {
      await driftDb.batch((batch) {
        batch.insertAll(
          driftDb.videos,
          videos.map(
            (v) => VideosCompanion.insert(
              sourceId: drift.Value(v.sourceId),
              apiId: v.apiId,
              title: v.title,
              coverUrl: v.coverUrl,
              thumbUrl: drift.Value(v.thumbUrl),
              backdropUrl: drift.Value(v.backdropUrl),
              rating: v.rating,
              year: drift.Value(v.year),
              region: drift.Value(v.region),
              type: v.type,
              typeId: drift.Value(v.typeId),
              typeId1: drift.Value(v.typeId1),
              actor: drift.Value(v.actor),
              blurb: drift.Value(v.blurb),
              remarks: drift.Value(v.remarks),
              version: drift.Value(v.version),
              vip: drift.Value(v.vip),
              vodTime: drift.Value(v.vodTime),
              hits: drift.Value(v.hits),
              genres: drift.Value(v.genres ?? []),
              description: drift.Value(v.description),
              content: drift.Value(v.content),
              director: drift.Value(v.director),
              writer: drift.Value(v.writer),
              lang: drift.Value(v.lang),
              urls: drift.Value(v.urls ?? []),
            ),
          ),
        );
      });
    }
    print('Migrated ${videos.length} Videos');

    // 3. VideoSettings
    final vSettings = await isar.videoSettings.where().findAll();
    if (vSettings.isNotEmpty) {
      await driftDb.batch((batch) {
        batch.insertAll(
          driftDb.videoSettings,
          vSettings.map(
            (v) => VideoSettingsCompanion.insert(
              sourceId: drift.Value(v.sourceId),
              videoId: v.videoId,
              introDuration: drift.Value(v.introDuration),
              outroDuration: drift.Value(v.outroDuration),
            ),
          ),
        );
      });
    }
    print('Migrated ${vSettings.length} VideoSettings');

    // 4. VideoHistory
    final vHistory = await isar.videoHistorys.where().findAll();
    if (vHistory.isNotEmpty) {
      await driftDb.batch((batch) {
        batch.insertAll(
          driftDb.videoHistory,
          vHistory.map(
            (v) => VideoHistoryCompanion.insert(
              sourceId: drift.Value(v.sourceId),
              videoId: v.videoId,
              videoTitle: v.videoTitle,
              coverUrl: v.coverUrl,
              rating: drift.Value(v.rating),
              type: v.type,
              region: drift.Value(v.region),
              year: drift.Value(v.year),
              actor: drift.Value(v.actor),
              version: drift.Value(v.version),
              hits: drift.Value(v.hits),
              remarks: drift.Value(v.remarks),
              blurb: drift.Value(v.blurb),
              lastEpisodeIndex: v.lastEpisodeIndex,
              lastEpisodeTitle: drift.Value(v.lastEpisodeTitle),
              updatedAt: v.updatedAt,
            ),
          ),
        );
      });
    }
    print('Migrated ${vHistory.length} VideoHistory records');

    // 5. EpisodeHistory
    final eHistory = await isar.episodeHistorys.where().findAll();
    if (eHistory.isNotEmpty) {
      await driftDb.batch((batch) {
        batch.insertAll(
          driftDb.episodeHistory,
          eHistory.map(
            (e) => EpisodeHistoryCompanion.insert(
              sourceId: drift.Value(e.sourceId),
              videoId: e.videoId,
              episodeIndex: e.episodeIndex,
              positionMillis: e.positionMillis,
              durationMillis: e.durationMillis,
              updatedAt: e.updatedAt,
            ),
          ),
        );
      });
    }
    print('Migrated ${eHistory.length} EpisodeHistory records');

    // 6. DownloadTasks
    final tasks = await isar.downloadTasks.where().findAll();
    if (tasks.isNotEmpty) {
      await driftDb.batch((batch) {
        batch.insertAll(
          driftDb.downloadTasks,
          tasks.map(
            (t) => DownloadTasksCompanion.insert(
              taskId: t.taskId,
              videoId: t.videoId,
              videoTitle: t.videoTitle,
              coverUrl: drift.Value(t.coverUrl),
              episodes: t.episodes,
              createdAt: t.createdAt,
              completedAt: drift.Value(t.completedAt),
            ),
          ),
        );
      });
    }
    print('Migrated ${tasks.length} DownloadTasks');
  });

  await isar.close();

  // Backup Isar file
  try {
    final backupFile = File('${isarFile.path}.backup');
    if (await backupFile.exists()) {
      await backupFile.delete();
    }
    await isarFile.rename(backupFile.path);
    print('Isar database backed up to ${backupFile.path}');

    final lockFile = File('${isarDir}/default.isar.lock');
    if (await lockFile.exists()) {
      await lockFile.rename('${isarDir}/default.isar.lock.backup');
    }
  } catch (e) {
    print('Error backing up Isar files: $e');
  }
}
