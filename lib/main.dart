import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvp/fvp.dart' as fvp;

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
  final dir = await getApplicationDocumentsDirectory();
  await Isar.initializeIsarCore(download: true);

  // Retry logic for Isar initialization to handle MDBX resource contention
  // This fixes "MdbxError: Cannot decode error message" in release mode
  Isar? isar;
  int retryCount = 0;
  const maxRetries = 3;

  while (isar == null && retryCount < maxRetries) {
    try {
      isar = await Isar.open(
        [
          VideoSchema,
          VideoSettingsSchema,
          VideoHistorySchema,
          EpisodeHistorySchema,
          DownloadTaskSchema,
          AppSettingsSchema,
        ],
        directory: dir.path,
        inspector: false,
        relaxedDurability: true,
      );
    } catch (e) {
      retryCount++;
      if (retryCount >= maxRetries) {
        // If all retries fail, try to clean up and rethrow
        debugPrint('Failed to open Isar after $maxRetries attempts: $e');
        rethrow;
      }
      // Wait before retry to allow system resources to become available
      debugPrint(
        'Isar open failed (attempt $retryCount/$maxRetries), retrying in 500ms: $e',
      );
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // Assert non-null after retry loop
  final isarInstance = isar!;

  if (appWindow.isMainWindow) {
    await isarInstance.writeTxn(() async {
      final settings = await isarInstance.appSettings.get(0);
      if (settings == null) {
        await isarInstance.appSettings.put(AppSettings());
      }
    });
  }

  final appSettings = await isarInstance.appSettings.get(0);
  final initialDataSourceId = appSettings?.lastDataSourceId ?? 'mock';
  final savedLocale = appSettings?.locale;

  final container = ProviderContainer(
    overrides: [
      isarProvider.overrideWithValue(isarInstance),
      initialDataSourceIdProvider.overrideWithValue(initialDataSourceId),
    ],
  );

  // 3. Services initialization
  if (appWindow.isMainWindow) {
    await DownloadManager().initialize(isarInstance);
    DownloadService().initialize(isarInstance);
    // Services.initFFmpeg();
  }

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

      // FramePerformanceMonitor.initialize();

      // DEFERRED INIT: Initialize Sentry after window is ready to avoid startup hangs
      // await SentryConfig.initialize(
      //   appRunner: () {}, // No-op runner since app is already running
      //   release: 'vidra@1.0.0+1',
      //   tracesSampleRate: 1.0,
      // );
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
