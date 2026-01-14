import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/download_provider.dart';
import 'download_task_card.dart';

class DownloadTaskList extends ConsumerWidget {
  const DownloadTaskList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final activeTasks = ref.watch(activeDownloadsProvider);

    if (activeTasks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.download_done,
                size: 48,
                color: theme.colorScheme.onSurface.withAlpha(50),
              ),
              const SizedBox(height: 16),
              Text(
                tr('download.empty.active'),
                style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activeTasks.length,
      itemBuilder: (context, index) {
        final task = activeTasks[index];
        return DownloadTaskCard(task: task, isActive: true);
      },
    );
  }
}
