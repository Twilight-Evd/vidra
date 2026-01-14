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
    data: (tasks) => tasks
        .where(
          (t) =>
              t.status == DownloadStatus.downloading ||
              t.status == DownloadStatus.queued ||
              t.status == DownloadStatus.paused ||
              t.status == DownloadStatus.cancelled ||
              t.status == DownloadStatus.failed,
        )
        .toList(),
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

/// Completed downloads
final completedDownloadsProvider = Provider<List<DownloadTask>>((ref) {
  final tasksAsync = ref.watch(downloadTasksProvider);
  return tasksAsync.when(
    data: (tasks) =>
        tasks.where((t) => t.status == DownloadStatus.completed).toList(),
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

/// Active download count
final activeDownloadCountProvider = Provider<int>((ref) {
  final activeTasks = ref.watch(activeDownloadsProvider);
  return activeTasks.length;
});
