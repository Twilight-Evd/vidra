import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_provider.dart';

class DownloadProgress {
  final int count;
  final int total;
  final double progress;

  DownloadProgress({
    required this.count,
    required this.total,
    required this.progress,
  });
}

class FileDownloader {
  final Dio _dio;

  FileDownloader(this._dio);

  Future<void> downloadFile({
    required String url,
    required String savePath,
    void Function(DownloadProgress)? onProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: (count, total) {
          if (total != -1 && onProgress != null) {
            onProgress(
              DownloadProgress(
                count: count,
                total: total,
                progress: count / total,
              ),
            );
          }
        },
        cancelToken: cancelToken,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Silently handle cancellation
        return;
      }
      rethrow;
    }
  }
}

final fileDownloaderProvider = Provider<FileDownloader>((ref) {
  final dio = ref.watch(dioProvider);
  return FileDownloader(dio);
});
