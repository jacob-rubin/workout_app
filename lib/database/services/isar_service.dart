import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/exercise_service.dart';
import 'package:workout_app/database/services/lift_service.dart';
import 'package:workout_app/database/services/workout_service.dart';

class IsarService {
  late final Directory _dir;
  late final Isar _isar;
  late final WorkoutService _workoutService;
  late final ExerciseService _exerciseService;
  late final LiftService _liftService;

  IsarService() {
    init();
  }

  // Only used for testing. In the future, this should be replaced with a mock Isar instance
  IsarService.withIsar(this._isar) {
    _workoutService = WorkoutService(_isar);
    _exerciseService = ExerciseService(_isar);
    _liftService = LiftService(_isar);
  }

  Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();
    _workoutService = WorkoutService(_isar);
    _exerciseService = ExerciseService(_isar);
    _liftService = LiftService(_isar);

    if (Isar.instanceNames.isEmpty) {
      _isar = await Isar.open(
        [ExerciseSchema, WorkoutSchema, LiftSchema],
        directory: _dir.path,
      );
    } else {
      _isar = Isar.getInstance()!;
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
