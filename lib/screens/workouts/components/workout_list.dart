import 'package:flutter/material.dart';

class WorkoutList extends StatelessWidget {
  const WorkoutList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ListTile(
          title: Text('Workout 1'),
        ),
        ListTile(
          title: Text('Workout 2'),
        ),
        ListTile(
          title: Text('Workout 3'),
        ),
      ],
    );
  }
}
