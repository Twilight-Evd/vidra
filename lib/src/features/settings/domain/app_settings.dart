import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'app_settings.g.dart';

@collection
class AppSettings {
  Id id = 0; // Singleton, always use id = 0

  // Download settings
  String? downloadPath; // null = use default (Downloads folder)

  // Video player settings
  bool enableThumbnailPreview;

  // Download manager settings
  int maxConcurrentDownloads;

  String? lastDataSourceId;

  @enumerated
  ThemeMode themeMode;

  // Window sizes
  double? playerNormalWidth;
  double? playerNormalHeight;
  double? playerPipWidth;
  double? playerPipHeight;

  String? locale;

  AppSettings({
    this.downloadPath,
    this.enableThumbnailPreview = false,
    this.maxConcurrentDownloads = 3,
    this.themeMode = ThemeMode.dark,
    this.playerNormalWidth,
    this.playerNormalHeight,
    this.playerPipWidth,
    this.playerPipHeight,
    this.locale,
  });
}
