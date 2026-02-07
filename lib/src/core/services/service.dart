import 'dart:io';

import 'package:archive/archive_io.dart';

import '../utils/file.dart';
import '../utils/helper.dart';
import '../utils/log.dart';
import '../utils/path.dart';

class Services {
  static Future<void> initFFmpeg() async {
    try {
      final shellPath = UtilHelper.getShellPath();
      final ffmpegZip = PathHelper.join(shellPath, "ffmpeg.zip");
      final ffmpegFile = PathHelper.join(
        shellPath,
        Platform.isWindows ? "ffmpeg.exe" : "ffmpeg",
      );
      if (!await FileHelper.fileExist(ffmpegFile)) {
        extractFileToDisk(ffmpegZip, shellPath);
      }
    } catch (e) {
      logR("initFFmpeg", e.toString());
    }
  }
}
