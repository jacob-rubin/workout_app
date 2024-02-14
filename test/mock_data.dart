import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';

Exercise mockExercise = Exercise()
  ..id = 1
  ..name = 'Sit Up'
  ..bodyPart = 'Abs'
  ..equipment = 'body'
  ..targetMuscle = 'Abs'
  ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
  ..instructions = ['Lie on bench', 'Lower bar to chest' 'Press bar back up']
  ..gifId = '003';

List<Exercise> mockExercises = [
  Exercise()
    ..id = 2
    ..name = 'Bench Press'
    ..bodyPart = 'Chest'
    ..equipment = 'Barbell'
    ..targetMuscle = 'Pectoralis Major'
    ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
    ..instructions = ['Lie on bench', 'Lower bar to chest' 'Press bar back up']
    ..gifId = '001',
  Exercise()
    ..id = 3
    ..name = 'Squat'
    ..bodyPart = 'Legs'
    ..equipment = 'Barbell'
    ..targetMuscle = 'Quadriceps'
    ..secondaryMuscles = ['Glutes', 'Hamstrings']
    ..instructions = ['Place bar on back', 'Squat down', 'Stand back up']
    ..gifId = '002'
];

List<Lift> mockLifts = [
  Lift()
    ..id = 2
    ..exercise.value = mockExercises[0]
    ..sets = [
      Set(reps: 10, weight: 100),
      Set(reps: 12, weight: 90),
    ],
  Lift()
    ..id = 3
    ..exercise.value = mockExercises[1]
    ..sets = [
      Set(reps: 5, weight: 50),
      Set(reps: 6, weight: 60),
    ],
  Lift()
    ..id = 4
    ..exercise.value = mockExercises[0]
    ..sets = [
      Set(reps: 1, weight: 50),
      Set(reps: 2, weight: 60),
    ],
];

List<Workout> mockWorkout = [
  Workout()
    ..rating = 5
    ..date = DateTime.now()
    ..lifts.addAll(mockLifts),
];
