import 'package:flutter/material.dart';
import 'package:workout_app/components/exerciseList/exercise_list.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: RefactoredExerciseList.large(),
      ),
    );
  }
}
