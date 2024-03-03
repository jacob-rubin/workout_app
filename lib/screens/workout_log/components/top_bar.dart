import 'package:flutter/material.dart';

class WorkoutLogAppBar extends StatelessWidget {
  const WorkoutLogAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Row(
        children: <Widget>[
          const Text('0:00'),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
    );
  }
}
