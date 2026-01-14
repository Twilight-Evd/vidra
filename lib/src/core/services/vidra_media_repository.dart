import 'package:vidra_player/core/interfaces/media_repository.dart';
import 'package:vidra_player/core/model/model.dart' as vidra_model;
import 'package:vidra_player/utils/log.dart';
import '../../features/video/data/video_repository.dart';
import '../../features/video/domain/play_history.dart' as domain;
import '../../features/video/domain/video_settings.dart' as domain;

class VidraMediaRepository implements MediaRepository {
  final VideoRepository _videoRepository;

  VidraMediaRepository(this._videoRepository);

  /// Splits the composite videoId "{apiId}_{sourceId}" into components.
  ({int apiId, String? sourceId}) _parseVideoId(String videoId) {
    final parts = videoId.split('_');
    if (parts.length >= 2) {
      final apiId = int.tryParse(parts[0]) ?? -1;
      final sourceId = parts.sublist(1).join('_');
      return (apiId: apiId, sourceId: sourceId);
    }
    return (apiId: int.tryParse(videoId) ?? -1, sourceId: null);
  }

  @override
  Future<List<vidra_model.EpisodeHistory>> getEpisodeHistories({
    required String videoId,
  }) async {
    final parsed = _parseVideoId(videoId);
    logger.d(
      "[VidraMediaRepository] Fetching histories for $videoId (parsed: $parsed)",
    );
    final histories = await _videoRepository.getEpisodeHistories(
      parsed.apiId,
      parsed.sourceId,
    );

    logger.d("[VidraMediaRepository] Found ${histories.length} histories");
    return histories.map((h) {
      return vidra_model.EpisodeHistory(
        index: h.episodeIndex,
        positionMillis: h.positionMillis,
        durationMillis: h.durationMillis,
      );
    }).toList();
  }

  @override
  Future<void> saveEpisodeHistory(
    String videoId,
    vidra_model.EpisodeHistory history,
  ) async {
    logger.d(
      "[VidraMediaRepository] SaveEpisodeHistory: $videoId, index: ${history.index}, pos: ${history.positionMillis}",
    );
    final parsed = _parseVideoId(videoId);

    // 1. Save episode progress
    final domainHistory = domain.EpisodeHistory.withValues(
      videoId: parsed.apiId,
      episodeIndex: history.index,
      positionMillis: history.positionMillis,
      durationMillis: history.durationMillis,
      sourceId: parsed.sourceId,
    );
    await _videoRepository.saveEpisodeHistory(domainHistory);

    // 2. Also save/update VideoHistory (for Recent list)
    final video = await _videoRepository.getVideo(
      parsed.apiId,
      sourceId: parsed.sourceId,
    );
    if (video != null) {
      logger.d(
        "[VidraMediaRepository] Found video for history: ${video.title}",
      );
      final lastEpisode =
          (video.urls != null && video.urls!.length > history.index)
          ? video.urls![history.index]
          : null;

      final videoHistory = domain.VideoHistory.withValues(
        videoId: parsed.apiId,
        videoTitle: video.title,
        coverUrl: video.coverUrl,
        lastEpisodeIndex: history.index,
        lastEpisodeTitle: lastEpisode?.title,
        type: video.type,
        rating: video.rating.toString(),
        region: video.region,
        year: video.year,
        actor: video.actor,
        version: video.version,
        hits: video.hits,
        remarks: video.remarks,
        blurb: video.blurb,
        sourceId: parsed.sourceId,
      );
      await _videoRepository.saveVideoHistory(videoHistory);
      logger.d("[VidraMediaRepository] VideoHistory saved for ${video.title}");
    } else {
      logger.w(
        "[VidraMediaRepository] Video NOT FOUND for history saving: $parsed",
      );
    }
  }

  @override
  Future<vidra_model.PlayerSetting> getPlayerSettings({
    required String videoId,
  }) async {
    final parsed = _parseVideoId(videoId);
    logger.d(
      "[VidraMediaRepository] Fetching settings for $videoId (parsed: $parsed)",
    );
    final settings = await _videoRepository.getVideoSettings(
      parsed.apiId,
      parsed.sourceId,
    );

    return vidra_model.PlayerSetting(
      videoId: videoId,
      autoSkip: true, // Default to true as per existing logic
      skipIntro: settings.introDuration,
      skipOutro: settings.outroDuration,
    );
  }

  @override
  Future<void> savePlayerSettings(vidra_model.PlayerSetting setting) async {
    logger.d("[VidraMediaRepository] Saving settings for ${setting.videoId}");
    final parsed = _parseVideoId(setting.videoId);
    final domainSettings = domain.VideoSettings.withValues(
      videoId: parsed.apiId,
      sourceId: parsed.sourceId,
      introDuration: setting.skipIntro,
      outroDuration: setting.skipOutro,
    );
    await _videoRepository.saveVideoSettings(domainSettings);
  }
}
