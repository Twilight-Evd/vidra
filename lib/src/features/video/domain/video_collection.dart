import 'package:isar/isar.dart';

part 'video_collection.g.dart';

@collection
class Video {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('apiId')], unique: true, replace: true)
  String? sourceId; // Track which data source this video came from

  late int apiId; // The ID provided by the data source

  @Index(type: IndexType.value)
  late String title; // mapped from 'name'

  late String coverUrl; // mapped from 'pic'

  String? thumbUrl; // mapped from 'picThumb'

  String? backdropUrl;

  late double rating; // mapped from 'score'

  String? year; // API returns string "2025"

  @Index()
  String? region; // mapped from 'area'

  @Index()
  late String type; // We might need to map typeId to 'movie' or 'series' string, or just keep typeId

  // API provided fields
  int? typeId;
  int? typeId1;
  String? actor;
  String? blurb;
  String? remarks;
  String? version;
  bool? vip;
  int? vodTime;
  int? hits;

  List<String>? genres; // derived or separate?

  String? description; // mapped from 'blurb'
  String? content; // mapped from 'content'
  String? director; // mapped from 'director'
  String? writer; // mapped from 'writer'
  String? lang; // mapped from 'lang'

  List<VideoEpisode>? urls; // Episodes

  // Constructors
  Video();
}

@embedded
class VideoQuality {
  String? name;
  String? url;

  VideoQuality();

  factory VideoQuality.withValues({String? name, String? url}) {
    final q = VideoQuality();
    q.name = name;
    q.url = url;
    return q;
  }
}

@embedded
class VideoEpisode {
  int? index;
  String? title;
  List<VideoQuality>? qualities; // NEW: Replacement for url
  bool? vip;
  bool? isNew; // mapped from 'new'

  VideoEpisode();

  // Compatibility getter
  String? get url => qualities?.firstOrNull?.url;
}
