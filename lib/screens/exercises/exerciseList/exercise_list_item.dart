import 'package:flutter/material.dart';
import 'package:workout_app/database/enums/enums.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/screens/exercises/exerciseList/exercise_detail.dart';

class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({super.key, required this.exercise, required this.type});

  final Exercise exercise;
  final ExerciseListType type;

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
      subtitle: Text(exercise.bodyPart),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (type == ExerciseListType.large) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetail(exercise: exercise),
            ),
          );
        } else {
          print('Add exercise to workout');
        }
      },
    );
  }
}
