import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:workout_app/components/exerciseList/exercise_list_item.dart';
import 'package:workout_app/database/enums/enums.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/providers/database_provider.dart';

class RefactoredExerciseList extends StatelessWidget {
  final ExerciseListType type;

  const RefactoredExerciseList._({required this.type});
  const RefactoredExerciseList.compact() : this._(type: ExerciseListType.compact);
  const RefactoredExerciseList.large() : this._(type: ExerciseListType.large);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<DatabaseProvider>().getExercises(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final exercises = snapshot.data!;

            return SearchableList<Exercise>(
              initialList: exercises,
              builder: (List<Exercise> exercises, int index, Exercise exercise) {
                return ExerciseListItem(exercise: exercise, type: type);
              },
              filter: (value) => exercises.where((exercise) => exercise.name.toLowerCase().contains(value)).toList(),
              inputDecoration: const InputDecoration(
                labelText: "Search Exercise",
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(10),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
