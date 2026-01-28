import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'sentry_config.dart';

/// Performance monitoring wrapper for network and async operations
///
/// This class provides methods to wrap network requests and async business
/// logic with Sentry performance tracking. Each operation creates a transaction
/// that includes relevant tags and data for aggregation.
class NetworkPerformanceMonitor {
  /// Track a network request
  ///
  /// Wraps a network request with performance tracking.
  ///
  /// Example:
  /// ```dart
  /// final response = await NetworkPerformanceMonitor.trackNetworkRequest(
  ///   operation: () async => await dio.get('/api/videos'),
  ///   endpoint: '/api/videos',
  ///   method: 'GET',
  ///   tags: {'userId': '123'},
  /// );
  /// ```
  static Future<T> trackNetworkRequest<T>({
    required Future<T> Function() operation,
    required String endpoint,
    String method = 'GET',
    Map<String, String>? tags,
    Map<String, dynamic>? data,
  }) async {
    // Skip tracking in debug mode to reduce overhead
    if (kDebugMode) {
      return await operation();
    }

    // Clean endpoint for transaction name (remove query params and IDs)
    final cleanEndpoint = _cleanEndpoint(endpoint);
    final transactionName = 'network_fetch_$cleanEndpoint';

    final transactionTags = <String, String>{
      'endpoint': endpoint,
      'method': method,
      if (tags != null) ...tags,
    };

    final transactionData = <String, dynamic>{
      'url': endpoint,
      'method': method,
      if (data != null) ...data,
    };

    final transaction = SentryConfig.startTransaction(
      name: transactionName,
      operation: 'http.client',
      tags: transactionTags,
      data: transactionData,
    );

    final startTime = DateTime.now();

    try {
      final result = await operation();

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      transaction.setData('durationMs', duration);

      // Try to extract response information if available
      if (result != null) {
        _addResponseData(transaction, result);
      }

      transaction.status = const SpanStatus.ok();
      return result;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      transaction.setData('durationMs', duration);

      // Set error status
      transaction.status = const SpanStatus.internalError();
      transaction.throwable = e;

      // Add error details
      transaction.setData('error', e.toString());

      // Capture the exception
      await SentryConfig.captureException(
        e,
        stackTrace: stackTrace,
        tags: {
          'operation': transactionName,
          'endpoint': endpoint,
          'method': method,
        },
      );

      rethrow;
    } finally {
      await transaction.finish();
    }
  }

  /// Track an async business logic operation
  ///
  /// Wraps async business logic with performance tracking.
  ///
  /// Example:
  /// ```dart
  /// final videos = await NetworkPerformanceMonitor.trackAsyncOperation(
  ///   name: 'load_video_list',
  ///   operation: () async => await videoRepository.getVideos(),
  ///   tags: {'category': 'action'},
  /// );
  /// ```
  static Future<T> trackAsyncOperation<T>({
    required String name,
    required Future<T> Function() operation,
    Map<String, String>? tags,
    Map<String, dynamic>? data,
  }) async {
    // Skip tracking in debug mode
    if (kDebugMode) {
      return await operation();
    }

    final transactionName = 'async_$name';

    final transaction = SentryConfig.startTransaction(
      name: transactionName,
      operation: 'task',
      tags: tags,
      data: data,
    );

    final startTime = DateTime.now();

    try {
      final result = await operation();

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      transaction.setData('durationMs', duration);

      transaction.status = const SpanStatus.ok();
      return result;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      transaction.setData('durationMs', duration);

      transaction.status = const SpanStatus.internalError();
      transaction.throwable = e;
      transaction.setData('error', e.toString());

      await SentryConfig.captureException(
        e,
        stackTrace: stackTrace,
        tags: {'operation': transactionName, if (tags != null) ...tags},
      );

      rethrow;
    } finally {
      await transaction.finish();
    }
  }

  /// Track a database operation
  ///
  /// Example:
  /// ```dart
  /// final videos = await NetworkPerformanceMonitor.trackDatabaseOperation(
  ///   operation: () async => await isar.videos.where().findAll(),
  ///   operationType: 'query',
  ///   collection: 'videos',
  /// );
  /// ```
  static Future<T> trackDatabaseOperation<T>({
    required Future<T> Function() operation,
    required String operationType,
    String? collection,
    Map<String, String>? tags,
    Map<String, dynamic>? data,
  }) async {
    // Skip tracking in debug mode
    if (kDebugMode) {
      return await operation();
    }

    final transactionName = collection != null
        ? 'db_${operationType}_$collection'
        : 'db_$operationType';

    final transactionTags = <String, String>{
      'operationType': operationType,
      if (collection != null) 'collection': collection,
      if (tags != null) ...tags,
    };

    final transactionData = <String, dynamic>{
      'operationType': operationType,
      if (collection != null) 'collection': collection,
      if (data != null) ...data,
    };

    final transaction = SentryConfig.startTransaction(
      name: transactionName,
      operation: 'db.query',
      tags: transactionTags,
      data: transactionData,
    );

    final startTime = DateTime.now();

    try {
      final result = await operation();

      final duration = DateTime.now().difference(startTime).inMilliseconds;
      transaction.setData('durationMs', duration);

      transaction.status = const SpanStatus.ok();
      return result;
    } catch (e, stackTrace) {
      final duration = DateTime.now().difference(startTime).inMilliseconds;
      transaction.setData('durationMs', duration);

      transaction.status = const SpanStatus.internalError();
      transaction.throwable = e;
      transaction.setData('error', e.toString());

      await SentryConfig.captureException(
        e,
        stackTrace: stackTrace,
        tags: {'operation': transactionName, ...transactionTags},
      );

      rethrow;
    } finally {
      await transaction.finish();
    }
  }

  /// Clean endpoint for transaction naming
  ///
  /// Removes query parameters and replaces IDs with placeholders
  /// to ensure consistent transaction names for aggregation.
  static String _cleanEndpoint(String endpoint) {
    // Remove query parameters
    var cleaned = endpoint.split('?').first;

    // Remove leading slash
    if (cleaned.startsWith('/')) {
      cleaned = cleaned.substring(1);
    }

    // Replace numeric IDs with placeholder
    cleaned = cleaned.replaceAllMapped(RegExp(r'/\d+'), (match) => '/:id');

    // Replace slashes with underscores for transaction name
    cleaned = cleaned.replaceAll('/', '_');

    // Limit length
    if (cleaned.length > 50) {
      cleaned = cleaned.substring(0, 50);
    }

    return cleaned.isEmpty ? 'unknown' : cleaned;
  }

  /// Add response data to transaction
  static void _addResponseData(ISentrySpan transaction, dynamic result) {
    try {
      // Try to extract common response properties
      if (result is Map) {
        // Check for status code
        if (result.containsKey('statusCode')) {
          transaction.setData('responseStatus', result['statusCode']);
        }

        // Check for data size
        if (result.containsKey('data')) {
          final data = result['data'];
          if (data is List) {
            transaction.setData('responseItemCount', data.length);
          } else if (data is String) {
            transaction.setData('responseSizeBytes', data.length);
          }
        }
      }

      // For Dio Response objects (if using Dio)
      if (result.runtimeType.toString().contains('Response')) {
        try {
          final dynamic response = result;
          // Use dynamic access to avoid compile-time dependency on Dio
          transaction.setData('responseStatus', response.statusCode);

          final data = response.data;
          if (data is List) {
            transaction.setData('responseItemCount', data.length);
          } else if (data is String) {
            transaction.setData('responseSizeBytes', data.length);
          }
        } catch (_) {
          // Ignore if we can't extract response data
        }
      }
    } catch (_) {
      // Ignore errors in extracting response data
    }
  }

  /// Add a breadcrumb for a network event
  ///
  /// Use this for network events that don't need full transaction tracking.
  ///
  /// Example:
  /// ```dart
  /// NetworkPerformanceMonitor.addNetworkBreadcrumb(
  ///   message: 'API request started',
  ///   endpoint: '/api/videos',
  ///   method: 'GET',
  /// );
  /// ```
  static void addNetworkBreadcrumb({
    required String message,
    String? endpoint,
    String? method,
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    final breadcrumbData = <String, dynamic>{
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (data != null) ...data,
    };

    SentryConfig.addBreadcrumb(
      message: message,
      category: 'network',
      data: breadcrumbData,
      level: level,
    );
  }
}
