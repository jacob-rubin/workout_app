import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class WorkoutStartButton extends StatelessWidget {
  const WorkoutStartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Logger log = Logger();
              log.d('Add Exercise');
            },
            child: const Text('Start Workout'),
          ),
        ),
      ),
    );
  }
}
