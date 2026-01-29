import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../video/presentation/play_history_provider.dart';
import 'widgets/sidebar.dart';
import 'domain/app_navigation_item.dart';
import 'package:vidra/src/features/dashboard/widgets/titlebar.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  final Widget child;
  const DashboardScreen({super.key, required this.child});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    appWindow.onClose = _handleClose;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When the main window gains focus again (e.g. after closing the player window)
    if (state == AppLifecycleState.resumed) {
      ref.read(playHistoryProvider.notifier).manualRefresh();
    }
  }

  bool _isExitDialogShowing = false;

  void _handleClose() {
    _showExitDialog();
  }

  void _showExitDialog() {
    if (_isExitDialogShowing) return;

    _isExitDialogShowing = true;
    appWindow.show();

    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by clicking outside to ensure flag is reset correctly
      builder: (context) {
        return AlertDialog(
          title: Text(tr('dashboard.exit_dialog.title')),
          content: Text(tr('dashboard.exit_dialog.content')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _isExitDialogShowing = false;
              },
              child: Text(tr('dashboard.exit_dialog.cancel')),
            ),
            TextButton(
              onPressed: () {
                // Ensure we don't reset the flag here as we are closing the window
                appWindow.close();
              },
              child: Text(tr('dashboard.exit_dialog.confirm')),
            ),
          ],
        );
      },
    ).then((_) {
      // Safety net: in case dialog is dismissed via back button or barrier (if enabled)
      if (mounted) {
        _isExitDialogShowing = false;
      }
    });
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location.startsWith('/downloads')) return 1;
    if (location.startsWith('/recent')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    final item = AppNavigationItem.fromBranchIndex(index);
    if (item != null) {
      context.go(item.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: WindowBorder(
        color: Colors.transparent,
        width: 1,
        child: Row(
          children: [
            Sidebar(
              selectedIndex: _getCurrentIndex(context),
              onDestinationSelected: (index) =>
                  _onDestinationSelected(context, index),
            ),
            Expanded(
              child: Column(
                children: [
                  Platform.isMacOS
                      ? SizedBox(
                          height: 65,
                          child: MoveWindow(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 16,
                                top: 10,
                                bottom: 10,
                              ),
                              child: DashboardTitleBar(
                                onSearchSubmitted: (value) {
                                  if (value.isNotEmpty) {
                                    context.push('/search/$value');
                                  }
                                },
                                onHomeRequested: () {
                                  context.go('/');
                                },
                              ),
                            ),
                          ),
                        )
                      : WindowTitleBarBox(
                          child: Row(
                            children: [
                              Expanded(child: MoveWindow()),
                              const WindowButtons(),
                            ],
                          ),
                        ),
                  if (!Platform.isMacOS)
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 16,
                        // top: 10,
                        bottom: 10,
                      ),
                      child: DashboardTitleBar(
                        onSearchSubmitted: (value) {
                          if (value.isNotEmpty) {
                            context.push('/search/$value');
                          }
                        },
                        onHomeRequested: () {
                          context.go('/');
                        },
                      ),
                    ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final buttonColors = WindowButtonColors(
  iconNormal: const Color(0xFF805306),
  mouseOver: const Color(0xFFF6A00C),
  mouseDown: const Color(0xFF805306),
  iconMouseOver: const Color(0xFF805306),
  iconMouseDown: const Color(0xFFFFD500),
);

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: const Color(0xFF805306),
  iconMouseOver: Colors.white,
);

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(colors: buttonColors),
        appWindow.isMaximized
            ? RestoreWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              )
            : MaximizeWindowButton(
                colors: buttonColors,
                onPressed: maximizeOrRestore,
              ),
        CloseWindowButton(colors: closeButtonColors),
      ],
    );
  }
}
