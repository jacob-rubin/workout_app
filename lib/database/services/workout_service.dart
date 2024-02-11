import 'package:isar/isar.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/abstractions.dart';

class WorkoutService implements WorkoutServices {
  late final Isar _db;

  WorkoutService(this._db);

  /// @param workout The workout to add.
  /// @return The id of the workout added.
  @override
  Future<void> createWorkout(Workout workout) async {
    await _db.writeTxn(() async {
      await _db.workouts.put(workout);
    });
  }

  /// @param workout - The workout to update.
  @override
  Future<void> updateWorkout(Workout workout) async {
    await _db.writeTxn(() async {
      await _db.workouts.put(workout);
    });
  }

  /// @param workout - The workout to delete.
  @override
  Future<void> deleteWorkout(Workout workout) async {
    await _db.writeTxn(() async {
      await _db.workouts.delete(workout.id);
    });
  }

  /// @param id - The id of the workout to get.
  /// @return The workout with the given id.
  @override
  Future<Workout?> getWorkout(int id) async {
    return await _db.workouts.get(id);
  }

  /// @return A list of all workouts.
  @override
  Future<List<Workout>> getWorkouts() async {
    return await _db.workouts.where().findAll();
  }
}
