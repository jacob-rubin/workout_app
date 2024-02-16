import 'package:flutter/material.dart';
import 'package:workout_app/screens/exercises/exercises.dart';
import 'package:workout_app/screens/workout_history/workout_history.dart';
import 'package:workout_app/screens/workout_log/workout_log.dart';

class Screen {
  final Widget _screen;
  final int _index;

  Screen(this._screen, this._index);

  Widget get screen => _screen;
  int get index => _index;
}

class TabProvider extends ChangeNotifier {
  List<Screen> screens = [
    Screen(const Exercises(), 0),
    Screen(const WorkoutLog(), 1),
    Screen(const WorkoutHistory(), 2),
  ];

  late int _index = screens[0].index;
  late Widget _screen = screens[0].screen;

  int get index => _index;
  set index(int index) {
    _index = index;
    _screen = screens[index].screen;
    notifyListeners();
  }

  Widget get screen => _screen;
  set screen(Widget screen) {
    _screen = screen;
    _index = screens.indexWhere((element) => element.screen == screen);
    notifyListeners();
  }
}
