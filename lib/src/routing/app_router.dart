import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Placeholder for screens
import '../features/video/presentation/video_list_screen.dart';
import '../features/video/presentation/video_detail_screen.dart';
import '../features/video/presentation/video_player_screen.dart';
import '../features/video/presentation/search_screen.dart'; // Search Screen
import '../features/dashboard/dashboard_screen.dart';
import '../features/download/presentation/download_list_screen.dart';
import '../features/video/presentation/recent_list_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

CustomTransitionPage myTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.linear)),
        ),
        child: child,
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                pageBuilder: (context, state) =>
                    myTransitionPage(VideoListScreen()),
                routes: [
                  GoRoute(
                    path: 'detail/:id',
                    pageBuilder: (context, state) {
                      final id = state.pathParameters['id']!;
                      final sourceId = state.uri.queryParameters['sourceId'];
                      return myTransitionPage(
                        VideoDetailScreen(videoId: id, sourceId: sourceId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: Downloads
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/downloads',
                pageBuilder: (context, state) =>
                    myTransitionPage(DownloadListScreen()),
              ),
              GoRoute(
                path: '/search/:keyword',
                pageBuilder: (context, state) {
                  final keyword = state.pathParameters['keyword']!;
                  return myTransitionPage(SearchScreen(keyword: keyword));
                },
              ),
            ],
          ),
          // Branch 2: Recent
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/recent',
                pageBuilder: (context, state) =>
                    myTransitionPage(RecentListScreen()),
              ),
            ],
          ),
          // Branch 3: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) =>
                    myTransitionPage(SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/player/:id', // Fullscreen player outside shell
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          final sourceId = state.uri.queryParameters['sourceId'];
          final index =
              int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
          return myTransitionPage(
            VideoPlayerScreen(
              videoId: id,
              sourceId: sourceId,
              initialEpisodeIndex: index,
            ),
          );
        },
      ),
    ],
  );
});
