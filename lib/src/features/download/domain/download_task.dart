import 'package:isar/isar.dart';

part 'download_task.g.dart';

/// Download task status
enum DownloadStatus {
  queued,
  downloading,
  paused,
  completed,
  failed,
  cancelled,
}

/// Individual episode download info
@embedded
class EpisodeDownloadInfo {
  final int? index;
  final String? title;
  final String? url;
  final String? outputPath;
  @enumerated
  final DownloadStatus status;
  final double progress; // 0.0 to 1.0
  final int bytesDownloaded;
  final int totalBytes;
  final DateTime? startTime;
  final DateTime? completedTime;
  final String? error;

  EpisodeDownloadInfo({
    this.index,
    this.title,
    this.url,
    this.outputPath,
    this.status = DownloadStatus.queued,
    this.progress = 0.0,
    this.bytesDownloaded = 0,
    this.totalBytes = 0,
    this.startTime,
    this.completedTime,
    this.error,
  });

  EpisodeDownloadInfo copyWith({
    int? index,
    String? title,
    String? url,
    String? outputPath,
    DownloadStatus? status,
    double? progress,
    int? bytesDownloaded,
    int? totalBytes,
    DateTime? startTime,
    DateTime? completedTime,
    String? error,
  }) {
    return EpisodeDownloadInfo(
      index: index ?? this.index,
      title: title ?? this.title,
      url: url ?? this.url,
      outputPath: outputPath ?? this.outputPath,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      bytesDownloaded: bytesDownloaded ?? this.bytesDownloaded,
      totalBytes: totalBytes ?? this.totalBytes,
      startTime: startTime ?? this.startTime,
      completedTime: completedTime ?? this.completedTime,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'index': index,
      'title': title,
      'url': url,
      'outputPath': outputPath,
      'status': status.name,
      'progress': progress,
      'bytesDownloaded': bytesDownloaded,
      'totalBytes': totalBytes,
      'startTime': startTime?.toIso8601String(),
      'completedTime': completedTime?.toIso8601String(),
      'error': error,
    };
  }

  factory EpisodeDownloadInfo.fromJson(Map<String, dynamic> json) {
    return EpisodeDownloadInfo(
      index: json['index'] as int?,
      title: json['title'] as String?,
      url: json['url'] as String?,
      outputPath: json['outputPath'] as String?,
      status: DownloadStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DownloadStatus.queued,
      ),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      bytesDownloaded: json['bytesDownloaded'] as int? ?? 0,
      totalBytes: json['totalBytes'] as int? ?? 0,
      startTime: json['startTime'] != null
          ? DateTime.parse(json['startTime'] as String)
          : null,
      completedTime: json['completedTime'] != null
          ? DateTime.parse(json['completedTime'] as String)
          : null,
      error: json['error'] as String?,
    );
  }
}

/// Download task for a video (can contain multiple episodes)
@collection
class DownloadTask {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String taskId;

  @Index()
  late int videoId;

  late String videoTitle;
  String? coverUrl;
  late List<EpisodeDownloadInfo> episodes;
  late DateTime createdAt;
  DateTime? completedAt;

  DownloadTask({
    this.taskId = '',
    required this.videoId,
    required this.videoTitle,
    this.coverUrl,
    required this.episodes,
    required this.createdAt,
    this.completedAt,
  });

  /// Overall task status
  @ignore
  DownloadStatus get status {
    if (episodes.isEmpty) return DownloadStatus.queued;

    if (episodes.every((e) => e.status == DownloadStatus.completed)) {
      return DownloadStatus.completed;
    }

    if (episodes.any((e) => e.status == DownloadStatus.downloading)) {
      return DownloadStatus.downloading;
    }

    if (episodes.any((e) => e.status == DownloadStatus.failed)) {
      return DownloadStatus.failed;
    }

    if (episodes.every((e) => e.status == DownloadStatus.cancelled)) {
      return DownloadStatus.cancelled;
    }

    if (episodes.every(
      (e) =>
          e.status == DownloadStatus.paused ||
          e.status == DownloadStatus.completed,
    )) {
      if (episodes.any((e) => e.status == DownloadStatus.paused)) {
        return DownloadStatus.paused;
      }
    }

    return DownloadStatus.queued;
  }

  /// Overall progress (0.0 to 1.0)
  @ignore
  double get progress {
    if (episodes.isEmpty) return 0.0;
    final totalProgress = episodes.fold<double>(
      0,
      (sum, episode) => sum + episode.progress,
    );
    return totalProgress / episodes.length;
  }

  /// Total bytes downloaded across all episodes
  @ignore
  int get totalBytesDownloaded {
    return episodes.fold<int>(
      0,
      (sum, episode) => sum + episode.bytesDownloaded,
    );
  }

  /// Total bytes across all episodes
  @ignore
  int get totalBytes {
    return episodes.fold<int>(0, (sum, episode) => sum + episode.totalBytes);
  }

  /// Estimated time remaining in seconds
  @ignore
  int? get estimatedTimeRemaining {
    final downloadingEpisodes = episodes.where(
      (e) => e.status == DownloadStatus.downloading && e.startTime != null,
    );

    if (downloadingEpisodes.isEmpty) return null;

    // Simple estimation based on one downloading episode
    final active = downloadingEpisodes.first;
    if (active.progress <= 0 || active.bytesDownloaded <= 0) return null;

    final duration = DateTime.now().difference(active.startTime!);
    final bytesPerSecond = active.bytesDownloaded / duration.inSeconds;

    if (bytesPerSecond <= 0) return null;

    final remainingBytes = active.totalBytes - active.bytesDownloaded;
    return (remainingBytes / bytesPerSecond).round();
  }

  /// Download speed in bytes per second
  @ignore
  double? get downloadSpeed {
    final downloadingEpisodes = episodes.where(
      (e) => e.status == DownloadStatus.downloading && e.startTime != null,
    );

    if (downloadingEpisodes.isEmpty) return null;

    final active = downloadingEpisodes.first;
    if (active.bytesDownloaded <= 0) return 0.0;

    final duration = DateTime.now().difference(active.startTime!);
    if (duration.inSeconds <= 0) return 0.0;

    return active.bytesDownloaded / duration.inSeconds;
  }

  DownloadTask copyWith({
    String? taskId,
    int? videoId,
    String? videoTitle,
    String? coverUrl,
    List<EpisodeDownloadInfo>? episodes,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return DownloadTask(
      taskId: taskId ?? this.taskId,
      videoId: videoId ?? this.videoId,
      videoTitle: videoTitle ?? this.videoTitle,
      coverUrl: coverUrl ?? this.coverUrl,
      episodes: episodes ?? this.episodes,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskId': taskId,
      'videoId': videoId,
      'videoTitle': videoTitle,
      'coverUrl': coverUrl,
      'episodes': episodes.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory DownloadTask.fromJson(Map<String, dynamic> json) {
    return DownloadTask(
      taskId: json['taskId'] as String? ?? json['id'] as String? ?? '',
      videoId: json['videoId'] as int,
      videoTitle: json['videoTitle'] as String,
      coverUrl: json['coverUrl'] as String?,
      episodes: (json['episodes'] as List<dynamic>)
          .map((e) => EpisodeDownloadInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }
}
