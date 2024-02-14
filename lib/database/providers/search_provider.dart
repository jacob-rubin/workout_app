import 'package:flutter/foundation.dart';

class TargetMuscle {
  String name = '';
  int? index;

  TargetMuscle({required this.name, required this.index});

  TargetMuscle.reset() {
    name = '';
    index = null;
  }
}

class ExerciseSearchProvider extends ChangeNotifier {
  String _searchText = '';
  TargetMuscle _targetMuscle = TargetMuscle(
    name: '',
    index: null,
  );

  String get searchText => _searchText;
  set searchText(String searchText) {
    _searchText = searchText;
    notifyListeners();
  }

  TargetMuscle get targetMuscle => _targetMuscle;
  set targetMuscle(TargetMuscle targetMuscle) {
    _targetMuscle = targetMuscle;
    notifyListeners();
  }
}
