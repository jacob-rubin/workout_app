import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/enums/enums.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/providers/database_provider.dart';
import 'package:workout_app/database/providers/exercise_search_provider.dart';
import 'package:workout_app/screens/exercises/exerciseList/exercise_list_item.dart';

class RefactoredExerciseList extends StatelessWidget {
  final ExerciseListType type;

  const RefactoredExerciseList._({required this.type});
  const RefactoredExerciseList.compact() : this._(type: ExerciseListType.compact);
  const RefactoredExerciseList.large() : this._(type: ExerciseListType.large);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // BodyPartDropdown(),
            // TargetMuscleDropdown(),
            // EquipmentDropdown(),
          ],
        ),
        TextField(
          onChanged: (value) => context.read<ExerciseSearchProvider>().setSearch(value),
        ),
        FutureBuilder<List<Exercise>>(
            future: context.read<DatabaseProvider>().getExercises(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final exercises = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      return ExerciseListItem(
                        exercise: exercises[index],
                        type: type,
                      );
                    },
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ],
    );
  }
}
