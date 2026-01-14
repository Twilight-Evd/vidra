import 'dart:io';

class FileHelper {
  static Future<bool> fileExist(String filepath) async {
    try {
      final file = File(filepath);
      return await file.exists();
    } catch (e) {
      print(e);
      return false;
    }
  }
}
