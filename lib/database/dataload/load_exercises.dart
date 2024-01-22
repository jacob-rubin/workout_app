import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:workout_app/database/services/isar_service.dart';

class ExerciseJSONElement {
  late String bodyPart;
  late String equipment;
  late String id;
  late String name;
  late String target;
  late List<String> secondaryMuscles;
  late List<String> instructions;

  ExerciseJSONElement(
      {required this.bodyPart,
      required this.equipment,
      required this.id,
      required this.name,
      required this.target,
      required this.secondaryMuscles,
      required this.instructions});

  ExerciseJSONElement.fromJson(Map<String, dynamic> json) {
    bodyPart = json['bodyPart'];
    equipment = json['equipment'];
    id = json['id'];
    name = json['name'];
    target = json['target'];
    secondaryMuscles = json['secondaryMuscles'].cast<String>();
    instructions = json['instructions'].cast<String>();
  }
}

Future<void> loadExercises(IsarService isarService) async {
  final String dataString = await rootBundle.loadString('assets/exerciseData.json');
  final List data = await jsonDecode(dataString);

  for (var exercise in data) {
    await isarService.exerciseService.addExerciseFromJSON(exercise);
  }
}
