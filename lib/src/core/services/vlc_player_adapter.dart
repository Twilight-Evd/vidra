import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:vidra_player/core/lifecycle/lifecycle_token.dart';
import 'package:vidra_player/core/lifecycle/safe_stream.dart';
import 'package:vidra_player/core/interfaces/video_player.dart';
import 'package:vidra_player/core/model/model.dart';
import 'package:vidra_vlc/vidra_vlc.dart'
    hide PlayerError, BufferRange, VideoSize, VideoSource;

class VlcPlayerAdapter with LifecycleTokenProvider implements IVideoPlayer {
  VlcPlayerController? _controller;

  final _positionCtrl = StreamController<Duration>.broadcast();
  final _playingCtrl = StreamController<bool>.broadcast();
  final _bufferingCtrl = StreamController<bool>.broadcast();
  final _errorCtrl = StreamController<PlayerError?>.broadcast();
  final _bufferedCtrl = StreamController<List<BufferRange>>.broadcast();
  final _videoSizeCtrl = StreamController<VideoSize?>.broadcast();

  @override
  Future<void> initialize(VideoSource source) async {
    // Prevent leak: Dispose existing controller if initialize is called without reset
    if (_controller != null) {
      await reset();
    }

    switch (source.type) {
      case VideoSourceType.network:
        _controller = await VlcPlayerController.network(
          source.path,
          autoPlay: false,
        );
        break;
      case VideoSourceType.file:
        _controller = await VlcPlayerController.file(
          source.path,
          autoPlay: false,
        );
        break;
      case VideoSourceType.asset:
        _controller = await VlcPlayerController.asset(
          source.path,
          autoPlay: false,
        );
        break;
    }

    await _controller!.initialize();

    final size = _controller!.value.size;
    if (size != null) {
      _videoSizeCtrl.add(VideoSize(size.width.toInt(), size.height.toInt()));
    }

    _controller!.addListener(_onTick);
  }

  void _onTick() {
    final token = lifecycleToken;
    if (!token.isAlive) return;
    if (_controller == null || !_controller!.value.isInitialized) return;
    final value = _controller!.value;

    safeEmit(_positionCtrl, value.position, token);
    safeEmit(_playingCtrl, value.isPlaying, token);
    safeEmit(_bufferingCtrl, value.isBuffering, token);

    if (value.hasError) {
      safeEmit(
        _errorCtrl,
        PlayerError(
          code: "PLAYBACK_ERROR",
          message: value.errorDescription ?? 'Unknown error',
        ),
        token,
      );
    }

    if (value.size != null) {
      safeEmit(
        _videoSizeCtrl,
        VideoSize(value.size!.width.toInt(), value.size!.height.toInt()),
        token,
      );
    }
  }

  @override
  VideoSize? get videoSize {
    if (_controller == null || !_controller!.value.isInitialized) return null;
    final size = _controller!.value.size;
    if (size == null) return null;
    return VideoSize(size.width.toInt(), size.height.toInt());
  }

  @override
  Widget render({
    Key? key,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const SizedBox();
    }

    return VlcPlayer(_controller!, key: key);
  }

  // ---- playback ----

  @override
  Future<void> play() => _controller!.play();

  @override
  Future<void> pause() => _controller!.pause();

  @override
  Future<void> seek(Duration position) => _controller!.seekTo(position);

  @override
  Future<void> setVolume(double volume) => _controller!.setVolume(volume);

  @override
  Future<void> setPlaybackSpeed(double speed) =>
      _controller!.setPlaybackSpeed(speed);

  // ---- state ----

  @override
  Duration get duration => _controller!.value.duration;

  @override
  Duration get position => _controller!.value.position;

  @override
  bool get isPlaying => _controller!.value.isPlaying;

  @override
  Stream<Duration> get positionStream => _positionCtrl.stream;

  @override
  Stream<bool> get bufferingStream => _bufferingCtrl.stream;

  @override
  Stream<bool> get isPlayingStream => _playingCtrl.stream;

  @override
  Stream<PlayerError?> get errorStream => _errorCtrl.stream;

  @override
  Stream<List<BufferRange>> get bufferedStream => _bufferedCtrl.stream;

  @override
  Stream<VideoSize?> get videoSizeStream => _videoSizeCtrl.stream;

  @override
  Future<void> reset() async {
    if (_controller == null) return;
    final controller = _controller!;
    _controller = null;

    try {
      controller.removeListener(_onTick);
      await controller.dispose();
    } catch (e) {
      // Ignore errors during disposal
    }
  }

  @override
  Future<void> dispose() async {
    invalidateLifecycle();
    await reset();
    await _positionCtrl.close();
    await _playingCtrl.close();
    await _bufferingCtrl.close();
    await _errorCtrl.close();
    await _bufferedCtrl.close();
    await _videoSizeCtrl.close();
  }
}
