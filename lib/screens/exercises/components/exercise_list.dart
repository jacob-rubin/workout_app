import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/screens/exercises/components/exercise_list_item.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: Provider.of<IsarService>(context).exerciseService.findExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ExerciseListItem(
                exercise: snapshot.data![index],
              );
            },
            prototypeItem: const ListTile(
              title: Text('Exercise Name'),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
