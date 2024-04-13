import 'package:flutter/material.dart';
import 'package:workout_app/screens/exercises/exerciseList/exercise_list.dart';

class AddWorkoutButton extends StatelessWidget {
  const AddWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const Padding(
              padding: EdgeInsets.only(top: 10),
              child: RefactoredExerciseList.compact(),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
