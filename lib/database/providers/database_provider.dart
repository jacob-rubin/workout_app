import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/abstractions.dart';
import 'package:workout_app/database/services/exercise_service.dart';
import 'package:workout_app/database/services/lift_service.dart';
import 'package:workout_app/database/services/workout_service.dart';

class DatabaseProvider extends ChangeNotifier implements ExerciseServices, LiftServices, WorkoutServices {
  late final Isar _db;
  late final ExerciseService _exerciseService;
  late final LiftService _liftService;
  late final WorkoutService _workoutService;

  DatabaseProvider();
  DatabaseProvider.withMocks(this._db, this._exerciseService, this._liftService, this._workoutService);

  Future<void> init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    _db = Isar.getInstance() ??
        await Isar.open(
          [ExerciseSchema, WorkoutSchema],
          directory: dir.path,
        );
    _exerciseService = ExerciseService(_db);
    _workoutService = WorkoutService(_db);
    _liftService = LiftService(_db);

    if (await _db.getSize() == 0) {
      await loadExercises(_exerciseService);
    }
  }

  Future<void> close() async {
    await _db.close();
  }

  @override
  Future<void> createExercise(Exercise exercise) async {
    await _exerciseService.createExercise(exercise);
    notifyListeners();
  }

  @override
  Future<void> updateExercise(Exercise exercise) async {
    await _exerciseService.updateExercise(exercise);
    notifyListeners();
  }

  @override
  Future<void> deleteExercise(Exercise exercise) async {
    await _exerciseService.deleteExercise(exercise);
    notifyListeners();
  }

  @override
  Future<Exercise?> getExercise(int id) async {
    return await _exerciseService.getExercise(id);
  }

  @override
  Future<List<Exercise>> getExercises() async {
    return await _exerciseService.getExercises();
  }

  @override
  Future<void> createWorkout(Workout workout) async {
    await _workoutService.createWorkout(workout);
    notifyListeners();
  }

  @override
  Future<void> updateWorkout(Workout workout) async {
    await _workoutService.updateWorkout(workout);
    notifyListeners();
  }

  @override
  Future<void> deleteWorkout(Workout workout) async {
    await _workoutService.deleteWorkout(workout);
    notifyListeners();
  }

  @override
  Future<Workout?> getWorkout(int id) async {
    return await _workoutService.getWorkout(id);
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    return await _workoutService.getWorkouts();
  }

  @override
  Future<void> createLift(Lift lift) async {
    return await _liftService.createLift(lift);
  }

  @override
  Future<void> deleteLift(Lift lift) async {
    return await _liftService.deleteLift(lift);
  }

  @override
  Future<Lift?> getLift(int id) async {
    return await _liftService.getLift(id);
  }

  @override
  Future<List<Lift>> getLifts() async {
    return await _liftService.getLifts();
  }

  @override
  Future<void> updateLift(Lift lift) async {
    return await _liftService.updateLift(lift);
  }
}
