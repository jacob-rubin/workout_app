import 'package:flutter/material.dart';
import 'package:workout_app/screens/workouts/components/search_bar.dart';
import 'components/workout_view_toggle_buttons.dart';

class Workouts extends StatelessWidget {
  const Workouts({super.key});

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
            ],
          ),
        ),
      ),
    );
  }
}
