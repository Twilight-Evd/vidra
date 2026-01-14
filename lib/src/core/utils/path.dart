import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PathHelper {
  static String join(
    String part1, [
    String? part2,
    String? part3,
    String? part4,
    String? part5,
    String? part6,
    String? part7,
    String? part8,
    String? part9,
    String? part10,
    String? part11,
    String? part12,
    String? part13,
    String? part14,
    String? part15,
    String? part16,
  ]) {
    return p.join(
      part1,
      part2,
      part3,
      part4,
      part5,
      part6,
      part7,
      part8,
      part9,
      part10,
      part11,
      part12,
      part13,
      part14,
      part15,
      part16,
    );
  }

  static String dirname(String path) {
    return p.dirname(path);
  }

  static String basename(String path) {
    return p.basename(path);
  }

  static String getRelativePath(String basePath, String fullPath) {
    final normalizedBase = p.normalize(p.absolute(basePath)) + p.separator;
    final normalizedFull = p.normalize(p.absolute(fullPath)) + p.separator;
    if (normalizedFull == normalizedBase) {
      return '';
    }
    if (!normalizedFull.startsWith(normalizedBase)) {
      throw ArgumentError('The fullPath does not start with the basePath.');
    }
    final relativePath = normalizedFull.substring(normalizedBase.length);
    return Uri.decodeComponent(
      relativePath.substring(0, relativePath.length - p.separator.length),
    );
  }

  static Future<String> getBaseDestinationDirectory() async {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        final directory = await getExternalStorageDirectory();
        return directory?.path ?? '/storage/emulated/0/Download';
      case TargetPlatform.iOS:
        return (await getApplicationDocumentsDirectory()).path;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        var downloadDir = await getDownloadsDirectory();
        if (downloadDir == null) {
          if (defaultTargetPlatform == TargetPlatform.windows) {
            downloadDir = Directory(
              '${Platform.environment['HOMEPATH']}/Downloads',
            );
            if (!downloadDir.existsSync()) {
              downloadDir = Directory(Platform.environment['HOMEPATH']!);
            }
          } else {
            downloadDir = Directory(
              '${Platform.environment['HOME']}/Downloads',
            );
            if (!downloadDir.existsSync()) {
              downloadDir = Directory(Platform.environment['HOME']!);
            }
          }
        }
        return downloadDir.path;
    }
  }

  static Future<Directory> getCacheDirectory() async {
    return (await getApplicationCacheDirectory());
  }
}
