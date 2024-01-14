import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/isar_service.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late IsarService _isarService;
  late Isar _isar;

  Future<List<Exercise>> getExercises() async {
    _isar = await Isar.open(
      [ExerciseSchema],
      directory: (await getApplicationDocumentsDirectory()).path,
      name: 'exerciseInstance',
    );
    _isarService = IsarService.withIsar(_isar);

    final List<Exercise> exercises = await _isar.exercises.where().findAll();

    if (exercises.isEmpty) {
      await loadExercises(_isar, _isarService);
    }

    return exercises;
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<Exercise>> exercises = getExercises();

    return FutureBuilder<List<Exercise>>(
      future: exercises,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name),
                subtitle: Text(snapshot.data![index].bodyPart),
              );
            },
            prototypeItem: const ListTile(
              title: Text('Exercise Name'),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
