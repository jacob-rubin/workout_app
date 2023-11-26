import 'package:isar/isar.dart';
import 'package:workout_app/database/models/pr.dart';

class PRService {
  late final Isar isar;

  PRService(this.isar);

  /// Add a PR to the database
  /// @param pr The PR to add
  /// @return The id of the added PR
  Future<int> addPR(PR pr) async {
    return await isar.writeTxn(() async {
      return await isar.pRs.put(pr);
    });
  }

  /// Gets all PRs from the database.
  /// @return A list of all PRs.
  Future<List<PR>> findPRs() async {
    return await isar.pRs.where().findAll();
  }

  /// Gets a PR from the database by id.
  /// @param id The id of the PR to get.
  /// @return The PR with the given id. Null if not found.
  Future<PR?> findPRById(int id) async {
    return await isar.pRs.get(id);
  }

  /// Updates a PR in the database.
  /// @param pr The PR to update.
  /// @throws Exception if the PR is not found.
  Future<void> updatePR(PR pr) async {
    final queriedPR = await isar.pRs.get(pr.id);

    if (queriedPR == null) {
      throw Exception('PR not found');
    }

    await isar.writeTxn(() async {
      await isar.pRs.put(pr);
    });
  }

  /// Deletes a PR from the database.
  /// @param id The id of the PR to delete.
  /// @throws Exception if the PR is not found.
  Future<void> deletePR(int id) async {
    final deletedPR = await isar.pRs.get(id);

    if (deletedPR == null) {
      throw Exception('PR not found');
    }

    return await isar.writeTxn(() async {
      await isar.pRs.delete(id);
    });
  }
}
