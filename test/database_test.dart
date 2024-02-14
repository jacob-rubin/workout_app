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

import 'mock_data.dart';

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
      print(label);
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
    setUp(() async {
      // Clear database and add 2 mock exercises
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
        await mockIsar.exercises.putAll(mockExercises);
      });
    });

    test('Creates an exercise', () async {
      await db.createExercise(mockExercise);
      final Exercise? queriedExercise = await mockIsar.exercises.get(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, equals(mockExercise.name));
      expect(queriedExercise.bodyPart, equals(mockExercise.bodyPart));
      expect(queriedExercise.equipment, equals(mockExercise.equipment));
      expect(queriedExercise.targetMuscle, equals(mockExercise.targetMuscle));
      expect(queriedExercise.secondaryMuscles, equals(mockExercise.secondaryMuscles));
      expect(queriedExercise.instructions, equals(mockExercise.instructions));
      expect(queriedExercise.gifId, equals(mockExercise.gifId));
    });

    test('Finds all exercises', () async {
      final List<Exercise> queriedExercises = await db.getExercises();

      expect(queriedExercises, hasLength(2));
      expect(queriedExercises[0].name, mockExercises[0].name);
      expect(queriedExercises[1].name, mockExercises[1].name);
    });

    test('Finds an exercise by ID', () async {
      final Exercise? queriedExercise = await db.getExercise(2);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, mockExercises[0].name);
    });

    test('Returns null if exercise is not found', () async {
      final Exercise? queriedExercise = await db.getExercise(4);

      expect(queriedExercise, isNull);
    });

    test('Updates an exercise', () async {
      final Exercise newExercise = mockExercises[0]..name = 'Bench Press Updated';

      await db.updateExercise(newExercise);
      final Exercise? queriedExercise = await mockIsar.exercises.get(2);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, newExercise.name);
    });

    test('Deletes an exercise', () async {
      await db.deleteExercise(mockExercises[0]);

      final List<Exercise> exerciseList = await mockIsar.exercises.where().findAll();
      final Exercise? deletedExercise = await mockIsar.exercises.get(2);

      expect(exerciseList, hasLength(1));
      expect(exerciseList[0].name, mockExercises[1].name);
      expect(deletedExercise, isNull);
    });
  });

  group('Lift Service', () {
    setUp(() async {
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
        await mockIsar.lifts.clear();
        await mockIsar.workouts.clear();
      });

      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.putAll(mockExercises);
      });
    });

    test('Gets a single lift', () async {
      Lift mockLift = Lift()
        ..id = 1
        ..exercise.value = mockExercises[0]
        ..sets = [
          Set(reps: 10, weight: 100),
          Set(reps: 12, weight: 90),
        ];

      await mockIsar.writeTxn(() async {
        await mockIsar.lifts.put(mockLift);
        await mockLift.exercise.save();
      });

      final Lift? queriedLift = await db.getLift(1);

      expect(queriedLift!, isNotNull);
      expect(queriedLift.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercises[0].name);
      expect(queriedLift.sets, hasLength(2));
      expect(queriedLift.sets[0].reps, 10);
      expect(queriedLift.sets[0].weight, 100);
      expect(queriedLift.sets[1].reps, 12);
      expect(queriedLift.sets[1].weight, 90);
    });

    test('Gets all lifts', () async {
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.putAll(mockExercises);
        for (Lift lift in mockLifts) {
          await mockIsar.lifts.put(lift);
          await lift.exercise.save();
        }
      });

      final List<Lift> queriedLifts = await db.getLifts();

      for (int i = 0; i < queriedLifts.length; i++) {
        expect(queriedLifts[i], isNotNull);
        expect(queriedLifts[i].exercise.value, isNotNull);
        expect(queriedLifts[i].exercise.value!.name, isNotNull);
        expect(queriedLifts[i].sets, hasLength(2));
      }
    });

    test('Creates a lift', () async {
      await db.createLift(Lift()
        ..exercise.value = mockExercises[0]
        ..sets = [
          Set(reps: 10, weight: 100),
          Set(reps: 12, weight: 90),
        ]);

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(await mockIsar.lifts.where().findAll(), hasLength(1));
      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercises[0].name);
      expect(queriedLift.sets, hasLength(2));
      expect(queriedLift.sets[0].reps, 10);
      expect(queriedLift.sets[0].weight, 100);
    });

    test('Creates multiple lifts with the same exercise', () async {
      await db.createLift(Lift()
        ..exercise.value = mockExercises[0]
        ..sets = [
          Set(reps: 10, weight: 100),
          Set(reps: 12, weight: 90),
        ]);

      await db.createLift(Lift()
        ..exercise.value = mockExercises[0]
        ..sets = [
          Set(reps: 1, weight: 500),
          Set(reps: 1, weight: 500),
        ]);

      final List<Lift> queriedLifts = await mockIsar.lifts.where().findAll();

      expect(queriedLifts, hasLength(2));
      expect(queriedLifts[0].exercise.value, isNotNull);
      expect(queriedLifts[0].exercise.value!.name, mockExercises[0].name);
      expect(queriedLifts[1].exercise.value, isNotNull);
      expect(queriedLifts[1].exercise.value!.name, mockExercises[0].name);
    });

    test('Updates a lift with a new set', () async {
      await db.createLift(
        Lift()
          ..exercise.value = mockExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      int liftId = await db.getLifts().then((value) => value[0].id);
      await db.updateLift(Lift()
        ..id = liftId
        ..sets = [
          Set(reps: 10, weight: 100),
          Set(reps: 12, weight: 90),
          Set(reps: 12, weight: 80),
        ]);

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(queriedLift, isNotNull);
      expect(queriedLift!.sets, hasLength(3));
      expect(queriedLift.sets[2].reps, 12);
      expect(queriedLift.sets[2].weight, 80);
      expect(queriedLift.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercises[0].name);
    });

    test('Updates a lift with a new exercise', () async {
      await db.createLift(
        Lift()
          ..exercise.value = mockExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      int liftId = await db.getLifts().then((value) => value[0].id);
      await db.updateLift(
        Lift()
          ..id = liftId
          ..exercise.value = mockExercises[1]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercises[1].name);
      expect(queriedLift.sets, hasLength(2));
      expect(await mockIsar.lifts.where().findAll(), hasLength(1));
    });

    test('Deletes a lift', () async {
      await db.createLift(
        Lift()
          ..id = 1
          ..exercise.value = mockExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      await db.deleteLift(Lift()..id = 1);

      expect(await mockIsar.lifts.where().findAll(), isEmpty);
      expect(await mockIsar.exercises.where().findAll(), hasLength(2));
    });

    test('Gets a lift', () async {
      await db.createLift(
        Lift()
          ..id = 1
          ..exercise.value = mockExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );

      final Lift? queriedLift = await db.getLift(1);

      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercises[0].name);
    });

    test('Gets all lifts', () async {
      await db.createLift(
        Lift()
          ..id = 1
          ..exercise.value = mockExercises[0]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );
      await db.createLift(
        Lift()
          ..id = 2
          ..exercise.value = mockExercises[1]
          ..sets = [
            Set(reps: 10, weight: 100),
            Set(reps: 12, weight: 90),
          ],
      );

      final List<Lift> queriedLifts = await db.getLifts();

      expect(queriedLifts, hasLength(2));
      expect(queriedLifts[0].exercise.value, isNotNull);
      expect(queriedLifts[0].exercise.value!.name, mockExercises[0].name);
      expect(queriedLifts[1].exercise.value, isNotNull);
      expect(queriedLifts[1].exercise.value!.name, mockExercises[1].name);
    });
  });

  group('Workout Service', () {
    setUp(() async {
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
        await mockIsar.lifts.clear();
        await mockIsar.exercises.putAll(mockExercises);
        await mockIsar.lifts.putAll(mockLifts);
      });

      await printIsarInstances('Workout Service - Setup');
    });

    test('Creates a workout', () async {
      await db.createWorkout(
        Workout()
          ..date = DateTime(2021, 1, 1)
          ..rating = 5
          ..lifts.addAll(mockLifts),
      );

      final Workout? queriedWorkout = await db.getWorkout(1);

      await printIsarInstances('Workout Service - Creates a workout');

      expect(queriedWorkout!, isNotNull);
      expect(queriedWorkout.date, DateTime(2021, 1, 1));
      expect(queriedWorkout.lifts, hasLength(3));
      expect(queriedWorkout.lifts.toList()[0].exercise.value, isNotNull);
      expect(queriedWorkout.lifts.toList()[0].exercise.value!.name, mockExercises[0].name);
      expect(queriedWorkout.lifts.toList()[1].exercise.value, isNotNull);
      expect(queriedWorkout.lifts.toList()[1].exercise.value!.name, mockExercises[1].name);
    });
  });
}
