import 'package:isar/isar.dart';
import 'package:workout_app/database/schema/exercise.dart';

part 'pr.g.dart';

@collection
class PR {
  Id id = Isar.autoIncrement;
  final exercise = IsarLink<Exercise>();
  late int weight;
}
