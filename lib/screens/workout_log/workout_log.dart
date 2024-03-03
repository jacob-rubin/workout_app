import 'package:flutter/material.dart';
import 'package:workout_app/screens/exercises/components/exercise_list.dart';

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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const ExerciseList();
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
