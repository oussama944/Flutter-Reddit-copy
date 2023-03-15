import 'package:flutter/material.dart';
import 'package:reddit_clone_app/features/auth/screens/login_screen.dart';
import 'package:reddit_clone_app/features/home/screens/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: LoginScreen(),
        ),
  }
);


final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(
          child: HomeScreen(),
        ),
  }
);