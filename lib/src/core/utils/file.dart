import 'dart:io';

import 'log.dart';

class FileHelper {
  static Future<bool> fileExist(String filepath) async {
    try {
      final file = File(filepath);
      return await file.exists();
    } catch (e) {
      logR("fileExist", e.toString());
      return false;
    }
  }
}
