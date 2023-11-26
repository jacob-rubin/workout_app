import 'package:isar/isar.dart';
import 'package:workout_app/database/models/lift.dart';

class LiftService {
  late final Isar isar;

  LiftService(this.isar);

  /// Adds a lift to the database.
  /// @param Lift The lift to add.
  /// @return The id of the lift added.
  Future<int> createLift(Lift lift) async {
    return await isar.writeTxn(() async {
      return await isar.lifts.put(lift);
    });
  }

  /// Gets all lifts from the database.
  /// @return A list of all lifts.
  Future<List<Lift>> findLifts() async {
    return await isar.lifts.where().findAll();
  }

  /// Gets a lift from the database by id.
  /// @param id The id of the lift to get.
  /// @return The lift with the given id.
  /// @throws Exception if the lift is not found.
  Future<Lift?> findLiftById(int id) async {
    return await isar.lifts.get(id);
  }

  /// Updates a lift in the database.
  /// @param lift The lift to update.
  /// @return The id of the lift updated.
  /// @throws Exception if the lift is not found.
  Future<int> updateLift(Lift lift) async {
    final Lift? queriedLift = await isar.lifts.get(lift.id);

    if (queriedLift == null) {
      throw Exception('Lift not found');
    }

    return await isar.writeTxn(() async {
      return await isar.lifts.put(lift);
    });
  }

  /// Deletes a lift from the database.
  /// @param id The id of the lift to delete.
  /// @throws Exception if the lift is not found.
  Future<void> deleteLift(int id) async {
    final Lift? deletedLift = await isar.lifts.get(id);

    if (deletedLift == null) {
      throw Exception('Lift not found');
    }

    return await isar.writeTxn(() async {
      await isar.lifts.delete(id);
    });
  }
}
