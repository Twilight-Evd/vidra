import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/download_provider.dart';
import '../domain/download_task.dart';
import 'widgets/download_task_card.dart';

class DownloadListScreen extends ConsumerWidget {
  const DownloadListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTasks = ref.watch(activeDownloadsProvider);
    final completedTasks = ref.watch(completedDownloadsProvider);

    if (kDebugMode) {
      print(
        'DownloadListScreen: activeTasks=${activeTasks.length}, completedTasks=${completedTasks.length}',
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr('download.title')),
          bottom: TabBar(
            tabs: [
              Tab(text: tr('download.tab.downloading')),
              Tab(text: tr('download.tab.completed')),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Downloading tab
            _buildTaskList(context, ref, activeTasks, isActive: true),
            // Completed tab
            _buildTaskList(context, ref, completedTasks, isActive: false),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    WidgetRef ref,
    List<DownloadTask> tasks, {
    required bool isActive,
  }) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.download_outlined : Icons.check_circle_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              isActive
                  ? tr('download.empty.active')
                  : tr('download.empty.completed'),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return DownloadTaskCard(task: tasks[index], isActive: isActive);
      },
    );
  }
}
