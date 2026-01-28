import 'package:vidra_player/core/interfaces/performance_monitor.dart';
import '../monitoring/video_performance_monitor.dart';
import '../monitoring/sentry_config.dart';

/// Sentry implementation of PlayerPerformanceMonitor
///
/// This class implements the performance monitoring interface using Sentry,
/// allowing automatic tracking of all vidra_player operations.
///
/// Usage:
/// ```dart
/// final controller = PlayerController(
///   config: config,
///   video: video,
///   episodes: episodes,
///   player: player,
///   performanceMonitor: SentryPlayerMonitor(),
/// );
/// ```
class SentryPlayerMonitor implements PlayerPerformanceMonitor {
  @override
  Future<T> trackPlay<T>(
    Future<T> Function() operation, {
    int? currentPositionMs,
  }) async {
    return await VideoPerformanceMonitor.trackPlayback(
      operation: operation,
      currentPosition: currentPositionMs,
    );
  }

  @override
  Future<T> trackPause<T>(
    Future<T> Function() operation, {
    int? currentPositionMs,
  }) async {
    return await VideoPerformanceMonitor.trackPause(
      operation: operation,
      currentPosition: currentPositionMs,
    );
  }

  @override
  Future<T> trackSeek<T>(
    Future<T> Function() operation, {
    required int fromMs,
    required int toMs,
  }) async {
    return await VideoPerformanceMonitor.trackSeek(
      operation: operation,
      fromPosition: fromMs,
      toPosition: toMs,
    );
  }

  @override
  Future<T> trackEpisodeSwitch<T>(
    Future<T> Function() operation, {
    required int fromEpisode,
    required int toEpisode,
  }) async {
    return await VideoPerformanceMonitor.trackEpisodeSwitch(
      operation: operation,
      fromEpisode: fromEpisode,
      toEpisode: toEpisode,
    );
  }

  @override
  Future<T> trackQualitySwitch<T>(
    Future<T> Function() operation, {
    String? fromQuality,
    String? toQuality,
  }) async {
    return await VideoPerformanceMonitor.trackQualityChange(
      operation: operation,
      fromQuality: fromQuality,
      toQuality: toQuality,
    );
  }

  @override
  Future<T> trackEpisodeLoad<T>(
    Future<T> Function() operation, {
    required int episodeIndex,
    bool isSwitching = false,
  }) async {
    // Track as async operation
    return await operation(); // Can be enhanced with specific tracking
  }

  @override
  void onBufferingStart({int? currentPositionMs}) {
    VideoPerformanceMonitor.addVideoBreadcrumb(
      message: 'Buffering started',
      data: {if (currentPositionMs != null) 'position': currentPositionMs},
    );
  }

  @override
  void onBufferingEnd({int? currentPositionMs, int? durationMs}) {
    VideoPerformanceMonitor.addVideoBreadcrumb(
      message: 'Buffering ended',
      data: {
        if (currentPositionMs != null) 'position': currentPositionMs,
        if (durationMs != null) 'durationMs': durationMs,
      },
    );
  }

  @override
  void onError(dynamic error, StackTrace? stackTrace, {String? context}) {
    SentryConfig.captureException(
      error,
      stackTrace: stackTrace,
      tags: {if (context != null) 'context': context, 'source': 'vidra_player'},
    );
  }

  @override
  void onPlaybackComplete({required int episodeIndex, int? duration}) {
    VideoPerformanceMonitor.addVideoBreadcrumb(
      message: 'Playback completed',
      data: {
        'episodeIndex': episodeIndex,
        if (duration != null) 'duration': duration,
      },
    );
  }

  @override
  void setVideoContext({
    required String videoId,
    int? episodeIndex,
    String? quality,
  }) {
    VideoPerformanceMonitor.setVideoContext(
      videoId: videoId,
      episodeIndex: episodeIndex,
      resolution: quality,
    );
  }

  @override
  void clearContext() {
    VideoPerformanceMonitor.clearVideoContext();
  }

  @override
  void logEvent(String event, Map<String, dynamic>? data) {
    VideoPerformanceMonitor.addVideoBreadcrumb(message: event, data: data);
  }
}
