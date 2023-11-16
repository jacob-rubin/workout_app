import 'package:flutter/material.dart';

enum View {
  list,
  bodyPart,
}

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
              WorkoutViews(),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutViews extends StatefulWidget {
  const WorkoutViews({super.key});

  @override
  State<WorkoutViews> createState() => _WorkoutViewsState();
}

class _WorkoutViewsState extends State<WorkoutViews> {
  View _view = View.list;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<View>(
      segments: const <ButtonSegment<View>>[
        ButtonSegment<View>(
          value: View.list,
          label: Text('List'),
          icon: Icon(Icons.list),
        ),
        ButtonSegment<View>(
          value: View.bodyPart,
          label: Text('Body Part'),
          icon: Icon(Icons.accessibility),
        ),
      ],
      selected: <View>{_view},
      onSelectionChanged: (Set<View> selection) {
        setState(() {
          _view = selection.first;
        });
      },
    );
  }
}
