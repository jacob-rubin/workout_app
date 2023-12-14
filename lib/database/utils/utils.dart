import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';

String exerciseToString(Exercise? exercise) {
  return exercise != null ? exercise.name : 'null';
}

String liftToString(Lift lift) {
  return '${exerciseToString(lift.exercise.value)} - ${lift.sets.length} sets';
}

String workoutToString(Workout workout) {
  String res = '';
  for (final lift in workout.lifts) {
    res += '${liftToString(lift)}\n';
  }

  return res;
}
