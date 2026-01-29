import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:fvp/fvp.dart' as fvp;

import 'src/core/utils/window.dart';
import 'src/window/window_manager.dart';

import 'src/config/app_theme.dart';
import 'src/config/no_scrollbar_behavior.dart';
import 'src/core/providers/theme_provider.dart'; // Import theme_provider
import 'src/features/video/data/video_repository.dart';
import 'src/routing/app_router.dart';
import 'src/features/settings/presentation/settings_provider.dart';
import 'src/features/download/data/download_manager.dart';

import 'src/data/database/app_database.dart';
import 'src/data/database/app_database_provider.dart';
import 'src/data/database/mappers.dart';

Future<void> main() async {
  await _runApp();
}

Future<void> _runApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 1. Core language and plugins
  await EasyLocalization.ensureInitialized();

  PaintingBinding.instance.imageCache.maximumSize = 50;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 30 * 1024 * 1024;
  try {
    fvp.registerWith();
  } catch (e) {
    debugPrint('Error registering fvp: $e');
  }

  // 2. Data layers
  final database = AppDatabase();

  if (appWindow.isMainWindow) {
    await database.transaction(() async {
      // Use get().then to be 100% safe against duplicates
      final settingsList = await (database.select(
        database.appSettings,
      )..limit(1)).get();
      final s = settingsList.isEmpty ? null : settingsList.first;

      if (s == null) {
        // AppSettingsCompanion.insert() by default has id as Value.absent()
        // so it will auto-increment to 1.
        await database
            .into(database.appSettings)
            .insert(
              AppSettingsCompanion.insert(), // Defaults
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  // Read settings for initial config
  // More robust way to get exactly one or null
  final settingsList = await (database.select(
    database.appSettings,
  )..limit(1)).get();
  final appSettingsData = settingsList.isEmpty ? null : settingsList.first;
  final appSettings = appSettingsData?.toDomain();

  final initialDataSourceId = appSettings?.lastDataSourceId ?? 'mock';
  final savedLocale = appSettings?.locale;
  final initialThemeMode =
      appSettings?.themeMode ?? ThemeMode.dark; // Get initial theme

  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(database),
      initialDataSourceIdProvider.overrideWithValue(initialDataSourceId),
      initialThemeModeProvider.overrideWithValue(
        initialThemeMode,
      ), // Override theme
    ],
  );

  // 3. Services initialization
  await DownloadManager().initialize(
    database,
    startProcessing: appWindow.isMainWindow,
  );

  WindowManager.register();
  WindowHelper.init(container.read(settingsRepositoryProvider));

  // Replace the loading app with the real app
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('zh'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: savedLocale != null ? Locale(savedLocale) : null,
      child: UncontrolledProviderScope(
        container: container,
        child: const MainWindowEntry(),
      ),
    ),
  );

  doWhenWindowReady(() async {
    if (appWindow.isMainWindow) {
      final screenSize = appWindow.workingScreenSize;
      final initialSize = Size(screenSize.width * 0.8, screenSize.height * 0.8);
      appWindow.minSize = Size(screenSize.width * 0.6, screenSize.height * 0.6);
      appWindow.size = initialSize;
      appWindow.alignment = Alignment.center;
    }
    appWindow.backgroundEffect = WindowEffect.acrylic;
    appWindow.show();
  });
}

class MainWindowEntry extends StatelessWidget {
  const MainWindowEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return WindowRouter.build(context, appWindow, defaultWidget: const MyApp());
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'Vidra',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      scrollBehavior: NoScrollbarBehavior(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      showSemanticsDebugger: false,
    );
  }
}
