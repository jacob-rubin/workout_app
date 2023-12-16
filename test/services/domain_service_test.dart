import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/models/workout.dart';
import 'package:workout_app/database/services/domain_services.dart';

void main() {
  late Isar mockIsar;
  late Directory mockDir;
  late DomainService domainService;

  setUpAll(() async {
    mockDir = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      mockIsar = await Isar.open([ExerciseSchema, WorkoutSchema, LiftSchema], directory: mockDir.path, name: 'domainInstance');
    }
    domainService = DomainService.withIsar(mockIsar);
  });

  tearDownAll(() async {
    await mockIsar.close(deleteFromDisk: true);
  });

  test('open an instance on the Isar database', () {
    final isOpen = mockIsar.isOpen;

    expect(isOpen, isTrue);
  });

  group('Exercise Service', () {
    List<Exercise> exercises = [
      Exercise()
        ..id = 1
        ..name = 'Bench Press'
        ..bodyPart = 'Chest'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Pectoralis Major'
        ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
        ..instructions = ['Lie on bench', 'Lower bar to chest', 'Press bar back up']
        ..gifId = '001',
      Exercise()
        ..id = 2
        ..name = 'Squat'
        ..bodyPart = 'Legs'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Quadriceps'
        ..secondaryMuscles = ['Glutes', 'Hamstrings']
        ..instructions = ['Place bar on back', 'Squat down', 'Stand back up']
        ..gifId = '002',
    ];

    setUp(() async {
      // Clear database and add 2 mock exercises
      await mockIsar.writeTxn(() async {
        await mockIsar.exercises.clear();
        await mockIsar.exercises.putAll(exercises);
      });
    });

    test('Creates an exercise', () async {
      final Exercise exercise = Exercise()
        ..name = 'Bench Press'
        ..bodyPart = 'Chest'
        ..equipment = 'Barbell'
        ..targetMuscle = 'Pectoralis Major'
        ..secondaryMuscles = ['Triceps', 'Anterior Deltoid']
        ..instructions = ['Lie on bench', 'Lower bar to chest', 'Press bar back up']
        ..gifId = 'bench-press';

      final int id = await domainService.exerciseService.addExercise(exercise);
      final Exercise? queriedExercise = await mockIsar.exercises.get(id);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, equals('Bench Press'));
      expect(queriedExercise.bodyPart, equals('Chest'));
      expect(queriedExercise.equipment, equals('Barbell'));
      expect(queriedExercise.targetMuscle, equals('Pectoralis Major'));
      expect(queriedExercise.secondaryMuscles, equals(['Triceps', 'Anterior Deltoid']));
      expect(queriedExercise.instructions, equals(['Lie on bench', 'Lower bar to chest', 'Press bar back up']));
      expect(queriedExercise.gifId, equals('bench-press'));
    });

    test('Finds all exercises', () async {
      final List<Exercise> queriedExercises = await domainService.exerciseService.findExercises();

      expect(queriedExercises, hasLength(2));

      // TODO: Make this test more robust
      expect(queriedExercises[0].name, exercises[0].name);
      expect(queriedExercises[1].name, exercises[1].name);
    });

    test('Finds an exercise by ID', () async {
      final Exercise? queriedExercise = await domainService.exerciseService.findExerciseById(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, exercises[0].name);
    });

    test('Returns null if exercise is not found', () async {
      final Exercise? queriedExercise = await domainService.exerciseService.findExerciseById(3);

      expect(queriedExercise, isNull);
    });

    test('Updates an exercise', () async {
      final Exercise newExercise = exercises[0]..name = 'Bench Press Updated';

      await domainService.exerciseService.updateExercise(newExercise);
      final Exercise? queriedExercise = await mockIsar.exercises.get(1);

      expect(queriedExercise, isNotNull);
      expect(queriedExercise!.name, newExercise.name);
    });

    test('Deletes an exercise', () async {
      await domainService.exerciseService.deleteExercise(1);

      final List<Exercise> exerciseList = await mockIsar.exercises.where().findAll();
      final Exercise? deletedExercise = await mockIsar.exercises.get(1);

      expect(exerciseList, hasLength(1));
      expect(exerciseList[0].name, exercises[1].name);
      expect(deletedExercise, isNull);
    });
  });
}
