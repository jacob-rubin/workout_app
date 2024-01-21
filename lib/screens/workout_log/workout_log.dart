import 'package:flutter/material.dart';
import 'package:workout_app/screens/workout_log/components/workout_start_button.dart';

class WorkoutLog extends StatelessWidget {
  const WorkoutLog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          WorkoutStartButton(),
        ],
      ),
    );
  }
}
