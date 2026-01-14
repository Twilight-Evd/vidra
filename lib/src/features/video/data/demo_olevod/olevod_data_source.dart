import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../../../core/services/video_thumbnail_service.dart';
import 'package:vidra/src/features/video/domain/category.dart';
import 'package:vidra/src/features/video/domain/video_collection.dart';
import 'package:vidra/src/features/video/data/video_data_source.dart';
import 'olevod_categories.dart';
import 'video_signature_helper.dart';
import 'olevod_dto.dart';

class OlevodDataSource implements VideoDataSource {
  static const String _apiBaseUrl = 'https://api.olelive.com';
  static const String _cdnBaseUrl = 'https://www.olevod.com';
  // ignore: unused_field
  static const String _imageBaseUrl = 'https://image.tmdb.org';

  final Dio _dio;
  final VideoThumbnailService _thumbnailService;

  OlevodDataSource(this._dio, this._thumbnailService);

  @override
  String get id => 'olevod';

  @override
  String get name => '测试欧乐影院';

  @override
  Future<List<Category>> getCategories() async {
    return kVideoCategories;
  }

  @override
  Future<VideoResponse> fetchVideos({
    required int categoryId,
    int? subTypeId,
    String? area,
    String? year,
    int page = 1,
  }) async {
    final catIdStr = categoryId.toString();
    final subIdStr = (subTypeId ?? 0).toString();
    final areaStr = (area == null || area == '全部地区')
        ? '0'
        : Uri.encodeComponent(area);
    final yearStr = (year == null || year == '全部年份') ? '0' : year;

    final path =
        '$_apiBaseUrl/v1/pub/vod/list/true/3/0/$areaStr/$catIdStr/$subIdStr/$yearStr/update/$page/48';
    final sign = VideoSignatureHelper.generate();

    try {
      final response = await _dio.get(path, queryParameters: {'_vv': sign});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['code'] == 0) {
          final listData = data['data']['list'] as List;
          final videos = listData.map((e) {
            final v = OlevodVideoDto.fromJson(e).toDomain();
            v.coverUrl = resolveUrl(v.coverUrl);
            if (v.thumbUrl != null) v.thumbUrl = resolveUrl(v.thumbUrl!);
            v.sourceId = id;
            return v;
          }).toList();
          return VideoResponse(
            list: videos,
            total: data['data']['total'],
            page: data['data']['page'],
          );
        }
      }
      return VideoResponse(list: [], total: 0, page: 1);
    } catch (e) {
      log('[Olevod] Error fetching videos: $e');
      return VideoResponse(list: [], total: 0, page: 1);
    }
  }

  @override
  Future<Video?> getVideoDetail(int id) async {
    final path = '$_apiBaseUrl/v1/pub/vod/detail/$id/true';
    final sign = VideoSignatureHelper.generate();
    log('[Olevod] Fetching video detail: $path');

    try {
      final response = await _dio.get(path, queryParameters: {'_vv': sign});
      if (response.statusCode == 200) {
        final data = response.data;
        log('[Olevod] Detail response code: ${data['code']}');

        if (data['code'] == 0) {
          dynamic videoData = data['data'];
          if (videoData is List && videoData.isNotEmpty) {
            videoData = videoData.first;
          }
          if (videoData is! Map<String, dynamic>) {
            log('[Olevod] Invalid video data type: ${videoData?.runtimeType}');
            return null;
          }
          log('[Olevod] Video data keys: ${videoData.keys.join(', ')}');
          final v = OlevodVideoDto.fromJson(videoData).toDomain();
          v.coverUrl = resolveUrl(v.coverUrl);
          if (v.thumbUrl != null) v.thumbUrl = resolveUrl(v.thumbUrl!);
          if (v.backdropUrl != null) v.backdropUrl = resolveUrl(v.backdropUrl!);
          v.sourceId = this.id;

          if (v.urls != null) {
            for (final episode in v.urls!) {
              if (episode.qualities != null) {
                for (final quality in episode.qualities!) {
                  if (quality.url != null) {
                    quality.url = resolveUrl(quality.url!);
                  }
                }
              }
            }
          }
          return v;
        }
      }
      return null;
    } catch (e) {
      log('[Olevod] Error fetching video detail: $e');
      return null;
    }
  }

  @override
  Future<List<Video>> searchVideos(String keyword) async {
    final encodedKeyword = Uri.encodeComponent(keyword);
    final path = '$_apiBaseUrl/v1/pub/index/search/$encodedKeyword/vod/0/1/4';
    final sign = VideoSignatureHelper.generate();

    try {
      final response = await _dio.get(path, queryParameters: {'_vv': sign});
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['code'] == 0) {
          final outerData = data['data'];
          if (outerData != null && outerData['data'] is List) {
            final dataList = outerData['data'] as List;
            for (final item in dataList) {
              if (item['type'] == 'vod' && item['list'] is List) {
                final videoList = item['list'] as List;
                return videoList.map((e) {
                  final v = OlevodVideoDto.fromJson(e).toDomain();
                  v.coverUrl = resolveUrl(v.coverUrl);
                  if (v.thumbUrl != null) v.thumbUrl = resolveUrl(v.thumbUrl!);
                  v.sourceId = id;
                  return v;
                }).toList();
              }
            }
          }
        }
      }
      return [];
    } catch (e) {
      log('[Olevod] Error searching videos: $e');
      return [];
    }
  }

  @override
  String resolveUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return '$_cdnBaseUrl/$url';
  }

  @override
  Future<String?> getDownloadUrl(Video video, {VideoEpisode? episode}) async {
    final targetEpisode = episode ?? video.urls?.firstOrNull;
    if (targetEpisode == null || targetEpisode.url == null) return null;
    return resolveUrl(targetEpisode.url!);
  }

  @override
  Future<Uint8List?> getThumbnail(
    Video video, {
    VideoEpisode? episode,
    required Duration time,
  }) async {
    final targetEpisode = episode ?? video.urls?.firstOrNull;
    if (targetEpisode == null || targetEpisode.url == null) return null;

    final videoUrl = resolveUrl(targetEpisode.url!);

    return _thumbnailService.getThumbnail(
      videoId: video.apiId.toString(),
      videoUrl: videoUrl,
      time: time,
    );
  }
}
