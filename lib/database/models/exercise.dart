import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  final String id;

  Exercise({
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.secondaryMuscles,
    required this.instructions,
    required this.id,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  @override
  String toString() {
    return 'Exercise: {name: $name, bodyPart: $bodyPart, equipment: $equipment, targetMuscle: $target, secondaryMuscles: $secondaryMuscles, instructions: $instructions, id: $id}';
  }
}
