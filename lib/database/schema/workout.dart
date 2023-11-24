import 'package:isar/isar.dart';
import 'package:workout_app/database/schema/lift.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;
  final lifts = IsarLinks<Lift>();
  late DateTime date;
  late int rating;
}
