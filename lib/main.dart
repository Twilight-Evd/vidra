import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvp/fvp.dart' as fvp;

import 'package:vidra/src/core/services/service.dart';
import 'package:vidra/src/core/utils/window.dart';
import 'package:vidra/src/window/window_manager.dart';

import 'src/config/app_theme.dart';
import 'src/config/no_scrollbar_behavior.dart';
import 'src/core/providers/theme_provider.dart';
import 'src/features/video/data/video_repository.dart';
import 'src/routing/app_router.dart';
import 'package:vidra/src/features/settings/presentation/settings_provider.dart';
import 'src/features/download/data/download_manager.dart';
import 'src/core/services/download_service.dart';

import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import 'package:vidra/src/features/video/domain/video_collection.dart';
import 'package:vidra/src/features/video/domain/video_settings.dart';
import 'package:vidra/src/features/video/domain/play_history.dart';
import 'package:vidra/src/features/download/domain/download_task.dart';
import 'package:vidra/src/features/settings/domain/app_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  fvp.registerWith();

  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([
    VideoSchema,
    VideoSettingsSchema,
    VideoHistorySchema,
    EpisodeHistorySchema,
    DownloadTaskSchema,
    AppSettingsSchema,
  ], directory: dir.path);

  // Initial seeding (only for main window to avoid race conditions)
  if (appWindow.isMainWindow) {
    await isar.writeTxn(() async {
      final settings = await isar.appSettings.get(0);
      if (settings == null) {
        await isar.appSettings.put(AppSettings());
      }
    });
  }

  // Read initial data source config
  final appSettings = await isar.appSettings.get(0);
  final initialDataSourceId = appSettings?.lastDataSourceId ?? 'mock';
  final savedLocale = appSettings?.locale;

  final container = ProviderContainer(
    overrides: [
      isarProvider.overrideWithValue(isar),
      initialDataSourceIdProvider.overrideWithValue(initialDataSourceId),
    ],
  );

  // Initialize services - ONLY for main window
  if (appWindow.isMainWindow) {
    // Initialize download manager and service - Blocking
    await DownloadManager().initialize(isar);
    DownloadService().initialize(isar);
    // Initialize FFmpeg in background - Non-blocking
    Services.initFFmpeg();
  }

  WindowManager.register();
  WindowHelper.init(container.read(settingsRepositoryProvider));

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

  doWhenWindowReady(() {
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
    );
  }
}
