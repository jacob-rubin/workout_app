import 'package:isar/isar.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/providers/search_provider.dart';

class ExerciseService {
  late final Isar isar;

  ExerciseService(this.isar);

  String _capitalizeFirstLetterOfEachWord(String text) {
    return text
        .split(' ')
        .map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : word)
        .join(' ');
  }

  /// @param exercise Exercise to be added
  /// @returns Id of the created Exercise
  Future<int> addExercise(Exercise exercise) async {
    return isar.writeTxn(() async {
      return await isar.exercises.put(exercise);
    });
  }

  /// @param json JSON of Exercise to be added
  /// @returns Id of the created Exercise
  Future<int> addExerciseFromJSON(Map<String, dynamic> json) async {
    List<String> secondaryMuscles = json['secondaryMuscles'].cast<String>();
    for (int i = 0; i < secondaryMuscles.length; i++) {
      secondaryMuscles[i] = _capitalizeFirstLetterOfEachWord(secondaryMuscles[i]);
    }

    Exercise exercise = Exercise()
      ..name = _capitalizeFirstLetterOfEachWord(json['name'])
      ..bodyPart = _capitalizeFirstLetterOfEachWord(json['bodyPart'])
      ..equipment = _capitalizeFirstLetterOfEachWord(json['equipment'])
      ..targetMuscle = _capitalizeFirstLetterOfEachWord(json['target'])
      ..secondaryMuscles = secondaryMuscles
      ..instructions = json['instructions'].cast<String>()
      ..gifId = json['id'];

    return await isar.writeTxn(() async {
      return await isar.exercises.put(exercise);
    });
  }

  /// @returns List of Exercises
  Future<List<Exercise>> findExercises() async {
    return isar.exercises.where().findAll();
  }

  /// @param searchProvider SearchProvider to be used for searching
  /// @returns List of exercises filtered by the SearchProvider
  Future<List<Exercise>> findSearchedExercises(SearchProvider searchProvider) {
    return isar.exercises
        .filter()
        .nameContains(searchProvider.searchText, caseSensitive: false)
        .and()
        .targetMuscleContains(searchProvider.targetMuscle.name, caseSensitive: false)
        .findAll();
  }

  /// @param id Id of Exercise to be found
  /// @returns Exercise with the given id
  Future<Exercise?> findExerciseById(int id) async {
    return isar.exercises.get(id);
  }

  /// @returns List of Target Muscles
  Future<List<String>> findAllTargetMuscles() async {
    return isar.exercises.where().sortByTargetMuscle().distinctByTargetMuscle().targetMuscleProperty().findAll();
  }

  /// @param exercise Exercise to be updated
  /// @throws Exception if the Exercise is not found
  Future<void> updateExercise(Exercise exercise) async {
    final Exercise? queriedExercise = await isar.exercises.get(exercise.id);

    if (queriedExercise == null) {
      throw Exception('Lift not found');
    }

    await isar.writeTxn(() async {
      await isar.exercises.put(exercise);
    });
  }

  /// @param id Id of Exercise to be deleted
  /// @throws Exception if the Exercise is not found
  Future<void> deleteExercise(int id) async {
    final Exercise? deletedExercise = await isar.exercises.get(id);

    if (deletedExercise == null) {
      throw Exception('Exercise not found');
    }

    return isar.writeTxn(() async {
      await isar.exercises.delete(id);
    });
  }
}
