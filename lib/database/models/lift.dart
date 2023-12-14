import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';

part 'lift.g.dart';

@embedded
class Set {
  late int reps;
  late int weight;
}

@collection
class Lift {
  Id id = Isar.autoIncrement;
  final exercise = IsarLink<Exercise>();
  late List<Set> sets;
  String? notes;
}
