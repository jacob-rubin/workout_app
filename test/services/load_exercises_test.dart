import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/isar_service.dart';

void main() {
  late Isar mockIsar;
  late Directory mockDir;
  late IsarService isarService;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    mockDir = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    mockIsar = await Isar.open([ExerciseSchema], directory: mockDir.path);
    isarService = IsarService.withIsar(mockIsar);
  });

  tearDownAll(() async {
    await mockIsar.close(deleteFromDisk: true);
  });

  group('Dataloader', () {
    test('Dataloads the JSON of exercises into isar', () async {
      await loadExercises(isarService);
      final List exerciseJSON = await jsonDecode(await File('assets/exerciseData.json').readAsString());
      final List<Exercise> dbExercises = await mockIsar.exercises.where().findAll();

      for (var i = 0; i < exerciseJSON.length; i++) {
        expect(dbExercises[i].name.toLowerCase(), exerciseJSON[i]['name'].toLowerCase());
        expect(dbExercises[i].bodyPart.toLowerCase(), exerciseJSON[i]['bodyPart'].toLowerCase());
        expect(dbExercises[i].equipment.toLowerCase(), exerciseJSON[i]['equipment'].toLowerCase());
        expect(dbExercises[i].targetMuscle.toLowerCase(), exerciseJSON[i]['target'].toLowerCase());
        expect(dbExercises[i].secondaryMuscles.map((e) => e.toLowerCase()),
            exerciseJSON[i]['secondaryMuscles'].cast<String>().map((e) => e.toLowerCase()));
        expect(dbExercises[i].instructions, exerciseJSON[i]['instructions'].cast<String>());
        expect(dbExercises[i].gifId, exerciseJSON[i]['id']);
      }
    });
  });
}
