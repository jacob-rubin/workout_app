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

import 'mock_workouts.dart';

void main() {
  late Isar mockIsar;
  late Directory mockDir;
  late DatabaseProvider db;
  late ExerciseService exerciseService;
  late LiftService liftService;
  late WorkoutService workoutService;

  setUpAll(() async {
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
  });

  tearDownAll(() async {
    await mockIsar.close(deleteFromDisk: true);
  });

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
      final Exercise? queriedExercise = await mockIsar.exercises.get(3);

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
      final Exercise? queriedExercise = await db.getExercise(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, mockExercises[0].name);
    });

    test('Returns null if exercise is not found', () async {
      final Exercise? queriedExercise = await db.getExercise(3);

      expect(queriedExercise, isNull);
    });

    test('Updates an exercise', () async {
      final Exercise newExercise = mockExercises[0]..name = 'Bench Press Updated';

      await db.updateExercise(newExercise);
      final Exercise? queriedExercise = await mockIsar.exercises.get(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, newExercise.name);
    });

    test('Deletes an exercise', () async {
      await db.deleteExercise(mockExercises[0]);

      final List<Exercise> exerciseList = await mockIsar.exercises.where().findAll();
      final Exercise? deletedExercise = await mockIsar.exercises.get(1);

      expect(exerciseList, hasLength(1));
      expect(exerciseList[0].name, mockExercises[1].name);
      expect(deletedExercise, isNull);
    });
  });

  group('Lift service', () {
    setUp(() async {
      await mockIsar.writeTxn(() async {
        await mockIsar.lifts.clear();
        await mockIsar.exercises.clear();
      });
    });

    test('Gets a single lift', () async {
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.put(mockExercises[0]);
        await mockIsar.lifts.put(mockLifts[0]);
        await mockLifts[0].exercise.save();
      });

      final Lift? queriedLift = await db.getLift(1);

      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercises[0].name);
      expect(queriedLift.sets, hasLength(2));
      expect(queriedLift.sets[0].reps, 10);
      expect(queriedLift.sets[0].weight, 100);
      expect(queriedLift.sets[1].reps, 12);
      expect(queriedLift.sets[1].weight, 90);
    });

    test('Gets all lifts', () async {
      Logger log = Logger();
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
        log.d(queriedLifts[i].exercise.value!.name);
        expect(queriedLifts[i].sets, hasLength(2));
      }
    });

    test('Creates a lift', () async {
      Lift lift = Lift()
        ..exercise.value = mockExercise
        ..sets = [
          Set()
            ..reps = 10
            ..weight = 100,
          Set()
            ..reps = 12
            ..weight = 90,
        ];

      await db.createExercise(mockExercise);
      await db.createLift(lift);

      final Lift? queriedLift = await mockIsar.lifts.get(1);

      expect(await mockIsar.lifts.where().findAll(), hasLength(1));
      expect(queriedLift, isNotNull);
      expect(queriedLift!.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercise.name);
      expect(queriedLift.sets, hasLength(2));
      expect(queriedLift.sets[0].reps, 10);
      expect(queriedLift.sets[0].weight, 100);
    });

    test('Updates a lift with a new set', () async {
      await db.createExercise(mockExercise);
      Lift lift = Lift()
        ..exercise.value = mockExercise
        ..sets = [
          Set()
            ..reps = 10
            ..weight = 100,
          Set()
            ..reps = 12
            ..weight = 90,
        ];

      await db.createLift(lift);
      await db.updateLift(
        lift
          ..sets.add(Set()
            ..reps = 8
            ..weight = 80),
      );

      final Lift? queriedLift = await mockIsar.lifts.get(1);
      expect(queriedLift, isNotNull);
      expect(queriedLift!.sets, hasLength(3));
      expect(queriedLift.sets[2].reps, 8);
      expect(queriedLift.sets[2].weight, 80);
      expect(queriedLift.exercise.value, isNotNull);
      expect(queriedLift.exercise.value!.name, mockExercise.name);
    });

    test('Updates a lift with a new exercise', () async {
      await db.createExercise(mockExercises[0]);
    });

    test('Deletes a lift', () {});
  });
}
