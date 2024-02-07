import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';

part 'lift.g.dart';

@collection
class Lift {
  Id id = Isar.autoIncrement;
  final exercise = IsarLink<Exercise>();
  late List<Set> sets;
  String? notes;
}

@embedded
class Set {
  int? reps;
  int? weight;

  Set({
    this.reps,
    this.weight,
  });
}
