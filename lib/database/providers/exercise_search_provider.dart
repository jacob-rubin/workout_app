import 'package:flutter/material.dart';

class ExerciseSearchProvider extends ChangeNotifier {
  String _search = "";
  String? _targetMuscle;
  String? _equipment;
  String? _bodyPart;

  get search => _search;
  get targetMuscle => _targetMuscle;
  get equipment => _equipment;
  get bodyPart => _bodyPart;

  void setSearch(String search) {
    _search = search;
    notifyListeners();
  }

  void setTargetMuscle(String? targetMuscle) {
    _targetMuscle = targetMuscle;
    notifyListeners();
  }

  void setEquipment(String? equipment) {
    _equipment = equipment;
    notifyListeners();
  }

  void setBodyPart(String? bodyPart) {
    _bodyPart = bodyPart;
    notifyListeners();
  }
}
