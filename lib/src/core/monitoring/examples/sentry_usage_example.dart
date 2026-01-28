// ignore_for_file: unused_local_variable, unused_element

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../sentry_config.dart';
import '../video_performance_monitor.dart';
import '../frame_performance_monitor.dart';
import '../network_performance_monitor.dart';

/// This file contains complete working examples of how to use Sentry
/// performance monitoring in the Vidra video player application.
///
/// These examples demonstrate:
/// - Video player operation tracking
/// - Network request tracking
/// - Custom async operation tracking
/// - How to add custom tags and data
/// - Error handling patterns

class SentryUsageExamples {
  // ============================================================================
  // EXAMPLE 1: Video Player Monitoring
  // ============================================================================

  /// Example: Track video playback with full context
  Future<void> exampleVideoPlayback() async {
    // First, set the video context
    VideoPerformanceMonitor.setVideoContext(
      videoId: '12345',
      resolution: '1080p',
      episodeIndex: 0,
      duration: 3600000, // 1 hour in milliseconds
    );

    // Track play operation
    await VideoPerformanceMonitor.trackPlayback(
      operation: () async {
        // Your actual player play logic here
        // await player.play();
        await Future.delayed(const Duration(milliseconds: 100));
      },
      currentPosition: 1500, // Current position in milliseconds
    );

    // Track pause operation
    await VideoPerformanceMonitor.trackPause(
      operation: () async {
        // await player.pause();
        await Future.delayed(const Duration(milliseconds: 50));
      },
      currentPosition: 5000,
    );

    // Track seek operation
    await VideoPerformanceMonitor.trackSeek(
      operation: () async {
        // await player.seek(Duration(seconds: 30));
        await Future.delayed(const Duration(milliseconds: 200));
      },
      fromPosition: 5000,
      toPosition: 30000,
    );

    // Track episode switch
    await VideoPerformanceMonitor.trackEpisodeSwitch(
      operation: () async {
        // await player.switchEpisode(1);
        await Future.delayed(const Duration(milliseconds: 500));
      },
      fromEpisode: 0,
      toEpisode: 1,
    );

    // Track quality change
    await VideoPerformanceMonitor.trackQualityChange(
      operation: () async {
        // await player.setQuality('1080p');
        await Future.delayed(const Duration(milliseconds: 300));
      },
      fromQuality: '720p',
      toQuality: '1080p',
    );

    // Add breadcrumb for non-critical events
    VideoPerformanceMonitor.addVideoBreadcrumb(
      message: 'Video loaded successfully',
      data: {'videoId': '12345', 'duration': 3600000, 'format': 'mp4'},
    );

    // Clear context when done
    VideoPerformanceMonitor.clearVideoContext();
  }

  // ============================================================================
  // EXAMPLE 2: Network Request Monitoring
  // ============================================================================

  /// Example: Track network requests with full context
  Future<void> exampleNetworkRequests() async {
    // Track a GET request
    final videos = await NetworkPerformanceMonitor.trackNetworkRequest(
      operation: () async {
        // Your actual network request here
        // return await dio.get('/api/videos');
        await Future.delayed(const Duration(milliseconds: 500));
        return <String, dynamic>{
          'data': [
            {'id': 1, 'title': 'Video 1'},
            {'id': 2, 'title': 'Video 2'},
          ],
          'statusCode': 200,
        };
      },
      endpoint: '/api/videos',
      method: 'GET',
      tags: {'userId': 'user123', 'category': 'action'},
      data: {'limit': 50, 'offset': 0},
    );

    // Track a POST request
    final result = await NetworkPerformanceMonitor.trackNetworkRequest(
      operation: () async {
        // return await dio.post('/api/videos/123/view');
        await Future.delayed(const Duration(milliseconds: 200));
        return {
          'statusCode': 201,
          'data': {'success': true},
        };
      },
      endpoint: '/api/videos/123/view',
      method: 'POST',
      tags: {'videoId': '123'},
    );

    // Add breadcrumb for network events
    NetworkPerformanceMonitor.addNetworkBreadcrumb(
      message: 'API request started',
      endpoint: '/api/videos',
      method: 'GET',
      data: {'retryCount': 0},
    );
  }

  // ============================================================================
  // EXAMPLE 3: Async Business Logic Monitoring
  // ============================================================================

  /// Example: Track async business logic operations
  Future<void> exampleAsyncOperations() async {
    // Track video list loading
    final videos = await NetworkPerformanceMonitor.trackAsyncOperation(
      name: 'load_video_list',
      operation: () async {
        // Your business logic here
        // return await videoRepository.getVideos();
        await Future.delayed(const Duration(milliseconds: 300));
        return ['video1', 'video2', 'video3'];
      },
      tags: {'category': 'action', 'sortBy': 'recent'},
      data: {'limit': 50, 'cacheHit': false},
    );

    // Track video metadata processing
    final metadata = await NetworkPerformanceMonitor.trackAsyncOperation(
      name: 'process_video_metadata',
      operation: () async {
        // await processMetadata();
        await Future.delayed(const Duration(milliseconds: 150));
        return {'title': 'Video Title', 'duration': 3600};
      },
      tags: {'videoId': '123'},
    );

    // Track thumbnail generation
    final thumbnail = await NetworkPerformanceMonitor.trackAsyncOperation(
      name: 'generate_thumbnail',
      operation: () async {
        // await generateThumbnail();
        await Future.delayed(const Duration(milliseconds: 800));
        return 'thumbnail_url';
      },
      tags: {'videoId': '123', 'size': 'medium'},
      data: {'width': 320, 'height': 180},
    );
  }

  // ============================================================================
  // EXAMPLE 4: Database Operation Monitoring
  // ============================================================================

  /// Example: Track database operations
  Future<void> exampleDatabaseOperations() async {
    // Track database query
    final videos = await NetworkPerformanceMonitor.trackDatabaseOperation(
      operation: () async {
        // return await isar.videos.where().findAll();
        await Future.delayed(const Duration(milliseconds: 100));
        return ['video1', 'video2'];
      },
      operationType: 'query',
      collection: 'videos',
      tags: {'filter': 'recent'},
    );

    // Track database write
    await NetworkPerformanceMonitor.trackDatabaseOperation(
      operation: () async {
        // await isar.writeTxn(() => isar.videos.put(video));
        await Future.delayed(const Duration(milliseconds: 50));
      },
      operationType: 'write',
      collection: 'videos',
      data: {'recordCount': 1},
    );

    // Track database delete
    await NetworkPerformanceMonitor.trackDatabaseOperation(
      operation: () async {
        // await isar.writeTxn(() => isar.videos.delete(id));
        await Future.delayed(const Duration(milliseconds: 30));
      },
      operationType: 'delete',
      collection: 'videos',
      tags: {'videoId': '123'},
    );
  }

  // ============================================================================
  // EXAMPLE 5: Custom Render Operation Monitoring
  // ============================================================================

  /// Example: Track custom UI render operations
  Future<void> exampleRenderOperations() async {
    // Track video list rendering
    await FramePerformanceMonitor.trackRenderOperation(
      name: 'video_list_render',
      operation: () async {
        // await buildVideoList();
        await Future.delayed(const Duration(milliseconds: 200));
      },
      tags: {'listSize': '50', 'viewType': 'grid'},
      data: {'itemCount': 50, 'cacheHit': true},
    );

    // Track video detail page rendering
    await FramePerformanceMonitor.trackRenderOperation(
      name: 'video_detail_render',
      operation: () async {
        // await buildVideoDetail();
        await Future.delayed(const Duration(milliseconds: 150));
      },
      tags: {'videoId': '123'},
    );
  }

  // ============================================================================
  // EXAMPLE 6: Error Handling
  // ============================================================================

  /// Example: Proper error handling with Sentry
  Future<void> exampleErrorHandling() async {
    // Example 1: Automatic error capture in tracked operations
    try {
      await VideoPerformanceMonitor.trackPlayback(
        operation: () async {
          // Simulate an error
          throw Exception('Failed to start playback');
        },
        currentPosition: 0,
      );
    } catch (e) {
      // Error is automatically captured by Sentry
      debugPrint('Playback failed: $e');
    }

    // Example 2: Manual error capture
    try {
      // Some risky operation
      await riskyOperation();
    } catch (e, stackTrace) {
      // Manually capture the exception
      await SentryConfig.captureException(
        e,
        stackTrace: stackTrace,
        tags: {'operation': 'risky_operation', 'userId': 'user123'},
        hint: 'This operation failed during video loading',
      );
      rethrow;
    }
  }

  // ============================================================================
  // EXAMPLE 7: Custom Transactions
  // ============================================================================

  /// Example: Create custom transactions for complex operations
  Future<void> exampleCustomTransactions() async {
    // Create a transaction for a complex multi-step operation
    final transaction = SentryConfig.startTransaction(
      name: 'video_initialization',
      operation: 'task',
      tags: {'videoId': '123', 'quality': '1080p'},
      data: {'episodeCount': 24},
    );

    try {
      // Step 1: Load metadata
      final metadataSpan = SentryConfig.startSpan(
        parent: transaction,
        operation: 'fetch.metadata',
        description: 'Loading video metadata',
      );
      await Future.delayed(const Duration(milliseconds: 100));
      metadataSpan.status = const SpanStatus.ok();
      await metadataSpan.finish();

      // Step 2: Load video stream
      final streamSpan = SentryConfig.startSpan(
        parent: transaction,
        operation: 'fetch.stream',
        description: 'Loading video stream',
      );
      await Future.delayed(const Duration(milliseconds: 300));
      streamSpan.status = const SpanStatus.ok();
      await streamSpan.finish();

      // Step 3: Initialize player
      final playerSpan = SentryConfig.startSpan(
        parent: transaction,
        operation: 'init.player',
        description: 'Initializing video player',
      );
      await Future.delayed(const Duration(milliseconds: 200));
      playerSpan.status = const SpanStatus.ok();
      await playerSpan.finish();

      // Mark transaction as successful
      transaction.status = const SpanStatus.ok();
    } catch (e) {
      transaction.status = const SpanStatus.internalError();
      transaction.throwable = e;
      rethrow;
    } finally {
      await transaction.finish();
    }
  }

  // ============================================================================
  // EXAMPLE 8: Breadcrumbs
  // ============================================================================

  /// Example: Use breadcrumbs for debugging
  void exampleBreadcrumbs() {
    // Add breadcrumb for user actions
    SentryConfig.addBreadcrumb(
      message: 'User clicked play button',
      category: 'user.action',
      data: {'videoId': '123', 'position': 1500},
    );

    // Add breadcrumb for state changes
    SentryConfig.addBreadcrumb(
      message: 'Player state changed',
      category: 'player.state',
      data: {'from': 'paused', 'to': 'playing'},
    );

    // Add breadcrumb for navigation
    SentryConfig.addBreadcrumb(
      message: 'Navigated to video detail',
      category: 'navigation',
      data: {'videoId': '123', 'source': 'home_page'},
    );
  }

  // ============================================================================
  // EXAMPLE 9: User Context
  // ============================================================================

  /// Example: Set user context for tracking
  void exampleUserContext() {
    // Set user context on login
    SentryConfig.setUser(
      id: 'user123',
      username: 'john_doe',
      // email: 'john@example.com', // Be careful with PII
      data: {'subscription': 'premium', 'region': 'US'},
    );

    // Set global tags
    SentryConfig.setGlobalTag('appVersion', '1.0.0');
    SentryConfig.setGlobalTag('platform', 'macOS');

    // Set global context
    SentryConfig.setGlobalContext('app', {
      'theme': 'dark',
      'language': 'en',
      'quality': 'auto',
    });

    // Clear user context on logout
    SentryConfig.clearUser();
  }

  // ============================================================================
  // EXAMPLE 10: Complete Video Player Integration
  // ============================================================================

  /// Example: Complete integration in a video player widget
  Future<void> exampleCompleteIntegration() async {
    // 1. Set video context when video is loaded
    VideoPerformanceMonitor.setVideoContext(
      videoId: '12345',
      resolution: '1080p',
      episodeIndex: 0,
      duration: 3600000,
    );

    // 2. Track video initialization
    await NetworkPerformanceMonitor.trackAsyncOperation(
      name: 'video_initialization',
      operation: () async {
        // Load video metadata
        await Future.delayed(const Duration(milliseconds: 200));
      },
      tags: {'videoId': '12345'},
    );

    // 3. Track playback start
    await VideoPerformanceMonitor.trackPlayback(
      operation: () async {
        await Future.delayed(const Duration(milliseconds: 100));
      },
      currentPosition: 0,
    );

    // 4. Add breadcrumb for user interaction
    VideoPerformanceMonitor.addVideoBreadcrumb(
      message: 'User started watching video',
      data: {'videoId': '12345', 'quality': '1080p'},
    );

    // 5. Simulate some playback time
    await Future.delayed(const Duration(seconds: 5));

    // 6. Track pause
    await VideoPerformanceMonitor.trackPause(
      operation: () async {
        await Future.delayed(const Duration(milliseconds: 50));
      },
      currentPosition: 5000,
    );

    // 7. Track seek
    await VideoPerformanceMonitor.trackSeek(
      operation: () async {
        await Future.delayed(const Duration(milliseconds: 200));
      },
      fromPosition: 5000,
      toPosition: 30000,
    );

    // 8. Track resume
    await VideoPerformanceMonitor.trackPlayback(
      operation: () async {
        await Future.delayed(const Duration(milliseconds: 100));
      },
      currentPosition: 30000,
    );

    // 9. Clear context when player is disposed
    VideoPerformanceMonitor.clearVideoContext();
  }

  // Helper method for example
  Future<void> riskyOperation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    throw Exception('Simulated error');
  }
}
