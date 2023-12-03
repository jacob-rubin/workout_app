import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/exercise_service.dart';
import 'package:workout_app/database/services/lift_service.dart';
import 'package:workout_app/database/services/workout_service.dart';

class DomainService {
  late final Directory _dir;
  late final Isar _isar;
  late final WorkoutService _workoutService;
  late final ExerciseService _exerciseService;
  late final LiftService _liftService;

  DomainService() {
    init();
  }

  // Only used for testing. In the future, this should be replaced with a mock Isar instance
  DomainService.withIsar(this._isar) {
    _workoutService = WorkoutService(_isar);
    _exerciseService = ExerciseService(_isar);
    _liftService = LiftService(_isar);
  }

  Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [WorkoutSchema, ExerciseSchema, LiftSchema],
      directory: _dir.path,
    );
    _workoutService = WorkoutService(_isar);
    _exerciseService = ExerciseService(_isar);
    _liftService = LiftService(_isar);
  }

  Future<void> close() async {
    await _isar.close();
  }

  /// Getters
  WorkoutService get workoutService => _workoutService;
  ExerciseService get exerciseService => _exerciseService;
  LiftService get liftService => _liftService;
}
