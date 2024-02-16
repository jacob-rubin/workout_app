import 'package:isar/isar.dart';
import 'package:workout_app/database/models/lift.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;
  final lifts = IsarLinks<Lift>();
  late DateTime date;
  late int rating;

  @override
  String toString() {
    return 'Workout: {id: $id, lifts: ${lifts.map((e) => e.toString())}, date: $date, rating: $rating}';
  }
}
