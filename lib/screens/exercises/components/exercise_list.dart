import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/screens/exercises/components/exercise_list_item.dart';
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

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Search',
                ),
              ),
            ),
            const TargetMuscleList(),
            Expanded(
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ExerciseListItem(
                    exercise: snapshot.data![index],
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
