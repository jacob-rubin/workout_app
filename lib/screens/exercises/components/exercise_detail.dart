import 'package:flutter/material.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/screens/exercises/components/exercise_detail_list_item.dart';

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listItems = [
      ExerciseDetailListItemSingle(title: 'Body Part', description: exercise.bodyPart),
      ExerciseDetailListItemSingle(title: 'Target Muscle', description: exercise.targetMuscle),
      ExerciseDetailListItemMulti(title: 'Secondary Muscles', description: exercise.secondaryMuscles),
      ExerciseDetailListItemSingle(title: 'Equipment', description: exercise.equipment),
      ExerciseDetailListItemNumbered(title: 'Instructions', description: exercise.instructions),
      Image.asset("lib/database/data/360/${exercise.gifId}.gif"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(exercise.name),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
        ),
        itemCount: listItems.length,
        itemBuilder: (context, index) => listItems[index],
      ),
    );
  }
}
