import 'package:flutter/material.dart';
import 'package:reddit_clone_app/features/auth/screens/login_screen.dart';
import 'package:reddit_clone_app/features/community/screens/add_mods_screena.dart';
import 'package:reddit_clone_app/features/community/screens/community_screen.dart';
import 'package:reddit_clone_app/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone_app/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone_app/features/home/screens/home_screen.dart';
import 'package:reddit_clone_app/features/post/screens/add_post_type.dart';
import 'package:reddit_clone_app/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone_app/features/user_profile/screens/user_profiles_screen.dart';
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
  '/mod-tools/:name': (routeData) => MaterialPage(
      child: ModToolsScreen(name: routeData.pathParameters['name']!)),
  '/edit-community/:name': (routeData) => MaterialPage(
      child: EditCommunityScreen(name: routeData.pathParameters['name']!)),
  '/add-mods/:name': (routeData) => MaterialPage(
      child: AddModsScreen(name: routeData.pathParameters['name']!)),
  //user profile
  '/u/:uid': (routeData) => MaterialPage(
      child: UserprofilScreen(uid: routeData.pathParameters['uid']!)),
  '/edit-profil/:uid': (routeData) => MaterialPage(
      child: EditProfilScreen(uid: routeData.pathParameters['uid']!)),
        '/add-post/:type': (routeData) => MaterialPage(
      child: AddPostTypeScreen(type: routeData.pathParameters['type']!)),
});
