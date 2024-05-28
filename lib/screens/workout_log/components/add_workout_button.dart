import 'package:flutter/material.dart';

class AddWorkoutButton extends StatelessWidget {
  const AddWorkoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Placeholder(),
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
