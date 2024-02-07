import 'package:flutter/material.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/screens/exercises/components/exercise_list_item.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: Future<List<Exercise>>.value([]),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

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
      },
    );
  }
}
