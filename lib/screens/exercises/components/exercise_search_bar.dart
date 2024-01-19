import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/providers/search_provider.dart';

class ExerciseSearchBar extends StatefulWidget {
  const ExerciseSearchBar({super.key});

  @override
  State<ExerciseSearchBar> createState() => _ExerciseSearchBarState();
}

class _ExerciseSearchBarState extends State<ExerciseSearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(updateSearch);
  }

  void updateSearch() {
    context.read<SearchProvider>().searchText = _controller.text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Search',
        ),
      ),
    );
  }
}
