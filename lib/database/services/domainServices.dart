import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_app/database/models/workout.dart';

void main() async {
  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [WorkoutSchema],
    directory: dir.path,
  );
}
