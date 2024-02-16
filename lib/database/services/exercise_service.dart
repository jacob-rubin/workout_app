import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/abstractions.dart';

class ExerciseService implements ExerciseServices {
  late final Isar _db;

  ExerciseService(this._db);

  /// @param exercise - Exercise to be added
  @override
  Future<void> createExercise(Exercise exercise) async {
    await _db.writeTxn(() async {
      await _db.exercises.put(exercise);
    });
  }

  /// @param exercise - Exercise to be updated
  /// @throws Exception if Exercise not found
  @override
  Future<void> updateExercise(Exercise exercise) async {
    Exercise? exerciseToUpdate = await getExercise(exercise.id);

    if (exerciseToUpdate == null) {
      throw Exception('Exercise not found');
    }

    await _db.writeTxn(() async {
      await _db.exercises.put(exercise);
    });
  }

  /// @param exercise - Exercise to be deleted
  @override
  Future<void> deleteExercise(Exercise exercise) async {
    await _db.writeTxn(() async {
      await _db.exercises.delete(exercise.id);
    });
  }

  /// @param id - Id of Exercise to be found
  /// @returns Exercise with the given id
  @override
  Future<Exercise?> getExercise(int id) async {
    return await _db.exercises.get(id);
  }

  /// @returns List of Exercises
  @override
  Future<List<Exercise>> getExercises() async {
    return await _db.exercises.where().findAll();
  }
}
