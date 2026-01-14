import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/download_provider.dart';
import '../../domain/download_task.dart';

class DownloadTaskListDialog extends ConsumerWidget {
  const DownloadTaskListDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasks = ref.watch(activeDownloadsProvider);
    final manager = ref.watch(downloadManagerProvider);

    return Dialog(
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Downloads',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Task list
            Flexible(
              child: activeTasks.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No active downloads',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: activeTasks.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1, color: Colors.grey[800]),
                      itemBuilder: (context, index) {
                        final task = activeTasks[index];
                        return _buildCompactTaskItem(context, task, manager);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactTaskItem(
    BuildContext context,
    DownloadTask task,
    dynamic manager,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: Text(
        task.videoTitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: task.progress,
            backgroundColor: Colors.grey[800],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(task.progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 12),
              ),
              if (task.downloadSpeed != null)
                Text(
                  _formatSpeed(task.downloadSpeed!),
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
        ],
      ),
      trailing: task.status == DownloadStatus.downloading
          ? IconButton(
              icon: const Icon(Icons.pause, size: 20),
              onPressed: () => manager.pauseTask(task.id),
            )
          : IconButton(
              icon: const Icon(Icons.play_arrow, size: 20),
              onPressed: () => manager.resumeTask(task.id),
            ),
    );
  }

  String _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(bytesPerSecond / 1024 / 1024).toStringAsFixed(1)} MB/s';
    }
  }
}
