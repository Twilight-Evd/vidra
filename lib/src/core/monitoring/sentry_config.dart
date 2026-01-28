import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// Central Sentry configuration and initialization for performance monitoring
class SentryConfig {
  static const String _dsn =
      'https://b165cc071b84a3611f362751030f1528@o4510779146633216.ingest.de.sentry.io/4510779149320272';

  /// Initialize Sentry with performance monitoring enabled
  ///
  /// This should be called at app startup, wrapping the main app runner.
  ///
  /// Example:
  /// ```dart
  /// await SentryConfig.initialize(
  ///   appRunner: () => runApp(MyApp()),
  ///   release: 'vidra@1.0.0+1',
  /// );
  /// ```
  static Future<void> initialize({
    required Function() appRunner,
    String? release,
    double tracesSampleRate = 0.2, // Reduced default for production
    bool enableAutoPerformanceTracing = true,
  }) async {
    await SentryFlutter.init((options) {
      options.dsn = _dsn;

      // Set release version for tracking
      options.release = release ?? 'vidra@1.0.0+1';

      // Performance monitoring configuration
      options.tracesSampleRate = tracesSampleRate;
      options.enableAutoPerformanceTracing = enableAutoPerformanceTracing;

      // Enable breadcrumbs for debugging
      options.maxBreadcrumbs = 100;

      // Capture errors in release mode
      options.environment = kReleaseMode ? 'production' : 'development';

      // Enable performance tracking for various operations
      options.enableAutoSessionTracking = true;

      // Configure what to track
      options.attachScreenshot = false; // Disable for privacy
      options.attachViewHierarchy = false; // Disable for privacy

      // Performance monitoring options
      options.enableUserInteractionTracing = true;
      options.enableUserInteractionBreadcrumbs = true;

      // DEADLOCK FIX: Disable App Hang tracking
      // The ANR tracker suspends threads to capture stack traces, which can cause
      // deadlocks if the main thread is waiting on a suspended thread (e.g. during AppKit flush).
      options.enableAppHangTracking = false;
      options.enableWatchdogTerminationTracking = false;
      // Safeguard: If tracking is ever re-enabled, lenient timeout prevents false positives
      options.appHangTimeoutInterval = const Duration(seconds: 4);

      // Debug logging (only in debug mode)
      options.debug = kDebugMode;

      // Before send callback to filter sensitive data
      options.beforeSend = (event, hint) {
        // Filter out any sensitive data here if needed
        return event;
      };
    }, appRunner: appRunner);
  }

  /// Create a new transaction for performance tracking
  ///
  /// [name] - Descriptive name for the transaction (e.g., 'video_playback_play')
  /// [operation] - Type of operation (e.g., 'ui.action', 'http.client', 'task')
  /// [tags] - Additional tags for filtering and aggregation
  /// [data] - Additional data for analysis
  ///
  /// Example:
  /// ```dart
  /// final transaction = SentryConfig.startTransaction(
  ///   name: 'video_playback_play',
  ///   operation: 'ui.action',
  ///   tags: {'videoId': '123', 'resolution': '1080p'},
  ///   data: {'currentPosition': 1500, 'duration': 3600000},
  /// );
  ///
  /// try {
  ///   // Perform operation
  ///   await player.play();
  ///   transaction.status = const SpanStatus.ok();
  /// } catch (e) {
  ///   transaction.status = const SpanStatus.internalError();
  ///   transaction.throwable = e;
  ///   rethrow;
  /// } finally {
  ///   await transaction.finish();
  /// }
  /// ```
  static ISentrySpan startTransaction({
    required String name,
    required String operation,
    Map<String, String>? tags,
    Map<String, dynamic>? data,
  }) {
    final transaction = Sentry.startTransaction(
      name,
      operation,
      bindToScope: true,
    );

    // Add tags for filtering and aggregation
    if (tags != null) {
      tags.forEach((key, value) {
        transaction.setTag(key, value);
      });
    }

    // Add data for analysis
    if (data != null) {
      data.forEach((key, value) {
        transaction.setData(key, value);
      });
    }

    return transaction;
  }

  /// Create a child span within a transaction
  ///
  /// Use this to track sub-operations within a larger transaction.
  ///
  /// Example:
  /// ```dart
  /// final span = SentryConfig.startSpan(
  ///   parent: transaction,
  ///   operation: 'video.buffer',
  ///   description: 'Buffering video data',
  /// );
  ///
  /// try {
  ///   await bufferData();
  ///   span.status = const SpanStatus.ok();
  /// } finally {
  ///   await span.finish();
  /// }
  /// ```
  static ISentrySpan startSpan({
    required ISentrySpan parent,
    required String operation,
    String? description,
  }) {
    return parent.startChild(operation, description: description);
  }

  /// Add a breadcrumb for debugging
  ///
  /// Breadcrumbs are useful for tracking events that don't need full transactions.
  ///
  /// Example:
  /// ```dart
  /// SentryConfig.addBreadcrumb(
  ///   message: 'Frame rendered',
  ///   category: 'ui.render',
  ///   data: {'buildMs': 12.5, 'rasterMs': 8.3},
  /// );
  /// ```
  static void addBreadcrumb({
    required String message,
    String? category,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        data: data,
        level: level,
        timestamp: DateTime.now().toUtc(),
      ),
    );
  }

  /// Capture an exception with context
  ///
  /// Use this to manually report errors to Sentry.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await riskyOperation();
  /// } catch (e, stackTrace) {
  ///   SentryConfig.captureException(
  ///     e,
  ///     stackTrace: stackTrace,
  ///     tags: {'operation': 'video_load'},
  ///   );
  /// }
  /// ```
  static Future<SentryId> captureException(
    dynamic exception, {
    dynamic stackTrace,
    Map<String, String>? tags,
    String? hint,
  }) async {
    return await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hint != null ? Hint.withMap({'hint': hint}) : null,
      withScope: (scope) {
        if (tags != null) {
          tags.forEach((key, value) {
            scope.setTag(key, value);
          });
        }
      },
    );
  }

  /// Set user context for tracking
  ///
  /// This helps identify which users are experiencing issues.
  ///
  /// Example:
  /// ```dart
  /// SentryConfig.setUser(
  ///   id: 'user123',
  ///   email: 'user@example.com', // Optional, be careful with PII
  /// );
  /// ```
  static void setUser({
    String? id,
    String? email,
    String? username,
    Map<String, dynamic>? data,
  }) {
    Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(id: id, email: email, username: username, data: data),
      );
    });
  }

  /// Clear user context
  static void clearUser() {
    Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Set a global tag that will be applied to all events
  ///
  /// Example:
  /// ```dart
  /// SentryConfig.setGlobalTag('deviceModel', 'MacBook Pro');
  /// ```
  static void setGlobalTag(String key, String value) {
    Sentry.configureScope((scope) {
      scope.setTag(key, value);
    });
  }

  /// Set global context data
  ///
  /// Example:
  /// ```dart
  /// SentryConfig.setGlobalContext('app', {
  ///   'theme': 'dark',
  ///   'language': 'en',
  /// });
  /// ```
  static void setGlobalContext(String key, Map<String, dynamic> value) {
    Sentry.configureScope((scope) {
      scope.setContexts(key, value);
    });
  }
}
