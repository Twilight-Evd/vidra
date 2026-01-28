import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'sentry_config.dart';

/// Performance monitoring wrapper for video player operations
///
/// This class provides methods to wrap video player operations with Sentry
/// performance tracking. Each operation creates a transaction that is
/// automatically finished and includes relevant tags and data for aggregation.
class VideoPerformanceMonitor {
  static String? _currentVideoId;
  static String? _currentResolution;
  static int? _currentEpisodeIndex;
  static int? _videoDuration;

  /// Set the current video context for all subsequent operations
  ///
  /// Call this when a new video is loaded to ensure all operations
  /// are tagged with the correct video information.
  ///
  /// Example:
  /// ```dart
  /// VideoPerformanceMonitor.setVideoContext(
  ///   videoId: '12345',
  ///   resolution: '1080p',
  ///   episodeIndex: 0,
  ///   duration: 3600000, // milliseconds
  /// );
  /// ```
  static void setVideoContext({
    required String videoId,
    String? resolution,
    int? episodeIndex,
    int? duration,
  }) {
    _currentVideoId = videoId;
    _currentResolution = resolution;
    _currentEpisodeIndex = episodeIndex;
    _videoDuration = duration;
  }

  /// Clear the current video context
  static void clearVideoContext() {
    _currentVideoId = null;
    _currentResolution = null;
    _currentEpisodeIndex = null;
    _videoDuration = null;
  }

  /// Get common tags for video operations
  static Map<String, String> _getCommonTags() {
    final tags = <String, String>{};

    if (_currentVideoId != null) {
      tags['videoId'] = _currentVideoId!;
    }

    if (_currentResolution != null) {
      tags['resolution'] = _currentResolution!;
    }

    // Add device model
    if (Platform.isMacOS) {
      tags['deviceModel'] = 'macOS';
    } else if (Platform.isWindows) {
      tags['deviceModel'] = 'Windows';
    } else if (Platform.isLinux) {
      tags['deviceModel'] = 'Linux';
    }

    // Add platform
    tags['platform'] = Platform.operatingSystem;

    return tags;
  }

  /// Get common data for video operations
  static Map<String, dynamic> _getCommonData({int? currentPosition}) {
    final data = <String, dynamic>{};

    if (_currentEpisodeIndex != null) {
      data['episodeIndex'] = _currentEpisodeIndex;
    }

    if (_videoDuration != null) {
      data['duration'] = _videoDuration;
    }

    if (currentPosition != null) {
      data['currentPosition'] = currentPosition;

      // Calculate progress percentage
      if (_videoDuration != null && _videoDuration! > 0) {
        data['progressPercent'] = (currentPosition / _videoDuration! * 100)
            .toStringAsFixed(2);
      }
    }

    return data;
  }

  /// Track video play operation
  ///
  /// Wraps a play operation with performance tracking.
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackPlayback(
  ///   operation: () async => await player.play(),
  ///   currentPosition: 1500,
  /// );
  /// ```
  static Future<T> trackPlayback<T>({
    required Future<T> Function() operation,
    int? currentPosition,
  }) async {
    return _trackOperation(
      name: 'video_playback_play',
      operation: operation,
      currentPosition: currentPosition,
    );
  }

  /// Track video pause operation
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackPause(
  ///   operation: () async => await player.pause(),
  ///   currentPosition: 1500,
  /// );
  /// ```
  static Future<T> trackPause<T>({
    required Future<T> Function() operation,
    int? currentPosition,
  }) async {
    return _trackOperation(
      name: 'video_playback_pause',
      operation: operation,
      currentPosition: currentPosition,
    );
  }

  /// Track video seek operation
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackSeek(
  ///   operation: () async => await player.seek(Duration(seconds: 30)),
  ///   fromPosition: 1500,
  ///   toPosition: 30000,
  /// );
  /// ```
  static Future<T> trackSeek<T>({
    required Future<T> Function() operation,
    int? fromPosition,
    int? toPosition,
  }) async {
    final data = _getCommonData(currentPosition: fromPosition);
    if (toPosition != null) {
      data['seekToPosition'] = toPosition;
      if (fromPosition != null) {
        data['seekDistance'] = (toPosition - fromPosition).abs();
      }
    }

    return _trackOperationWithData(
      name: 'video_playback_seek',
      operation: operation,
      additionalData: data,
    );
  }

  /// Track video stop operation
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackStop(
  ///   operation: () async => await player.stop(),
  ///   currentPosition: 1500,
  /// );
  /// ```
  static Future<T> trackStop<T>({
    required Future<T> Function() operation,
    int? currentPosition,
  }) async {
    return _trackOperation(
      name: 'video_playback_stop',
      operation: operation,
      currentPosition: currentPosition,
    );
  }

  /// Track video buffering event
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackBuffering(
  ///   operation: () async => await waitForBuffer(),
  ///   currentPosition: 1500,
  /// );
  /// ```
  static Future<T> trackBuffering<T>({
    required Future<T> Function() operation,
    int? currentPosition,
  }) async {
    return _trackOperation(
      name: 'video_playback_buffering',
      operation: operation,
      currentPosition: currentPosition,
    );
  }

  /// Track episode switch operation
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackEpisodeSwitch(
  ///   operation: () async => await player.switchEpisode(1),
  ///   fromEpisode: 0,
  ///   toEpisode: 1,
  /// );
  /// ```
  static Future<T> trackEpisodeSwitch<T>({
    required Future<T> Function() operation,
    int? fromEpisode,
    int? toEpisode,
  }) async {
    final data = _getCommonData();
    if (fromEpisode != null) {
      data['fromEpisode'] = fromEpisode;
    }
    if (toEpisode != null) {
      data['toEpisode'] = toEpisode;
    }

    return _trackOperationWithData(
      name: 'video_playback_episode_switch',
      operation: operation,
      additionalData: data,
    );
  }

  /// Track quality change operation
  ///
  /// Example:
  /// ```dart
  /// await VideoPerformanceMonitor.trackQualityChange(
  ///   operation: () async => await player.setQuality('1080p'),
  ///   fromQuality: '720p',
  ///   toQuality: '1080p',
  /// );
  /// ```
  static Future<T> trackQualityChange<T>({
    required Future<T> Function() operation,
    String? fromQuality,
    String? toQuality,
  }) async {
    final data = _getCommonData();
    if (fromQuality != null) {
      data['fromQuality'] = fromQuality;
    }
    if (toQuality != null) {
      data['toQuality'] = toQuality;
    }

    return _trackOperationWithData(
      name: 'video_playback_quality_change',
      operation: operation,
      additionalData: data,
    );
  }

  /// Generic operation tracking with current position
  static Future<T> _trackOperation<T>({
    required String name,
    required Future<T> Function() operation,
    int? currentPosition,
  }) async {
    final data = _getCommonData(currentPosition: currentPosition);
    return _trackOperationWithData(
      name: name,
      operation: operation,
      additionalData: data,
    );
  }

  /// Generic operation tracking with custom data
  static Future<T> _trackOperationWithData<T>({
    required String name,
    required Future<T> Function() operation,
    Map<String, dynamic>? additionalData,
  }) async {
    // Skip tracking in debug mode to reduce overhead during development
    if (kDebugMode) {
      return await operation();
    }

    final transaction = SentryConfig.startTransaction(
      name: name,
      operation: 'ui.action',
      tags: _getCommonTags(),
      data: additionalData,
    );

    try {
      final result = await operation();
      transaction.status = const SpanStatus.ok();
      return result;
    } catch (e, stackTrace) {
      transaction.status = const SpanStatus.internalError();
      transaction.throwable = e;

      // Capture the exception
      await SentryConfig.captureException(
        e,
        stackTrace: stackTrace,
        tags: {'operation': name},
      );

      rethrow;
    } finally {
      await transaction.finish();
    }
  }

  /// Add a breadcrumb for a video event
  ///
  /// Use this for events that don't need full transaction tracking.
  ///
  /// Example:
  /// ```dart
  /// VideoPerformanceMonitor.addVideoBreadcrumb(
  ///   message: 'Video loaded',
  ///   data: {'videoId': '123', 'duration': 3600000},
  /// );
  /// ```
  static void addVideoBreadcrumb({
    required String message,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    final breadcrumbData = <String, dynamic>{
      ..._getCommonData(),
      if (data != null) ...data,
    };

    SentryConfig.addBreadcrumb(
      message: message,
      category: 'video.player',
      data: breadcrumbData,
      level: level,
    );
  }
}
