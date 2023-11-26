import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/pr.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/exercise_service.dart';
import 'package:workout_app/database/services/lift_service.dart';
import 'package:workout_app/database/services/pr_services.dart';
import 'package:workout_app/database/services/workout_service.dart';

class DomainService {
  late final Directory _dir;
  late final Isar _isar;

  DomainService() {
    init();
  }

  Future<void> init() async {
    _dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [WorkoutSchema, ExerciseSchema, PRSchema, LiftSchema],
      directory: _dir.path,
    );
  }

  Map<String, Object> getServices() {
    return {
      'workout': WorkoutService(_isar),
      'exercise': ExerciseService(_isar),
      'pr': PRService(_isar),
      'lift': LiftService(_isar),
    };
  }
}
