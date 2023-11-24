import 'package:isar/isar.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;
  late String bodyPart;
  late String equipment;
  late String gif;
}
