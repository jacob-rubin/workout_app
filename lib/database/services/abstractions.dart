import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';

abstract class ExerciseServices {
  Future<void> createExercise(Exercise exercise);
  Future<void> deleteExercise(Exercise exercise);
  Future<void> updateExercise(Exercise exercise);
  Future<Exercise?> getExercise(int id);
  Future<List<Exercise>> getExercises();
}

abstract class LiftServices {
  Future<void> createLift(Lift lift);
  Future<void> deleteLift(Lift lift);
  Future<void> updateLift(Lift lift);
  Future<Lift?> getLift(int id);
  Future<List<Lift>> getLifts();
}

abstract class WorkoutServices {
  Future<void> createWorkout(Workout workout);
  Future<void> updateWorkout(Workout workout);
  Future<void> deleteWorkout(Workout workout);
  Future<void> addLiftToWorkout(Workout workout, Lift lift);
  Future<void> removeLiftFromWorkout(Workout workout, Lift lift);
  Future<Workout?> getWorkout(int id);
  Future<List<Workout>> getWorkouts();
}
