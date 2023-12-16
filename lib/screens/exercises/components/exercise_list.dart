import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/domain_services.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  late DomainService _domainService;
  late Isar _isar;

  @override
  Future<void> initState() async {
    _domainService = DomainService.withIsar(_isar);
    _isar = await Isar.open(
      [ExerciseSchema],
      directory: (await getApplicationDocumentsDirectory()).path,
      name: 'exerciseInstance',
    );
    final List<Exercise> exercises = await _isar.exercises.where().findAll();

    if (exercises.isEmpty) {
      await loadExercises(_isar, _domainService);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<Exercise>> exercises = _isar.exercises.where().findAll();

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
