import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/dataload/load_exercises.dart';
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
    test('runs the dataloader', () async {
      await loadExercises(mockIsar, domainService);
    });
  });
}
