import 'dart:async'; // Add async import
import 'package:vidra_player/core/interfaces/media_repository.dart';
import 'package:vidra_player/core/model/model.dart' as vidra_model;
import '../../features/video/data/video_repository.dart';
import '../../features/video/domain/play_history.dart' as domain;
import '../../features/video/domain/video_settings.dart' as domain;

// Utility for throttling native database/channel calls
class _HistoryThrottler {
  final Duration _duration;
  Timer? _timer;

  _HistoryThrottler(this._duration);

  void run(void Function() action) {
    if (_timer?.isActive ?? false) return;
    _timer = Timer(_duration, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class VidraMediaRepository implements MediaRepository {
  final VideoRepository _videoRepository;

  // Throttle saves to once every 5 seconds to reduce native pressure and leaks
  final _saveThrottler = _HistoryThrottler(const Duration(seconds: 5));

  final Map<String, int> _lastSavedPosition = {};

  VidraMediaRepository(this._videoRepository);

  void dispose() {
    _saveThrottler.dispose();
  }

  ({int apiId, String? sourceId}) _parseVideoId(String videoId) {
    final parts = videoId.split('_');
    if (parts.length >= 2) {
      final apiId = int.tryParse(parts[0]) ?? -1;
      final sourceStr = parts.sublist(1).join('_');
      final sourceId = String.fromCharCodes(sourceStr.codeUnits);
      return (apiId: apiId, sourceId: sourceId);
    }
    return (apiId: int.tryParse(videoId) ?? -1, sourceId: null);
  }

  @override
  Future<List<vidra_model.EpisodeHistory>> getEpisodeHistories({
    required String videoId,
  }) async {
    final parsed = _parseVideoId(videoId);
    final histories = await _videoRepository.getEpisodeHistories(
      parsed.apiId,
      parsed.sourceId,
    );
    return histories
        .map(
          (h) => vidra_model.EpisodeHistory(
            index: h.episodeIndex,
            positionMillis: h.positionMillis,
            durationMillis: h.durationMillis,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveEpisodeHistory(
    String videoId,
    vidra_model.EpisodeHistory history,
  ) async {
    // 1. Fast check: if position change is less than 1 second, skip (Fast check)
    final cacheKey = "${videoId}_${history.index}";
    final lastPos = _lastSavedPosition[cacheKey] ?? 0;
    if ((history.positionMillis - lastPos).abs() < 1000) {
      return;
    }

    final parsed = _parseVideoId(videoId);

    // 2. Throttle the actual heavy save operation (DB + potential native calls)
    _saveThrottler.run(() async {
      // Save progress only (lightweight operation)
      final domainHistory = domain.EpisodeHistory.withValues(
        videoId: parsed.apiId,
        episodeIndex: history.index,
        positionMillis: history.positionMillis,
        durationMillis: history.durationMillis,
        sourceId: parsed.sourceId,
      );

      await _videoRepository.saveEpisodeHistory(domainHistory);
      _lastSavedPosition[cacheKey] = history.positionMillis;

      // 3. Update VideoHistory (affects recent play list)
      _maybeUpdateVideoHistory(parsed, history);
    });
  }

  /// Internal method: low frequency update of video metadata
  Future<void> _maybeUpdateVideoHistory(
    ({int apiId, String? sourceId}) parsed,
    vidra_model.EpisodeHistory history,
  ) async {
    // Logic: update every minute, or only on first play
    // Keep it simple: update if it's the first minute, or if it's been a long time since last update
    // This can effectively reduce the frequency of "olevod" string creation in memory
    final video = await _videoRepository.getVideo(
      parsed.apiId,
      sourceId: parsed.sourceId,
    );
    if (video != null) {
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
    }
  }

  @override
  Future<vidra_model.PlayerSetting> getPlayerSettings({
    required String videoId,
  }) async {
    final parsed = _parseVideoId(videoId);
    final settings = await _videoRepository.getVideoSettings(
      parsed.apiId,
      parsed.sourceId,
    );
    return vidra_model.PlayerSetting(
      videoId: videoId,
      autoSkip: true,
      skipIntro: settings.introDuration,
      skipOutro: settings.outroDuration,
    );
  }

  @override
  Future<void> savePlayerSettings(vidra_model.PlayerSetting setting) async {
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
