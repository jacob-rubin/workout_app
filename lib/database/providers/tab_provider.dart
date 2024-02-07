import 'package:flutter/material.dart';
import 'package:workout_app/screens/exercises/exercises.dart';
import 'package:workout_app/screens/workout_history/workout_history.dart';
import 'package:workout_app/screens/workout_log/workout_log.dart';

// TODO: Fix this coupling. Perhaps convert to object?
class TabProvider extends ChangeNotifier {
  var screenList = <Widget>[
    const Exercises(),
    const WorkoutLog(),
    const WorkoutHistory(),
  ];

  late int _screenIndex = 0;
  late Widget _screen = const Exercises();

  int get screenIndex => _screenIndex;
  set screenIndex(int screen) {
    _screenIndex = screen;
    _screen = screenList[_screenIndex];
    notifyListeners();
  }

  Widget get screen => _screen;
  set screen(Widget screen) {
    _screen = screen;
    _screenIndex = screenList.indexOf(_screen);
    notifyListeners();
  }
}
