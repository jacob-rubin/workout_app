import 'package:flutter/material.dart';
import 'package:workout_app/screens/workouts.dart';
import 'globals.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Workouts(),
    );
  }
}
