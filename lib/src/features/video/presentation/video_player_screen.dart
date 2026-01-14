import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:vidra_player/adapters/video_player/video_player.dart';
import 'package:vidra_player/controller/player_controller.dart';
import 'package:vidra_player/core/model/model.dart' as vidra_model;
import 'package:vidra_player/core/model/player_locale.dart';
import 'package:vidra_player/ui/player_widget.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/services/window.dart';
import '../../../core/services/vidra_media_repository.dart';
import '../data/video_repository.dart';
import '../domain/video_collection.dart';
import '../../../common/netflix_loading.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String videoId;
  final String? sourceId;
  final int initialEpisodeIndex;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    this.sourceId,
    this.initialEpisodeIndex = 0,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen>
    with TickerProviderStateMixin {
  PlayerController? _controller;
  bool _isClosing = false;

  @override
  void didUpdateWidget(VideoPlayerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoId != widget.videoId ||
        oldWidget.sourceId != widget.sourceId) {
      _controller?.dispose();
      _controller = null;
    } else if (oldWidget.initialEpisodeIndex != widget.initialEpisodeIndex) {
      if (_controller != null &&
          _controller!.media.currentEpisodeIndex !=
              widget.initialEpisodeIndex) {
        _controller!.switchEpisode(widget.initialEpisodeIndex);
      }
    }
  }

  vidra_model.VideoMetadata _mapMetadata(Video video) {
    return vidra_model.VideoMetadata(
      id: "${video.apiId}_${widget.sourceId}",
      title: video.title,
      description: video.description,
      coverUrl: video.coverUrl,
    );
  }

  List<vidra_model.VideoEpisode> _mapEpisodes(Video video) {
    return video.urls!.asMap().entries.map((entry) {
      final key = entry.key;
      final ve = entry.value;
      final qualities =
          ve.qualities
              ?.map(
                (q) => vidra_model.VideoQuality(
                  label: q.name ?? "Auto",
                  source: vidra_model.VideoSource.network(q.url!),
                ),
              )
              .toList() ??
          [];

      return vidra_model.VideoEpisode(
        title: ve.title ?? "",
        index: key,
        qualities: qualities,
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    WakelockPlus.enable();
    doWhenWindowReady(() {
      if (mounted) {
        appWindow.setWindowTitleBarButtonVisibility(
          DesktopWindowButton.close,
          false,
        );
        appWindow.setWindowTitleBarButtonVisibility(
          DesktopWindowButton.minimize,
          false,
        );
        appWindow.setWindowTitleBarButtonVisibility(
          DesktopWindowButton.zoom,
          false,
        );
      }
    });
  }

  @override
  void dispose() {
    _cleanup();
    super.dispose();
  }

  void _cleanup() {
    try {
      if (appWindow.handle != null) {
        appWindow.setWindowTitleBarButtonVisibility(
          DesktopWindowButton.close,
          true,
        );
        appWindow.setWindowTitleBarButtonVisibility(
          DesktopWindowButton.minimize,
          true,
        );
        appWindow.setWindowTitleBarButtonVisibility(
          DesktopWindowButton.zoom,
          true,
        );
      }
    } catch (e) {
      debugPrint('Error restoring title bar buttons: $e');
    }

    WakelockPlus.disable();
    _controller?.dispose();
  }

  Future<void> _handleSafeClose() async {
    if (_isClosing) return;
    _isClosing = true;

    try {
      if (_controller != null) {
        await _controller!.dispose();
        _controller = null;
      }
    } catch (e) {
      debugPrint('Error disposing player controller during close: $e');
    }

    // Give native texture threads time to spin down before killing the engine
    await Future.delayed(const Duration(milliseconds: 200));

    // Immediately close the window. Native side handles the rest.
    appWindow.close();
  }

  @override
  Widget build(BuildContext context) {
    if (_isClosing) {
      return const Scaffold(backgroundColor: Colors.black);
    }

    final id = int.tryParse(widget.videoId) ?? -1;
    final videoAsync = ref.watch(
      videoByIdProvider((id: id, refresh: false, sourceId: widget.sourceId)),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: videoAsync.when(
        data: (video) {
          if (video == null) {
            return Center(child: Text(tr('video.detail.not_found')));
          }

          if (video.urls == null || video.urls!.isEmpty) {
            return Center(child: Text(tr('video.player.no_episodes')));
          }

          final currentVidraLocale = context.locale.languageCode == 'zh'
              ? VidraLocale.zhCN
              : VidraLocale.en;

          final episodes = _mapEpisodes(video);

          // Initialize controller only if needed to prevent multiple instances
          if (_controller == null) {
            final config = vidra_model.PlayerConfig(
              initialEpisodeIndex: widget.initialEpisodeIndex,
              episodesSort: false,
              theme: const vidra_model.PlayerUITheme.netflix(),
              features: const vidra_model.PlayerFeatures.all(),
              behavior: vidra_model.PlayerBehavior(
                autoHideDelay: const Duration(seconds: 3),
                mouseHideDelay: const Duration(seconds: 2),
                hoverShowDelay: const Duration(milliseconds: 300),
                autoPlay: true,
                hideMouseWhenIdle: true,
                muteOnStart: false,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                tooltip: tr('common.close'),
                onPressed: _handleSafeClose,
              ),
              locale: currentVidraLocale,
            );

            _controller = PlayerController(
              config: config,
              video: _mapMetadata(video),
              episodes: episodes,
              player: VideoPlayerAdapter(),
              windowDelegate: BitsdojoWindowDelegate(),
              mediaRepository: VidraMediaRepository(
                ref.read(videoRepositoryProvider),
              ),
            );
          } else {
            // Optimization: Detect changes and update state instead of recreating
            if (_controller!.config.locale != currentVidraLocale) {
              _controller!.setLocale(currentVidraLocale);
            }

            // Sync episodes if count differs (e.g. new episodes added)
            if (_controller!.media.episodes.length != episodes.length) {
              _controller!.updateEpisodes(episodes);
            }

            // Sync episode index if it differs
            if (_controller!.media.currentEpisodeIndex !=
                widget.initialEpisodeIndex) {
              _controller!.switchEpisode(widget.initialEpisodeIndex);
            }
          }

          return VideoPlayerWidget(controller: _controller!);
        },
        loading: () => const Center(child: NetflixLoading(size: 50)),
        error: (e, st) =>
            Center(child: Text(tr('video.detail.error', args: [e.toString()]))),
      ),
    );
  }
}
