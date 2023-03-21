import 'package:flutter/material.dart';
import 'package:reddit_clone_app/features/auth/screens/login_screen.dart';
import 'package:reddit_clone_app/features/community/screens/community_screen.dart';
import 'package:reddit_clone_app/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone_app/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/mod_home_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create_community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/:name': (route) => MaterialPage(
        child: CommunityScreen(name: route.pathParameters['name']!),
      ),
      '/mod-tools': (_) =>
      const MaterialPage(child: ModToolsScreen()),
});
