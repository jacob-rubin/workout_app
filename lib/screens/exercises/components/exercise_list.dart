import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/providers/search_provider.dart';
import 'package:workout_app/screens/exercises/components/exercise_list_item.dart';
import 'package:workout_app/screens/exercises/components/exercise_search_bar.dart';
import 'package:workout_app/screens/exercises/components/target_muscle_list.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: context.read<IsarService>().exerciseService.findExercises(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Exercise> filterExercises() {
          final searchText = context.watch<SearchProvider>().searchText;
          return snapshot.data!.where((element) => element.name.toLowerCase().contains(searchText.toLowerCase())).toList();
        }

        return Column(
          children: [
            const ExerciseSearchBar(),
            const TargetMuscleList(),
            Expanded(
              child: ListView.builder(
                itemCount: filterExercises().length,
                itemBuilder: (context, index) {
                  return ExerciseListItem(
                    exercise: filterExercises()[index],
                  );
                },
                prototypeItem: const ListTile(
                  title: Text('Exercise Name'),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
