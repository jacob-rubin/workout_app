import 'package:isar/isar.dart';
import 'package:workout_app/database/models/workout.dart';

class WorkoutService {
  late final Isar isar;

  WorkoutService(this.isar);

  /// Adds a new workout to the database.
  /// @param workout The workout to add.
  /// @return The id of the workout added.
  Future<int> addWorkout(Workout workout) async {
    return await isar.writeTxn(() async {
      return await isar.workouts.put(workout);
    });
  }

  /// Gets all workouts from the database.
  /// @return A list of all workouts.
  Future<List<Workout>> findWorkouts() async {
    return await isar.workouts.where().findAll();
  }

  /// Gets a workout from the database by id.
  /// @param id The id of the workout to get.
  Future<Workout?> findWorkoutById(int id) async {
    return await isar.workouts.get(id);
  }

  /// Updates a workout in the database.
  /// @param workout The workout to update.
  /// @throws Exception if the workout is not found.
  Future<void> updateWorkout(Workout workout) async {
    final queriedWorkout = await isar.workouts.get(workout.id);

    if (queriedWorkout == null) {
      throw Exception('Workout not found');
    }

    await isar.writeTxn(() async {
      await isar.workouts.put(workout);
    });
  }

  /// Deletes a workout from the database.
  /// @param id The id of the workout to delete.
  /// @throws Exception if the workout is not found.
  Future<void> deleteWorkout(int id) async {
    final deletedWorkout = await isar.workouts.get(id);

    if (deletedWorkout == null) {
      throw Exception('Workout not found');
    }

    await isar.writeTxn(() async {
      await isar.workouts.delete(id);
    });
  }
}
