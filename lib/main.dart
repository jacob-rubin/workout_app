import 'package:flutter/material.dart';
import 'package:workout_app/screens/workouts/workouts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.light()),
      home: const Workouts(),
    );
  }
}
