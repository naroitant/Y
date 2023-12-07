import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:y/features/auth/auth_page.dart';
import 'package:y/features/home/home_page.dart';
import 'package:y/features/navigation/main_screen.dart';
import 'app_routes.dart';

class AppRouterConfiguration {
  static GoRouter createRouter(BuildContext appContext) {
    return GoRouter(
      initialLocation: AppRoutes.auth.path,
      routes: [
        ShellRoute(
          builder: (context, state, pageWidget) =>
            MainScreen(child: pageWidget),
          routes: [
            GoRoute(
              name: AppRoutes.home.name,
              path: AppRoutes.home.path,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              name: AppRoutes.auth.name,
              path: AppRoutes.auth.path,
              builder: (context, state) => const AuthPage(),
            ),
            GoRoute(
              name: AppRoutes.search.name,
              path: AppRoutes.search.path,
              builder: (context, state) => const Center(child: Text('search')),
            ),
            GoRoute(
              name: AppRoutes.video.name,
              path: AppRoutes.video.path,
              builder: (context, state) => const Center(child: Text('video')),
            ),
            GoRoute(
              name: AppRoutes.profile.name,
              path: AppRoutes.profile.path,
              builder: (context, state) => const Center(child: Text('profile'))
            ),
            GoRoute(
              name: AppRoutes.settings.name,
              path: AppRoutes.settings.path,
              builder: (context, state) => const Center(child: Text('settings')),
            ),
          ],
        ),
      ],
    );
  }
}
