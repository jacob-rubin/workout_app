library globals;

import 'package:go_router/go_router.dart';
import 'package:workout_app/screens/home.dart';
import 'package:workout_app/screens/workouts.dart';

enum Page {
  home(name: 'home', path: '/'),
  workouts(name: 'workouts', path: '/workouts');

  const Page({
    required this.name,
    required this.path,
  });

  final String name;
  final String path;
}

final GoRouter router = GoRouter(
  initialLocation: '/workouts',
  routes: [
    GoRoute(
      path: Page.home.path,
      name: Page.home.name,
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: Page.workouts.path,
      name: Page.workouts.name,
      builder: (context, state) => const Workouts(),
    ),
  ],
);
