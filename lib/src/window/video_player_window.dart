import 'package:easy_localization/easy_localization.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_theme.dart';
import '../core/providers/theme_provider.dart';
import '../features/video/presentation/video_player_screen.dart';
import '../core/utils/window.dart';

import '../config/no_scrollbar_behavior.dart';

class VideoPlayerWindowApp extends ConsumerWidget {
  const VideoPlayerWindowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vidra Player',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const VideoPlayerWindow(),
      scrollBehavior: NoScrollbarBehavior(),
    );
  }
}

class VideoPlayerWindow extends StatefulWidget {
  const VideoPlayerWindow({super.key});

  @override
  State<VideoPlayerWindow> createState() => _VideoPlayerWindowState();
}

class _VideoPlayerWindowState extends State<VideoPlayerWindow>
    with WidgetsBindingObserver {
  String? _videoId;
  String? _sourceId;
  int _episodeIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateFromArguments();

    // Listen for updates from main window
    appWindow.onArgumentsChanged = () {
      if (mounted) {
        setState(() {
          _updateFromArguments();
        });
      }
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WindowHelper.saveWindowSize();
  }

  void _updateFromArguments() {
    final args = appWindow.arguments as Map?;
    if (args != null) {
      if (args.containsKey('videoId')) {
        _videoId = args['videoId'].toString();
      }
      if (args.containsKey('sourceId')) {
        _sourceId = args['sourceId']?.toString();
      }
      if (args.containsKey('episodeIndex')) {
        _episodeIndex = int.tryParse(args['episodeIndex'].toString()) ?? 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return Scaffold(
        // backgroundColor: Colors.black,
        body: Center(
          child: Text(
            tr('common.waiting_for_video'),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      );
    }

    // Using Key to force rebuild only when video/source changes
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (details) {
        appWindow.startDragging();
      },
      child: VideoPlayerScreen(
        key: ValueKey('$_videoId-$_sourceId'),
        videoId: _videoId!,
        sourceId: _sourceId,
        initialEpisodeIndex: _episodeIndex,
      ),
    );
  }
}
