import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../../features/video/data/video_repository.dart';
import '../../features/settings/domain/app_settings.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final videoRepo = ref.watch(videoRepositoryProvider);
    final isar = videoRepo.isar;

    // Load initial state
    final settings = isar.appSettings.getSync(0);
    print("ThemeModeNotifier: build() - settings found: ${settings != null}");
    if (settings != null) {
      print(
        "ThemeModeNotifier: build() - initial theme: ${settings.themeMode}",
      );
      // We can't set state directly here if we want to return it,
      // but we can return the correct initial value.
      _listenToChanges(isar);
      return settings.themeMode;
    }

    _listenToChanges(isar);
    return ThemeMode.dark;
  }

  void _listenToChanges(Isar isar) {
    print("ThemeModeNotifier: starting watcher for AppSettings(id=0)");
    final query = isar.appSettings.where().idEqualTo(0).build();
    final subscription = query.watch().listen((settings) {
      if (settings.isNotEmpty) {
        final newTheme = settings.first.themeMode;
        print("ThemeModeNotifier: watcher triggered - NEW THEME: $newTheme");
        state = newTheme;
      }
    });

    ref.onDispose(() => subscription.cancel());
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    print("ThemeModeNotifier: setThemeMode($mode)");
    final videoRepo = ref.read(videoRepositoryProvider);
    final isar = videoRepo.isar;
    final currentSettings = await isar.appSettings.get(0) ?? AppSettings();
    currentSettings.themeMode = mode;
    await isar.writeTxn(() async {
      await isar.appSettings.put(currentSettings);
    });
    state = mode;
  }

  Future<void> toggleTheme() async {
    final videoRepo = ref.read(videoRepositoryProvider);
    final isar = videoRepo.isar;
    final currentSettings = await isar.appSettings.get(0) ?? AppSettings();

    final nextMode = currentSettings.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    currentSettings.themeMode = nextMode;

    await isar.writeTxn(() async {
      await isar.appSettings.put(currentSettings);
    });

    state = nextMode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
