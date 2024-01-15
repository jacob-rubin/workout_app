import 'package:flutter/material.dart';
import 'package:workout_app/database/models/exercise.dart';

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(exercise.name),
        ),
      ),
      body: ListView(
        children: [
          Text(exercise.bodyPart),
          ...exercise.secondaryMuscles.map(
            (muscle) => Text(muscle),
          ),
          Text(exercise.equipment),
          ...exercise.instructions.asMap().entries.map(
                (entry) => Text('${entry.key + 1}. ${entry.value}'),
              ),
          Image.asset(
            "lib/database/data/360/${exercise.gifId}.gif",
          )
        ],
      ),
    );
  }
}
