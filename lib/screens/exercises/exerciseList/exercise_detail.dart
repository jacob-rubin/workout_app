import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/providers/cloud_storage_provider.dart';
import 'package:workout_app/screens/exercises/exerciseList/exercise_detail_item.dart';

class ExerciseDetail extends StatelessWidget {
  const ExerciseDetail({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final List<Widget> listItems = [
      ExerciseDetailItemSingle(title: 'Body Part', description: exercise.bodyPart),
      ExerciseDetailItemSingle(title: 'Target Muscle', description: exercise.target),
      ExerciseDetailItemMulti(title: 'Secondary Muscles', description: exercise.secondaryMuscles),
      ExerciseDetailItemSingle(title: 'Equipment', description: exercise.equipment),
      ExerciseDetailItemNumbered(title: 'Instructions', description: exercise.instructions),
      FutureBuilder<Image>(
        future: context.read<CloudStorageProvider>().getImage(exercise.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!;
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
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
