import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/download_task.dart';
import '../../data/download_provider.dart';
import '../../../video/data/video_repository.dart';

class DownloadTaskCard extends ConsumerStatefulWidget {
  final DownloadTask task;
  final bool isActive;

  const DownloadTaskCard({
    super.key,
    required this.task,
    required this.isActive,
  });

  @override
  ConsumerState<DownloadTaskCard> createState() => _DownloadTaskCardState();
}

class _DownloadTaskCardState extends ConsumerState<DownloadTaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final manager = ref.watch(downloadManagerProvider);
    final task = widget.task;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          // Main task info
          InkWell(
            onTap: task.episodes.length > 1
                ? () => setState(() => _isExpanded = !_isExpanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  if (task.coverUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: task.coverUrl!.startsWith('http')
                            ? task.coverUrl!
                            : ref
                                  .read(videoRepositoryProvider)
                                  .resolveUrl(task.coverUrl!),
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 120,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 120,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.error,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          task.videoTitle,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Episode count
                        Text(
                          task.episodes.length == 1
                              ? (task.episodes.first.title ?? '')
                              : '${task.episodes.length} episodes',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Progress bar
                        LinearProgressIndicator(
                          value: task.progress,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getStatusColor(task.status, theme),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Detailed status info
                        Row(
                          children: [
                            // Downloaded / Total size or Episode count
                            Text(
                              task.episodes.length > 1 &&
                                      task.status == DownloadStatus.downloading
                                  ? 'Downloading ${_getDownloadingEpisodeIndex(task)}/${task.episodes.length}'
                                  : '${_formatBytes(task.totalBytesDownloaded)} / ${_formatBytes(task.totalBytes)}',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Download speed
                            if (task.downloadSpeed != null)
                              Text(
                                _formatSpeed(task.downloadSpeed!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            const Spacer(),
                            // Estimated time remaining
                            if (task.estimatedTimeRemaining != null)
                              Text(
                                _formatDuration(task.estimatedTimeRemaining!),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              )
                            else if (task.status !=
                                    DownloadStatus.downloading &&
                                task.status != DownloadStatus.completed)
                              Text(
                                _getStatusText(task),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _getStatusColor(task.status, theme),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  if (widget.isActive)
                    Column(
                      children: [
                        if (task.status == DownloadStatus.downloading)
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: () => manager.pauseTask(task.taskId),
                            tooltip: 'Pause',
                          )
                        else if (task.status == DownloadStatus.paused)
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () => manager.resumeTask(task.taskId),
                            tooltip: 'Resume',
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => manager.cancelTask(task.taskId),
                          tooltip: 'Cancel All',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _showDeleteDialog(
                            context,
                            (deleteFile) => manager.deleteTask(
                              task.taskId,
                              deleteFile: deleteFile,
                            ),
                          ),
                          tooltip: 'Delete Task',
                        ),
                      ],
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _showDeleteDialog(
                        context,
                        (deleteFile) => manager.deleteTask(
                          task.taskId,
                          deleteFile: deleteFile,
                        ),
                      ),
                      tooltip: 'Delete',
                    ),
                  // Expand indicator for multi-episode
                  if (task.episodes.length > 1)
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          ),
          // Expanded episode list
          if (_isExpanded && task.episodes.length > 1)
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                border: Border(
                  top: BorderSide(color: theme.dividerColor.withAlpha(50)),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: task.episodes.length,
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: theme.dividerColor.withAlpha(50)),
                itemBuilder: (context, index) {
                  final episode = task.episodes[index];
                  return ListTile(
                    dense: true,
                    leading: _getEpisodeStatusIcon(episode.status, theme),
                    title: Text(
                      episode.title ?? 'Episode',
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: episode.status == DownloadStatus.downloading
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: episode.progress,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHighest,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_formatBytes(episode.bytesDownloaded)} / ${_formatBytes(episode.totalBytes)}'
                                '${task.estimatedTimeRemaining != null ? " - ${_formatDuration(task.estimatedTimeRemaining!)} left" : ""}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (episode.status == DownloadStatus.downloading)
                          Text(
                            '${(episode.progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        if (episode.status == DownloadStatus.downloading ||
                            episode.status == DownloadStatus.queued)
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () =>
                                manager.cancelEpisode(task.taskId, index),
                            tooltip: 'Cancel',
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20),
                          onPressed: () => _showDeleteDialog(
                            context,
                            (deleteFile) => manager.deleteEpisode(
                              task.taskId,
                              index,
                              deleteFile: deleteFile,
                            ),
                            title: 'Delete Episode?',
                            content:
                                'Are you sure you want to delete this episode?',
                          ),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(DownloadStatus status, ThemeData theme) {
    switch (status) {
      case DownloadStatus.downloading:
        return theme.colorScheme.secondary;
      case DownloadStatus.completed:
        return Colors.green;
      case DownloadStatus.failed:
        return Colors.red;
      case DownloadStatus.paused:
        return Colors.orange;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(DownloadTask task) {
    final completed = task.episodes
        .where((e) => e.status == DownloadStatus.completed)
        .length;
    final total = task.episodes.length;

    if (task.status == DownloadStatus.completed) {
      return 'Completed';
    } else if (task.status == DownloadStatus.paused) {
      return 'Paused - $completed/$total episodes';
    } else if (task.status == DownloadStatus.failed) {
      return 'Failed';
    } else {
      return 'Downloading $completed/$total episodes';
    }
  }

  Widget _getEpisodeStatusIcon(DownloadStatus status, ThemeData theme) {
    switch (status) {
      case DownloadStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case DownloadStatus.downloading:
        return const Icon(Icons.download, color: Colors.red, size: 20);
      case DownloadStatus.failed:
        return const Icon(Icons.error, color: Colors.red, size: 20);
      case DownloadStatus.paused:
        return const Icon(Icons.pause_circle, color: Colors.orange, size: 20);
      default:
        return Icon(
          Icons.schedule,
          color: theme.colorScheme.onSurfaceVariant,
          size: 20,
        );
    }
  }

  String _formatBytes(int bytes) {
    if (bytes == 0) return '0 B';
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / 1024 / 1024).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / 1024 / 1024 / 1024).toStringAsFixed(2)} GB';
    }
  }

  String _formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    } else if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    } else {
      return '${(bytesPerSecond / 1024 / 1024).toStringAsFixed(1)} MB/s';
    }
  }

  String _formatDuration(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    } else if (seconds < 3600) {
      return '${(seconds / 60).floor()}m ${seconds % 60}s';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).floor();
      return '${hours}h ${minutes}m';
    }
  }

  Future<void> _showDeleteDialog(
    BuildContext context,
    Function(bool deleteFile) onConfirm, {
    String title = 'Delete Task?',
    String content = 'Are you sure you want to delete this task?',
  }) async {
    bool deleteFile = false;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(content),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Also delete downloaded files'),
                value: deleteFile,
                onChanged: (value) =>
                    setState(() => deleteFile = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm(deleteFile);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  String _getDownloadingEpisodeIndex(DownloadTask task) {
    final index = task.episodes.indexWhere(
      (e) => e.status == DownloadStatus.downloading,
    );
    if (index == -1) return '?';
    return '${index + 1}';
  }
}
