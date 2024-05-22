import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/searchable_listview.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/providers/database_provider.dart';
import 'package:workout_app/screens/exercises/dropdown_values.dart';
import 'package:workout_app/screens/exercises/exerciseList/exercise_list_item.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: context.read<DatabaseProvider>().getExercises(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return SearchableListView<Exercise>(
            items: snapshot.data!,
            listTile: (exercise) => ExerciseListItem(exercise: exercise),
            dropdowns: {
              'Target Muscles': targetMuscles,
              'Equipment': equipment,
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
