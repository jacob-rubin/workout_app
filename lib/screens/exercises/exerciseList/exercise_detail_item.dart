import 'dart:core';

import 'package:flutter/material.dart';

// TODO: Remove all this duplicate code
class ExerciseDetailItemSingle extends StatelessWidget {
  const ExerciseDetailItemSingle({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title),
            Text(
              description,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailItemMulti extends StatelessWidget {
  const ExerciseDetailItemMulti({super.key, required this.title, required this.description});

  final String title;
  final List<String> description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(title),
            ...description.map(
              (text) => Text(
                text,
                style: const TextStyle(
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseDetailItemNumbered extends StatelessWidget {
  const ExerciseDetailItemNumbered({super.key, required this.title, required this.description});

  final String title;
  final List<String> description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('$title\n'),
            ...description.asMap().entries.map(
                  (entry) => Text(
                    '${entry.key + 1}. ${entry.value}\n',
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
