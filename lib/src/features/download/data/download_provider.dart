import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../domain/download_task.dart';
import 'download_manager.dart';

/// Download manager provider
final downloadManagerProvider = Provider<DownloadManager>((ref) {
  return DownloadManager();
});

/// All download tasks stream
final downloadTasksProvider = StreamProvider<List<DownloadTask>>((ref) {
  final manager = ref.watch(downloadManagerProvider);
  return manager.tasksStream;
});

/// Active downloads (downloading, queued, paused)
final activeDownloadsProvider = Provider<List<DownloadTask>>((ref) {
  final tasksAsync = ref.watch(downloadTasksProvider);
  return tasksAsync.when(
    data: (tasks) {
      if (kDebugMode) {
        print(
          'activeDownloadsProvider: Received ${tasks.length} tasks from manager',
        );
      }
      final filtered = tasks
          .where(
            (t) =>
                t.status == DownloadStatus.downloading ||
                t.status == DownloadStatus.queued ||
                t.status == DownloadStatus.paused ||
                t.status == DownloadStatus.cancelled ||
                t.status == DownloadStatus.failed,
          )
          .toList();
      if (kDebugMode) {
        print(
          'activeDownloadsProvider: Filtered to ${filtered.length} active tasks',
        );
      }
      return filtered;
    },
    loading: () => [],
    error: (error, stackTrace) {
      if (kDebugMode) {
        print('activeDownloadsProvider Error: $error');
      }
      return [];
    },
  );
});

/// Completed downloads
final completedDownloadsProvider = Provider<List<DownloadTask>>((ref) {
  final tasksAsync = ref.watch(downloadTasksProvider);
  return tasksAsync.when(
    data: (tasks) {
      if (kDebugMode) {
        print(
          'completedDownloadsProvider: Received ${tasks.length} tasks from manager',
        );
      }
      final filtered = tasks
          .where((t) => t.status == DownloadStatus.completed)
          .toList();
      if (kDebugMode) {
        print(
          'completedDownloadsProvider: Filtered to ${filtered.length} completed tasks',
        );
      }
      return filtered;
    },
    loading: () => [],
    error: (error, stackTrace) {
      if (kDebugMode) {
        print('completedDownloadsProvider Error: $error');
      }
      return [];
    },
  );
});

/// Active download count
final activeDownloadCountProvider = Provider<int>((ref) {
  final activeTasks = ref.watch(activeDownloadsProvider);
  return activeTasks.length;
});
