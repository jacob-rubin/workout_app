# H1 Database Structure

- This provides the general guideline of the database and the services that interact with it.

## Structure

- **Models**
  - Exercise
  - Workout
- **Services**
  - ExerciseServices
  - WorkoutServices
- **Providers**
  - DatabaseProvider

## Abstract Classes

- The purpose is to define reused code between the services and the database

```dart
abstract class ExerciseServices {
  Future<void> createExercise(Exercise exercise);
  Future<void> deleteExercise(Exercise exercise);
  Future<void> updateExercise(Exercise exercise);
  Future<Exercise?> getExercise(int id);
  Future<List<Exercise>> getExercises();
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
```

## Services

```dart
  class ExerciseService implements ExerciseServices {
    late Isar _db;

    ExerciseService({required this._db});

    Future<void> addExercise(Exercise exercise);
    Future<void> deleteExercise(Exercise exercise);
    Future<void> updateExercise(Exercise exercise);
    Stream<Exercise> getExercises();
    Future<Exercise?> getExercise(String id);
  }

  class WorkoutService implements WorkoutServices {
    late Isar _db;

    WorkoutService({required this._db});

    Future<void> addWorkout(Workout workout);
    Future<void> deleteWorkout(Workout workout);
    Future<void> updateWorkout(Workout workout);
    Stream<Workout> getWorkouts();
    Future<Workout?> getWorkout(String id);
  }
```

## Database Provider

```dart
  class DatabaseProvider implements ExerciseServices, WorkoutServices {
    late Isar _db;
    late WorkoutService _workoutService;
    late ExerciseService _exerciseService;

    DatabaseProvider();

    DatabaseProvider.init() {
      _db = await openIsar();
      _workoutService = WorkoutService(_db);
      _exerciseService = ExerciseService(_db);

      // TODO: Load if isar exercises is empty, load from assets
    }

    Future<void> addExercise(Exercise exercise) {
      _exerciseService.addExercise(exercise);
      notifyListeners();
    }

    Future<void> deleteExercise(Exercise exercise) {
      _exerciseService.deleteExercise(exercise);
      notifyListeners();
    }

    // ... other methods

    Future<void> addWorkout(Workout workout) {
      _workoutService.addWorkout(workout);
      notifyListeners();
    }

    Future<void> deleteWorkout(Workout workout) {
      _workoutService.deleteWorkout(workout);
      notifyListeners();
    }

    // ... other methods
  }
```
