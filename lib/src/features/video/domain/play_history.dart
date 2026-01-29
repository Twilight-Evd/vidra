class VideoHistory {
  int id = 0;

  String? sourceId;

  late int videoId;

  late String videoTitle;
  late String coverUrl;

  // Extra fields for PopularVideoCard
  String? rating;
  late String type;
  String? region;
  String? year;
  String? actor;
  String? version;
  int? hits;
  String? remarks;
  String? blurb;

  late int lastEpisodeIndex;
  String? lastEpisodeTitle;

  late DateTime updatedAt;

  VideoHistory();

  VideoHistory.withValues({
    required this.videoId,
    required this.videoTitle,
    required this.coverUrl,
    required this.lastEpisodeIndex,
    this.lastEpisodeTitle,
    this.rating,
    required this.type,
    this.region,
    this.year,
    this.actor,
    this.version,
    this.hits,
    this.remarks,
    this.blurb,
    this.sourceId,
  }) : updatedAt = DateTime.now();
}

class EpisodeHistory {
  int id = 0;

  String? sourceId;

  late int videoId;

  late int episodeIndex;

  late int positionMillis;
  late int durationMillis;

  late DateTime updatedAt;

  EpisodeHistory();

  EpisodeHistory.withValues({
    required this.videoId,
    required this.episodeIndex,
    required this.positionMillis,
    required this.durationMillis,
    this.sourceId,
  }) : updatedAt = DateTime.now();
}
