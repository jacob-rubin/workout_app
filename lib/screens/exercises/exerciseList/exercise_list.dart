import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/providers/firestore_provider.dart';
import 'package:workout_app/screens/exercises/exerciseList/exercise_list_item.dart';

class ExerciseList extends StatelessWidget {
  const ExerciseList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<FirestoreProvider>().getExerciseStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final snap = snapshot.data!.docs;

          return ListView.builder(
            itemCount: snap.length,
            itemBuilder: (context, index) {
              return ExerciseListItem(
                exercise: Exercise.fromJson(snap[index].data()),
              );
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
