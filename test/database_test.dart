import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:logger/logger.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/providers/database_provider.dart';
import 'package:workout_app/database/services/exercise_service.dart';
import 'package:workout_app/database/services/lift_service.dart';
import 'package:workout_app/database/services/workout_service.dart';

void main() {
  late Isar mockIsar;
  late Directory mockDir;
  late DatabaseProvider db;
  late ExerciseService exerciseService;
  late LiftService liftService;
  late WorkoutService workoutService;

  setUp(() async {
    mockDir = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      mockIsar = await Isar.open([ExerciseSchema, LiftSchema, WorkoutSchema], directory: mockDir.path);
    }

    exerciseService = ExerciseService(mockIsar);
    workoutService = WorkoutService(mockIsar);
    liftService = LiftService(mockIsar);

    db = DatabaseProvider.withMocks(
      mockIsar,
      exerciseService,
      liftService,
      workoutService,
    );

    await mockIsar.writeTxn(() async {
      await mockIsar.exercises.clear();
      await mockIsar.lifts.clear();
      await mockIsar.workouts.clear();
    });
  });

  tearDown(() async {
    await mockIsar.close(deleteFromDisk: true);
  });

  Future<void> printIsarInstances([String? label]) async {
    Logger logger = Logger();

    if (label != null) {
      logger.i(label);
    }

    logger.t('Exercises: ${await mockIsar.exercises.where().findAll()}');
    logger.t('Lifts: ${await mockIsar.lifts.where().findAll()}');
    logger.t('Workouts: ${await mockIsar.workouts.where().findAll()}');
  }

  test('open an instance on the Isar database', () {
    final isOpen = mockIsar.isOpen;
    expect(isOpen, isTrue);
  });

  group('Exercise Service', () {
    List<Exercise> testExercises = [
      Exercise()
        ..name = 'Bench Press'
        ..bodyPart = 'Chest'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Pectoralis Major'
        ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
        ..instructions = ['Lie on bench', 'Lower bar to chest' 'Press bar back up']
        ..gifId = '001',
      Exercise()
        ..name = 'Squat'
        ..bodyPart = 'Legs'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Quadriceps'
        ..secondaryMuscles = ['Glutes', 'Hamstrings']
        ..instructions = ['Place bar on back', 'Squat down', 'Stand back up']
        ..gifId = '002'
    ];

    setUp(() async {
      // Clear database
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
      });
    });

    test('Creates an exercise', () async {
      await db.createExercise(testExercises[0]);
      final Exercise? queriedExercise = await mockIsar.exercises.get(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, equals(testExercises[0].name));
      expect(queriedExercise.bodyPart, equals(testExercises[0].bodyPart));
      expect(queriedExercise.equipment, equals(testExercises[0].equipment));
      expect(queriedExercise.targetMuscle, equals(testExercises[0].targetMuscle));
      expect(queriedExercise.secondaryMuscles, equals(testExercises[0].secondaryMuscles));
      expect(queriedExercise.instructions, equals(testExercises[0].instructions));
      expect(queriedExercise.gifId, equals(testExercises[0].gifId));
    });

    test('Finds all exercises', () async {
      await db.createExercise(testExercises[0]);
      await db.createExercise(testExercises[1]);

      final List<Exercise> queriedExercises = await db.getExercises();

      expect(queriedExercises, hasLength(2));
      expect(queriedExercises[0].name, testExercises[0].name);
      expect(queriedExercises[1].name, testExercises[1].name);
    });

    test('Finds an exercise by ID', () async {
      await db.createExercise(testExercises[0]);
      final Exercise? queriedExercise = await db.getExercise(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, testExercises[0].name);
    });

    test('Returns null if exercise is not found', () async {
      await db.createExercise(testExercises[0]);
      final Exercise? queriedExercise = await db.getExercise(4);

      expect(queriedExercise, isNull);
    });

    test('Updates an exercise', () async {
      String newName = 'New Bench Press';
      await db.createExercise(testExercises[0]);
      await db.updateExercise(testExercises[0]..name = newName);

      final Exercise? queriedExercise = await mockIsar.exercises.get(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, newName);
    });

    test('Deletes an exercise', () async {
      await db.createExercise(testExercises[0]);
      expect(await db.getExercises(), hasLength(1));

      await db.deleteExercise(testExercises[0]);
      expect(await db.getExercises(), isEmpty);
    });
  });

  group('Lift Service', () {
    List<Exercise> testExercises = [
      Exercise()
        ..name = 'Bench Press'
        ..bodyPart = 'Chest'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Pectoralis Major'
        ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
        ..instructions = ['Lie on bench', 'Lower bar to chest' 'Press bar back up']
        ..gifId = '001',
      Exercise()
        ..name = 'Squat'
        ..bodyPart = 'Legs'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Quadriceps'
        ..secondaryMuscles = ['Glutes', 'Hamstrings']
        ..instructions = ['Place bar on back', 'Squat down', 'Stand back up']
        ..gifId = '002'
    ];

    setUp(() async {
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
        await mockIsar.lifts.clear();

        await mockIsar.exercises.putAll(testExercises);
      });
    });

    test('Creates a lift', () async {
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(await mockIsar.lifts.where().findAll(), hasLength(1));
      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, testExercises[0].name);
      expect(queriedLift.sets, hasLength(2));
      expect(queriedLift.sets[0].reps, 10);
      expect(queriedLift.sets[0].weight, 100);
    });

    test('Gets a single lift', () async {
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      final Lift? queriedLift = await db.getLift(1);

      expect(queriedLift!, isNotNull);
      expect(queriedLift.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, testExercises[0].name);
      expect(queriedLift.sets, hasLength(2));
      expect(queriedLift.sets[0].reps, 10);
      expect(queriedLift.sets[0].weight, 100);
      expect(queriedLift.sets[1].reps, 12);
      expect(queriedLift.sets[1].weight, 90);
    });

    test('Gets all lifts', () async {
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[1]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );

      final List<Lift> queriedLifts = await db.getLifts();

      expect(queriedLifts, hasLength(3));

      for (int i = 0; i < queriedLifts.length; i++) {
        expect(queriedLifts[i], isNotNull);
        expect(queriedLifts[i].exercise.value, isNotNull);
        expect(queriedLifts[i].exercise.value!.name, isNotNull);
      }
    });

    test('Updates a lift with a new set', () async {
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      await db.updateLift((await db.getLift(1))!..sets = [Set(reps: 12, weight: 80)]);

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(queriedLift, isNotNull);
      expect(queriedLift!.sets, hasLength(1));
      expect(queriedLift.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, testExercises[0].name);
    });

    test('Updates a lift with a new exercise', () async {
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      await db.updateLift((await db.getLift(1))!..exercise.value = testExercises[1]);

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, testExercises[1].name);
      expect(queriedLift.sets, hasLength(2));
    });

    test('Deletes a lift without deleting the exercises', () async {
      await db.createLift(
        Lift()
          ..exercise.value = testExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      expect(await mockIsar.lifts.where().findAll(), hasLength(1));
      expect(await mockIsar.exercises.where().findAll(), hasLength(2));

      await db.deleteLift((await db.getLift(1))!);
      expect(await mockIsar.lifts.where().findAll(), isEmpty);
      expect(await mockIsar.exercises.where().findAll(), hasLength(2));
    });
  });

  group('Workout Service', () {
    List<Exercise> testExercises = [
      Exercise()
        ..name = 'Bench Press'
        ..bodyPart = 'Chest'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Pectoralis Major'
        ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
        ..instructions = ['Lie on bench', 'Lower bar to chest' 'Press bar back up']
        ..gifId = '001',
      Exercise()
        ..name = 'Squat'
        ..bodyPart = 'Legs'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Quadriceps'
        ..secondaryMuscles = ['Glutes', 'Hamstrings']
        ..instructions = ['Place bar on back', 'Squat down', 'Stand back up']
        ..gifId = '002'
    ];

    List<Lift> testLifts = [
      Lift()
        ..exercise.value = testExercises[0]
        ..sets = [
          Set(reps: 10, weight: 100),
          Set(reps: 12, weight: 90),
        ],
      Lift()
        ..exercise.value = testExercises[1]
        ..sets = [
          Set(reps: 5, weight: 50),
          Set(reps: 6, weight: 60),
        ],
      Lift()
        ..exercise.value = testExercises[0]
        ..sets = [
          Set(reps: 1, weight: 50),
          Set(reps: 2, weight: 60),
        ],
    ];

    setUp(() async {
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
        await mockIsar.lifts.clear();
        await mockIsar.workouts.clear();
        await mockIsar.exercises.putAll(testExercises);

        await mockIsar.lifts.putAll(testLifts);
      });
    });

    test('Creates a workout', () async {
      await db.createWorkout(
        Workout()
          ..date = DateTime(2021, 1, 1)
          ..lifts.addAll(testLifts)
          ..rating = 5,
      );

      final Workout? queriedWorkout = await db.getWorkout(1);

      expect(queriedWorkout!, isNotNull);
      expect(queriedWorkout.date, DateTime(2021, 1, 1));
      expect(queriedWorkout.lifts, hasLength(3));
      expect(queriedWorkout.lifts.toList()[0].exercise.value, isNotNull);
      expect(queriedWorkout.lifts.toList()[0].exercise.value!.name, testExercises[0].name);
    });

    // test('Updates a workout', () async {
    //   await db.createWorkout(
    //     Workout()
    //       ..date = DateTime(2021, 1, 1)
    //       ..lifts.addAll(testLifts)
    //       ..rating = 5,
    //   );

    //   await db.updateWorkout((await db.getWorkout(1))!..rating = 4);

    //   final Workout? queriedWorkout = await db.getWorkout(1);
    //   expect(queriedWorkout!.rating, 4);
    // });

    // test('Deletes a workout', () async {
    //   await db.createWorkout(
    //     Workout()
    //       ..date = DateTime(2021, 1, 1)
    //       ..lifts.addAll(testLifts)
    //       ..rating = 5,
    //   );

    //   await db.deleteWorkout((await db.getWorkout(1))!);

    //   expect(await db.getWorkouts(), isEmpty);
    // });

    // test('Gets a workout', () async {
    //   await db.createWorkout(
    //     Workout()
    //       ..date = DateTime(2021, 1, 1)
    //       ..lifts.addAll(testLifts)
    //       ..rating = 5,
    //   );

    //   final Workout? queriedWorkout = await db.getWorkout(1);

    //   expect(queriedWorkout, isNotNull);
    //   expect(queriedWorkout!.lifts.toList()[0].exercise.value, isNotNull);
    // });
  });
}
