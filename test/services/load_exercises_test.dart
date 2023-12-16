import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/services/domain_services.dart';

void main() {
  late Isar mockIsar;
  late Directory mockDir;
  late DomainService domainService;

  setUpAll(() async {
    mockDir = Directory.systemTemp.createTempSync();
    await Isar.initializeIsarCore(download: true);

    if (Isar.instanceNames.isEmpty) {
      mockIsar = await Isar.open([ExerciseSchema], directory: mockDir.path, name: 'domainInstance');
    }

    domainService = DomainService.withIsar(mockIsar);
  });

  tearDownAll(() async {
    await mockIsar.close(deleteFromDisk: true);
  });

  group('Dataloader', () {
    test('Dataloads the JSON of exercises into isar', () async {
      await loadExercises(mockIsar, domainService);
      final List exerciseJSON = await jsonDecode(await File('lib/database/data/exerciseData.json').readAsString());
      final List<Exercise> dbExercises = await mockIsar.exercises.where().findAll();

      for (var i = 0; i < exerciseJSON.length; i++) {
        expect(dbExercises[i].name, exerciseJSON[i]['name']);
        expect(dbExercises[i].bodyPart, exerciseJSON[i]['bodyPart']);
        expect(dbExercises[i].equipment, exerciseJSON[i]['equipment']);
        expect(dbExercises[i].targetMuscle, exerciseJSON[i]['target']);
        expect(dbExercises[i].secondaryMuscles, exerciseJSON[i]['secondaryMuscles'].cast<String>());
        expect(dbExercises[i].instructions, exerciseJSON[i]['instructions'].cast<String>());
        expect(dbExercises[i].gifId, exerciseJSON[i]['id']);
      }
    });
  });
}
