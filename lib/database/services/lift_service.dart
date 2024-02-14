import 'package:isar/isar.dart';
import 'package:workout_app/database/models/lift.dart';
import 'package:workout_app/database/services/abstractions.dart';

class LiftService implements LiftServices {
  late final Isar _db;

  LiftService(this._db);

  /// @param lift - Lift to be added
  @override
  Future<void> createLift(Lift lift) async {
    await _db.writeTxn(() async {
      await _db.lifts.put(lift);
      await lift.exercise.save();
    });
  }

  /// @param lift - Lift to be updated
  /// @throws Exception if Lift not found
  @override
  Future<void> updateLift(Lift lift) async {
    Lift? liftToUpdate = await getLift(lift.id);

    if (liftToUpdate == null) {
      throw Exception('Lift not found');
    }

    await _db.writeTxn(() async {
      await _db.lifts.put(lift);
      await lift.exercise.save();
    });
  }

  /// @param lift - Lift to be deleted
  @override
  Future<void> deleteLift(Lift lift) async {
    await _db.writeTxn(() async {
      await _db.lifts.delete(lift.id);
    });
  }

  /// @param id - Id of Lift to be found
  /// @returns Lift with the given id
  @override
  Future<Lift?> getLift(int id) async {
    return await _db.lifts.get(id);
  }

  /// @returns List of Lifts
  @override
  Future<List<Lift>> getLifts() async {
    return await _db.lifts.where().findAll();
  }
}
