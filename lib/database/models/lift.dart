import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';

part 'lift.g.dart';

@collection
class Lift {
  Id id = Isar.autoIncrement;
  final exercise = IsarLink<Exercise>();
  late List<Set> sets;
  String? notes;

  @override
  String toString() {
    return 'Lift: {id: $id, exercise: ${exercise.value}, sets: ${sets.map((e) => e.toString())}, notes: $notes}';
  }
}

@embedded
class Set {
  int? reps;
  int? weight;

  Set({
    this.reps,
    this.weight,
  });

  @override
  String toString() {
    return 'Set: {reps: $reps, weight: $weight}';
  }
}
