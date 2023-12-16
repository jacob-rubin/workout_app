import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';

class ExerciseService {
  late final Isar isar;

  ExerciseService(this.isar);

  /// @param exercise Exercise to be added
  /// @returns Id of the created Exercise
  Future<int> addExercise(Exercise exercise) async {
    return isar.writeTxn(() async {
      return await isar.exercises.put(exercise);
    });
  }

  /// @param json JSON of Exercise to be added
  /// @returns Id of the created Exercise
  Future<int> addExerciseFromJSON(Map<String, dynamic> json) async {
    Exercise exercise = Exercise()
      ..name = json['name']
      ..bodyPart = json['bodyPart']
      ..equipment = json['equipment']
      ..targetMuscle = json['target']
      ..secondaryMuscles = json['secondaryMuscles'].cast<String>()
      ..instructions = json['instructions'].cast<String>()
      ..gifId = json['id'];

    return await isar.writeTxn(() async {
      return await isar.exercises.put(exercise);
    });
  }

  /// @returns List of Exercises
  Future<List<Exercise>> findExercises() async {
    return isar.exercises.where().findAll();
  }

  /// @param id Id of Exercise to be found
  /// @returns Exercise with the given id
  Future<Exercise?> findExerciseById(int id) async {
    return isar.exercises.get(id);
  }

  /// @param exercise Exercise to be updated
  /// @throws Exception if the Exercise is not found
  Future<void> updateExercise(Exercise exercise) async {
    final Exercise? queriedExercise = await isar.exercises.get(exercise.id);

    if (queriedExercise == null) {
      throw Exception('Lift not found');
    }

    await isar.writeTxn(() async {
      await isar.exercises.put(exercise);
    });
  }

  /// @param id Id of Exercise to be deleted
  /// @throws Exception if the Exercise is not found
  Future<void> deleteExercise(int id) async {
    final Exercise? deletedExercise = await isar.exercises.get(id);

    if (deletedExercise == null) {
      throw Exception('Exercise not found');
    }

    return isar.writeTxn(() async {
      await isar.exercises.delete(id);
    });
  }
}
