import 'package:flutter/material.dart';

enum View {
  list,
  bodyPart,
}

class WorkoutViewToggles extends StatefulWidget {
  const WorkoutViewToggles({super.key});

  @override
  State<WorkoutViewToggles> createState() => _WorkoutViewTogglesState();
}

class _WorkoutViewTogglesState extends State<WorkoutViewToggles> {
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
