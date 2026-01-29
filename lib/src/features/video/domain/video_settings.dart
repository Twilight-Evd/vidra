class VideoSettings {
  int id = 0;

  String? sourceId;

  late int videoId;

  // Intro skip duration in seconds
  int introDuration = 0;

  // Outro skip duration in seconds
  int outroDuration = 0;

  VideoSettings();

  VideoSettings.withValues({
    required this.videoId,
    this.sourceId,
    this.introDuration = 0,
    this.outroDuration = 0,
  });
}
