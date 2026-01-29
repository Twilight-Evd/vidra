import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../data/database/app_database_provider.dart';
import '../../../data/database/mappers.dart';
import '../../features/settings/domain/app_settings.dart' as domain;

// Provider for initial value (overridden in main.dart)
final initialThemeModeProvider = Provider<ThemeMode>((ref) => ThemeMode.dark);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final db = ref.watch(appDatabaseProvider);
    final initial = ref.watch(initialThemeModeProvider);

    // Watch for changes in AppSettings
    // Using watch().first as a robust alternative if needed, but watchSingleOrNull should be fine with limit(1)
    final subscription = (db.select(db.appSettings)..limit(1)).watch().listen((
      list,
    ) {
      final settingsData = list.isEmpty ? null : list.first;
      if (settingsData != null) {
        final newMode = ThemeMode.values[settingsData.themeMode];
        if (state != newMode) {
          state = newMode;
        }
      }
    });
    ref.onDispose(() => subscription.cancel());

    return initial;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final db = ref.read(appDatabaseProvider);

    await db.transaction(() async {
      // Robust loading
      final list = await (db.select(db.appSettings)..limit(1)).get();
      final existing = list.isEmpty ? null : list.first;
      var settings = existing != null
          ? existing.toDomain()
          : domain.AppSettings();

      settings.themeMode = mode;

      await db
          .into(db.appSettings)
          .insert(settings.toCompanion(), mode: InsertMode.insertOrReplace);
    });
    state = mode;
  }

  Future<void> toggleTheme() async {
    final current = state;
    final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
