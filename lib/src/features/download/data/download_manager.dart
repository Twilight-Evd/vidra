import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import '../domain/download_task.dart';
import '../../../core/services/download_service.dart';
import '../../settings/data/settings_repository.dart';

/// Download manager - handles task queue and execution
class DownloadManager {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;
  DownloadManager._internal();

  final _downloadService = DownloadService();
  late Isar _isar;
  late SettingsRepository _settingsRepo;
  final _tasks = <String, DownloadTask>{};
  final _taskController = StreamController<List<DownloadTask>>.broadcast();
  final _uuid = const Uuid();

  // Concurrency settings (will be read from settings)
  int _maxConcurrentTasks = 3;
  final Set<String> _activeTaskIds = {};
  bool _isProcessing = false;

  Stream<List<DownloadTask>> get tasksStream async* {
    yield allTasks;
    yield* _taskController.stream;
  }

  List<DownloadTask> get allTasks => _tasks.values.toList();
  List<DownloadTask> get activeTasks => _tasks.values
      .where(
        (t) =>
            t.status == DownloadStatus.downloading ||
            t.status == DownloadStatus.queued ||
            t.status == DownloadStatus.paused ||
            t.status == DownloadStatus.cancelled ||
            t.status == DownloadStatus.failed,
      )
      .toList();
  List<DownloadTask> get completedTasks =>
      _tasks.values.where((t) => t.status == DownloadStatus.completed).toList();

  /// Initialize manager and load persisted tasks
  Future<void> initialize(Isar isar) async {
    _isar = isar;
    _settingsRepo = SettingsRepository(isar);

    // Load max concurrent downloads from settings
    final settings = await _settingsRepo.getSettings();
    _maxConcurrentTasks = settings.maxConcurrentDownloads;

    await _loadTasks();
    _startProcessing();
  }

  /// Add a new download task
  String addTask({
    required int videoId,
    required String videoTitle,
    String? coverUrl,
    required List<Map<String, dynamic>> episodes,
  }) {
    // Check if a task for this video already exists
    String? existingTaskId;
    for (final entry in _tasks.entries) {
      if (entry.value.videoId == videoId) {
        existingTaskId = entry.key;
        break;
      }
    }

    if (existingTaskId != null) {
      final existingTask = _tasks[existingTaskId]!;
      final existingUrls = existingTask.episodes.map((e) => e.url).toSet();

      final newEpisodeInfos = episodes
          .where((ep) => !existingUrls.contains(ep['url']))
          .map(
            (ep) => EpisodeDownloadInfo(
              index: ep['index'] as int,
              title: ep['title'] as String,
              url: ep['url'] as String,
            ),
          )
          .toList();

      if (newEpisodeInfos.isNotEmpty) {
        final updatedEpisodes = [...existingTask.episodes, ...newEpisodeInfos];
        _tasks[existingTaskId] = existingTask.copyWith(
          episodes: updatedEpisodes,
          completedAt:
              null, // Reset completed date since new episodes are added
        );
        _notifyUpdate();
        _saveTask(_tasks[existingTaskId]!);
        _processNextTask();
      }
      return existingTaskId;
    }

    // Create new task if none exists
    final taskId = _uuid.v4();
    final episodeInfos = episodes.map((ep) {
      return EpisodeDownloadInfo(
        index: ep['index'] as int,
        title: ep['title'] as String,
        url: ep['url'] as String,
      );
    }).toList();

    final task = DownloadTask(
      taskId: taskId,
      videoId: videoId,
      videoTitle: videoTitle,
      coverUrl: coverUrl,
      episodes: episodeInfos,
      createdAt: DateTime.now(),
    );

    _tasks[taskId] = task;
    _notifyUpdate();
    _saveTask(task);
    _processNextTask();

    return taskId;
  }

  /// Pause a task
  void pauseTask(String taskId) {
    final task = _tasks[taskId];
    if (task == null) return;

    final updatedEpisodes = task.episodes.map((ep) {
      if (ep.status == DownloadStatus.downloading) {
        return ep.copyWith(status: DownloadStatus.paused);
      }
      return ep;
    }).toList();

    _tasks[taskId] = task.copyWith(episodes: updatedEpisodes);
    _notifyUpdate();
    _saveTask(_tasks[taskId]!);
    _processNextTask(); // Try to start other tasks
  }

  /// Resume a task
  void resumeTask(String taskId) {
    final task = _tasks[taskId];
    if (task == null) return;

    final updatedEpisodes = task.episodes.map((ep) {
      if (ep.status == DownloadStatus.paused) {
        return ep.copyWith(status: DownloadStatus.queued);
      }
      return ep;
    }).toList();

    _tasks[taskId] = task.copyWith(episodes: updatedEpisodes);
    _notifyUpdate();
    _saveTask(_tasks[taskId]!);
    _processNextTask();
  }

  /// Cancel a task
  void cancelTask(String taskId) {
    final task = _tasks[taskId];
    if (task == null) return;

    final updatedEpisodes = task.episodes.map((ep) {
      return ep.copyWith(status: DownloadStatus.cancelled);
    }).toList();

    _tasks[taskId] = task.copyWith(episodes: updatedEpisodes);
    _notifyUpdate();
    _saveTask(_tasks[taskId]!);
    _processNextTask(); // Try to start other tasks
  }

  /// Cancel specific episode
  void cancelEpisode(String taskId, int episodeIndex) {
    final task = _tasks[taskId];
    if (task == null || episodeIndex >= task.episodes.length) return;

    final updatedEpisodes = List<EpisodeDownloadInfo>.from(task.episodes);
    final episode = updatedEpisodes[episodeIndex];

    if (episode.status == DownloadStatus.downloading ||
        episode.status == DownloadStatus.queued) {
      updatedEpisodes[episodeIndex] = episode.copyWith(
        status: DownloadStatus.cancelled,
        bytesDownloaded: 0,
        progress: 0.0,
      );
      _tasks[taskId] = task.copyWith(episodes: updatedEpisodes);
      _notifyUpdate();
      _saveTask(_tasks[taskId]!);
      _processNextTask(); // Try to start key queued tasks
    }
  }

  /// Delete specific episode
  void deleteEpisode(
    String taskId,
    int episodeIndex, {
    bool deleteFile = false,
  }) {
    final task = _tasks[taskId];
    if (task == null || episodeIndex >= task.episodes.length) return;

    final updatedEpisodes = List<EpisodeDownloadInfo>.from(task.episodes);
    final episode = updatedEpisodes[episodeIndex];

    // Delete file if requested and it exists
    if (deleteFile && episode.outputPath != null) {
      try {
        final f = File(episode.outputPath!);
        if (f.existsSync()) {
          f.deleteSync();
        }
      } catch (e) {
        if (kDebugMode) print('Error deleting episode file: $e');
      }
    }

    // Remove episode from list
    updatedEpisodes.removeAt(episodeIndex);

    // If no episodes left, delete task entirely
    if (updatedEpisodes.isEmpty) {
      deleteTask(taskId, deleteFile: deleteFile);
      return;
    }

    _tasks[taskId] = task.copyWith(episodes: updatedEpisodes);
    _notifyUpdate();
    _saveTask(_tasks[taskId]!);
  }

  /// Delete task (optionally with file)
  void deleteTask(String taskId, {bool deleteFile = false}) {
    final task = _tasks[taskId];
    if (task != null) {
      if (deleteFile) {
        for (final episode in task.episodes) {
          try {
            if (episode.outputPath != null) {
              final f = File(episode.outputPath!);
              if (f.existsSync()) {
                f.deleteSync();
              }
            }
          } catch (e) {
            if (kDebugMode) print('Error deleting task file: $e');
          }
        }
      }

      _isar.writeTxnSync(() {
        _isar.downloadTasks.deleteSync(task.id);
      });
      _tasks.remove(taskId);
      _notifyUpdate();
      _processNextTask(); // Start next if slot freed
    }
  }

  /// Start processing tasks
  void _startProcessing() {
    if (_isProcessing) return;
    _isProcessing = true;
    _processNextTask();
  }

  /// Process next queued task
  Future<void> _processNextTask() async {
    // Reload max concurrent tasks from settings in case it changed
    try {
      final settings = await _settingsRepo.getSettings();
      _maxConcurrentTasks = settings.maxConcurrentDownloads;
    } catch (e) {
      // Use default if settings unavailable
    }

    // If we've reached max concurrency, stop launching new tasks
    if (_activeTaskIds.length >= _maxConcurrentTasks) {
      _isProcessing = false;
      return;
    }

    // Find next task with queued episodes that isn't already active
    try {
      final nextTask = _tasks.values.firstWhere(
        (task) =>
            !_activeTaskIds.contains(task.taskId) &&
            task.episodes.any((ep) => ep.status == DownloadStatus.queued),
      );

      // Launch task
      _activeTaskIds.add(nextTask.taskId);
      // Run processTask without awaiting it to allow concurrency
      _processTask(nextTask).then((_) {
        _activeTaskIds.remove(nextTask.taskId);
        _processNextTask(); // When one finishes, try to start another
      });

      // Try to launch more if we have capacity
      _processNextTask();
    } catch (_) {
      // No more tasks to run
      _isProcessing = false;
    }
  }

  /// Process a single task
  Future<void> _processTask(DownloadTask task) async {
    for (int i = 0; i < task.episodes.length; i++) {
      // Re-read task from map to get latest status (could be paused/cancelled)
      final currentTask = _tasks[task.taskId];
      if (currentTask == null) return; // Deleted

      final episode = currentTask.episodes[i];
      if (episode.status != DownloadStatus.queued) continue;

      // Check if task was cancelled or paused while waiting for previous episode
      if (currentTask.status == DownloadStatus.cancelled ||
          currentTask.status == DownloadStatus.paused) {
        return;
      }

      try {
        // Update episode status to downloading
        _updateEpisode(
          task.taskId,
          i,
          episode.copyWith(
            status: DownloadStatus.downloading,
            startTime: DateTime.now(),
          ),
        );

        // Download episode
        final filename = '${task.videoTitle}_${episode.title}'.replaceAll(
          RegExp(r'[<>:"/\\|?*]'),
          '_',
        );

        final outputPath = await _downloadService.downloadM3u8ToMp4(
          url: episode.url ?? '',
          filename: filename,
          shouldCancel: () {
            // CRITICAL FIX: Re-fetch latest task state to check for immediate cancellation
            final t = _tasks[task.taskId];
            if (t == null) return true;

            // Check task level status
            if (t.status == DownloadStatus.cancelled ||
                t.status == DownloadStatus.paused) {
              return true;
            }

            // Check specific episode status (it might be cancelled individually)
            if (i < t.episodes.length &&
                t.episodes[i].status == DownloadStatus.cancelled) {
              return true;
            }

            return false;
          },
          onProgress: (progress, bytesDownloaded, totalBytes, status) {
            // CRITICAL FIX: Prevent race condition. If episode was cancelled externally,
            // do not overwrite the Cancelled status with Downloading status from a lingering callback.
            final currentTask = _tasks[task.taskId];
            if (currentTask != null &&
                (currentTask.episodes[i].status == DownloadStatus.cancelled ||
                    currentTask.episodes[i].status == DownloadStatus.paused)) {
              return;
            }

            _updateEpisode(
              task.taskId,
              i,
              episode.copyWith(
                progress: progress,
                bytesDownloaded: bytesDownloaded,
                totalBytes: totalBytes ?? episode.totalBytes,
                status: DownloadStatus.downloading,
              ),
            );
          },
        );

        // Check cancellation one last time before marking complete
        final finalTaskState = _tasks[task.taskId];
        if (finalTaskState != null &&
            finalTaskState.episodes[i].status == DownloadStatus.cancelled) {
          continue; // Move to next episode
        }

        if (outputPath == null) {
          // Cancelled (but check why)
          final t = _tasks[task.taskId];
          // If task itself wasn't cancelled/paused, it means just this episode was skipped/cancelled
          if (t != null &&
              t.status != DownloadStatus.cancelled &&
              t.status != DownloadStatus.paused) {
            continue; // Move to next episode
          }
          return; // Stop task processing
        }

        // Check cancellation one last time before marking complete
        final tBeforeComplete = _tasks[task.taskId];
        if (tBeforeComplete != null &&
            (tBeforeComplete.episodes[i].status == DownloadStatus.cancelled ||
                tBeforeComplete.episodes[i].status == DownloadStatus.paused)) {
          if (tBeforeComplete.episodes[i].status == DownloadStatus.cancelled) {
            continue;
          }
          return;
        }

        // Mark as completed
        _updateEpisode(
          task.taskId,
          i,
          episode.copyWith(
            status: DownloadStatus.completed,
            progress: 1.0,
            outputPath: outputPath,
            completedTime: DateTime.now(),
          ),
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error downloading episode: $e');
        }

        // Don't mark as failed if it was cancelled
        final t = _tasks[task.taskId];
        // Check both task and specific episode cancellation
        final isCancelled =
            t == null ||
            t.status == DownloadStatus.cancelled ||
            t.status == DownloadStatus.paused ||
            (i < t.episodes.length &&
                t.episodes[i].status == DownloadStatus.cancelled);

        if (!isCancelled) {
          _updateEpisode(
            task.taskId,
            i,
            episode.copyWith(
              status: DownloadStatus.failed,
              error: e.toString(),
            ),
          );
        } else {
          // If cancelled or paused, ensure episode status is correct
          if (t != null && i < t.episodes.length) {
            if (t.status == DownloadStatus.paused &&
                t.episodes[i].status != DownloadStatus.paused) {
              _updateEpisode(
                task.taskId,
                i,
                episode.copyWith(status: DownloadStatus.paused),
              );
            }
          }
          // If just this episode was cancelled, continue to next
          if (t != null &&
              t.status != DownloadStatus.cancelled &&
              t.status != DownloadStatus.paused) {
            continue;
          }
          return; // Stop processing this task's episodes
        }
      }
    }

    // Mark task as completed if all episodes are done
    final updatedTask = _tasks[task.taskId];
    if (updatedTask != null &&
        updatedTask.episodes.every(
          (e) => e.status == DownloadStatus.completed,
        )) {
      _tasks[task.taskId] = updatedTask.copyWith(completedAt: DateTime.now());
      _notifyUpdate();
      _saveTask(_tasks[task.taskId]!);
    }
  }

  // Throttling map for save operations
  final _saveThrottler = <String, Timer>{};

  /// Update a specific episode in a task
  void _updateEpisode(
    String taskId,
    int episodeIndex,
    EpisodeDownloadInfo newEpisode,
  ) {
    final task = _tasks[taskId];
    if (task == null) return;

    final updatedEpisodes = List<EpisodeDownloadInfo>.from(task.episodes);
    final oldStatus = updatedEpisodes[episodeIndex].status;
    updatedEpisodes[episodeIndex] = newEpisode;

    _tasks[taskId] = task.copyWith(episodes: updatedEpisodes);
    _notifyUpdate();

    // Persist changes
    // If status changed or completed, save immediately
    if (oldStatus != newEpisode.status ||
        newEpisode.status == DownloadStatus.completed ||
        newEpisode.status == DownloadStatus.failed) {
      _saveTask(_tasks[taskId]!);
    } else {
      // Otherwise (progress updates), throttle saving
      _throttledSave(taskId);
    }
  }

  /// Notify listeners of task updates
  void _notifyUpdate() {
    _taskController.add(allTasks);
  }

  /// Throttled save for progress updates
  void _throttledSave(String taskId) {
    if (_saveThrottler.containsKey(taskId)) return;

    _saveThrottler[taskId] = Timer(const Duration(seconds: 2), () {
      _saveThrottler.remove(taskId);
      final task = _tasks[taskId];
      if (task != null) {
        _saveTask(task);
      }
    });
  }

  /// Save task to Isar
  Future<void> _saveTask(DownloadTask task) async {
    // Check if task is still in memory (not deleted)
    if (!_tasks.containsKey(task.taskId)) return;

    try {
      await _isar.writeTxn(() async {
        // Double check existence to prevent race condition with deletion
        if (_tasks.containsKey(task.taskId)) {
          await _isar.downloadTasks.put(task);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error saving task to Isar: $e');
      }
    }
  }

  /// Load tasks from Isar
  Future<void> _loadTasks() async {
    try {
      final tasks = await _isar.downloadTasks.where().findAll();
      _tasks.clear();
      for (final task in tasks) {
        _tasks[task.taskId] = task;
      }
      _notifyUpdate();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks from Isar: $e');
      }
    }
  }

  void dispose() {
    _taskController.close();
  }
}
