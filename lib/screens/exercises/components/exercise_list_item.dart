import 'package:flutter/material.dart';
import 'package:workout_app/database/models/exercise.dart';

class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      subtitle: Text(exercise.bodyPart),
      onTap: () {
        print('Tapped ${exercise.name}');
      },
    );
  }
}
