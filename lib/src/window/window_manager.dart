import 'package:bitsdojo_window/bitsdojo_window.dart';

import 'video_player_window.dart';

class WindowManager {
  static void register() {
    WindowRouter.register(
      name: 'player',
      builder: (context, args) => const VideoPlayerWindowApp(),
    );
  }
}
