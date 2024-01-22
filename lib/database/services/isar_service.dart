import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/exercise_service.dart';
import 'package:workout_app/database/services/lift_service.dart';
import 'package:workout_app/database/services/workout_service.dart';

class IsarService {
  late Isar _isar;
  late WorkoutService _workoutService;
  late ExerciseService _exerciseService;
  late LiftService _liftService;

  IsarService();

  // Only used for testing. In the future, this should be replaced with a mock Isar instance
  IsarService.withIsar(this._isar) {
    _workoutService = WorkoutService(_isar);
    _exerciseService = ExerciseService(_isar);
    _liftService = LiftService(_isar);
  }

  Future<void> init() async {
    // TODO: Very hacky solution. Debug and fix
    if (Isar.getInstance() == null) {
      Directory dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [ExerciseSchema, WorkoutSchema, LiftSchema],
        directory: dir.path,
      );

      _workoutService = WorkoutService(_isar);
      _exerciseService = ExerciseService(_isar);
      _liftService = LiftService(_isar);

      if (await _isar.exercises.count() == 0) {
        await loadExercises(this);
      }
    } else {
      _isar = Isar.getInstance()!;
      _workoutService = WorkoutService(_isar);
      _exerciseService = ExerciseService(_isar);
      _liftService = LiftService(_isar);
    }
  }

  Future<void> close() async {
    await _isar.close();
  }

  /// Getters
  WorkoutService get workoutService => _workoutService;
  ExerciseService get exerciseService => _exerciseService;
  LiftService get liftService => _liftService;
}
