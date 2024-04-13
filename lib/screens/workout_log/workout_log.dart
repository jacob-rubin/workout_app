import 'package:flutter/material.dart';
import 'package:workout_app/screens/workout_log/components/add_workout_button.dart';

class WorkoutLog extends StatelessWidget {
  const WorkoutLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2/14/2023'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [],
      ),
      floatingActionButton: const AddWorkoutButton(),
    );
  }
}
