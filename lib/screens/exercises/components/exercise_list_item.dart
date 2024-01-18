import 'package:flutter/material.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/screens/exercises/exercise_detail.dart';

class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: Text(
          exercise.name,
          maxLines: 1,
        ),
      ),
      subtitle: Text(exercise.targetMuscle),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetail(exercise: exercise),
          ),
        );
      },
    );
  }
}
