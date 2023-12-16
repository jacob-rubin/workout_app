import 'package:flutter/material.dart';
import 'package:workout_app/screens/exercises/components/exercise_list.dart';
import 'package:workout_app/screens/exercises/components/search_bar.dart';
import 'package:workout_app/screens/exercises/components/exercise_view_toggle_buttons.dart';

class Exercises extends StatelessWidget {
  const Exercises({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: WorkoutViewToggles(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: WorkoutSearchBar(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ExerciseList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
