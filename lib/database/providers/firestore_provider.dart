import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreProvider extends ChangeNotifier {
  late final FirebaseFirestore _db;

  FirestoreProvider() {
    _db = FirebaseFirestore.instance;
  }

  // Get all exercises from Firestore as stream
  Stream<QuerySnapshot<Map<String, dynamic>>> getExerciseStream() {
    return _db.collection('exercises').snapshots();
  }
}
