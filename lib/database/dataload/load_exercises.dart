import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:workout_app/database/services/domain_services.dart';

class ExerciseJSONElement {
  late String bodyPart;
  late String equipment;
  late String id;
  late String name;
  late String target;
  late List<String> secondaryMuscles;
  late List<String> instructions;

  ExerciseJSONElement({required this.bodyPart, required this.equipment, required this.id, required this.name, required this.target, required this.secondaryMuscles, required this.instructions});

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

Future<void> loadExercises(Isar isar, DomainService domainService) async {
  final String dataString = await File('/Users/VTNC34/Desktop/workout_app/lib/database/data/exerciseData.json').readAsString();
  final List data = await jsonDecode(dataString);

  for (var exercise in data) {
    await domainService.exerciseService.addExerciseFromJSON(exercise);
  }
}
