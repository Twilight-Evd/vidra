import 'dart:typed_data' show Uint8List;

import '../../../../core/services/video_thumbnail_service.dart';
import 'package:vidra/src/features/video/domain/category.dart';
import 'package:vidra/src/features/video/domain/video_collection.dart';
import 'package:vidra/src/features/video/data/video_data_source.dart';

class MockDataSource implements VideoDataSource {
  final VideoThumbnailService _thumbnailService;

  MockDataSource(this._thumbnailService);

  @override
  String get id => 'mock';

  @override
  String get name => '模拟数据源';

  @override
  Future<List<Category>> getCategories() async {
    return [
      const Category(id: 1, name: '电影', enName: 'movie'),
      const Category(id: 2, name: '剧集', enName: 'series'),
    ];
  }

  @override
  Future<VideoResponse> fetchVideos({
    required int categoryId,
    int? subTypeId,
    String? area,
    String? year,
    int page = 1,
  }) async {
    final videos = List.generate(10, (index) {
      final v = Video();
      v.apiId = 9000 + index;
      v.title = '模拟视频 ${index + 1} (Source: Mock)';
      v.coverUrl = 'https://picsum.photos/seed/${v.apiId}/200/300';
      v.rating = 8.5;
      v.type = categoryId == 1 ? 'movie' : 'series';
      v.sourceId = id;
      return v;
    });

    return VideoResponse(list: videos, total: 10, page: 1);
  }

  @override
  Future<Video?> getVideoDetail(int id) async {
    final v = Video();
    v.apiId = id;
    v.title = '模拟视频 Detail (Source: Mock)';
    v.coverUrl = 'https://picsum.photos/seed/$id/200/300';
    v.content = '这是一个模拟视频的数据，用于测试数据源切换功能。';
    v.rating = 9.0;
    v.type = 'movie';
    v.sourceId = this.id;
    v.urls = [
      VideoEpisode()
        ..title = '第1集'
        ..qualities = [
          VideoQuality.withValues(
            name: '大兔子',
            url: 'https://www.w3school.com.cn/example/html5/mov_bbb.mp4',
          ),
          VideoQuality.withValues(
            name: '大灰熊',
            url: 'https://www.w3schools.com/html/movie.mp4',
          ),
          VideoQuality.withValues(
            name: '大白兔',
            url: 'https://test-streams.mux.dev/x36xhzz/x36xhzz.m3u8',
          ),
        ],
    ];
    return v;
  }

  @override
  Future<List<Video>> searchVideos(String keyword) async {
    return [
      Video()
        ..apiId = 9999
        ..title = '搜索结果: $keyword (Source: Mock)'
        ..coverUrl = 'https://picsum.photos/seed/search/200/300'
        ..rating = 8.0
        ..type = 'movie'
        ..sourceId = id,
    ];
  }

  @override
  String resolveUrl(String url) => url;

  @override
  Future<String?> getDownloadUrl(Video video, {VideoEpisode? episode}) async {
    return episode?.qualities?.firstOrNull?.url ??
        video.urls?.firstOrNull?.qualities?.firstOrNull?.url;
  }

  @override
  Future<Uint8List?> getThumbnail(
    Video video, {
    VideoEpisode? episode,
    required Duration time,
  }) async {
    return _thumbnailService.getThumbnail(
      videoId: video.apiId.toString(),
      videoUrl:
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      time: time,
    );
  }
}
