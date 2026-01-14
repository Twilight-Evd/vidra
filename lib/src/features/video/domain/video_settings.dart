import 'package:isar/isar.dart';

part 'video_settings.g.dart';

@collection
class VideoSettings {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('videoId')], unique: true, replace: true)
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
