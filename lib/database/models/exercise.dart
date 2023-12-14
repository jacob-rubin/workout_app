import 'package:isar/isar.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;
  late String name;
  late String bodyPart;
  late String equipment;
  late String targetMuscle;
  late List<String> secondaryMuscles;
  late List<String> instructions;
  late String gifId;
}
