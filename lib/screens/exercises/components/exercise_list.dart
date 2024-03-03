import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/models/exercise.dart';
import 'package:workout_app/database/providers/database_provider.dart';
import 'package:workout_app/screens/exercises/components/exercise_detail.dart';

class ExerciseList extends StatefulWidget {
  const ExerciseList({super.key});

  @override
  State<ExerciseList> createState() => _ExerciseListState();
}

class _ExerciseListState extends State<ExerciseList> {
  List<Exercise> exercises = [];
  List<Exercise> filteredExercises = [];
  TextEditingController editingController = TextEditingController();

  List<Exercise> filterSearchResults(String query) {
    return exercises.where((Exercise element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
  }

  void updateSearchQuery(String query) {
    setState(() {
      filteredExercises = filterSearchResults(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: context.read<DatabaseProvider>().getExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          exercises = snapshot.data!;
          filteredExercises = exercises;

          print('rendered');

          return Column(
            children: <Widget>[
              TextField(
                controller: editingController,
                onChanged: updateSearchQuery,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredExercises.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: Text(
                          filteredExercises[index].name,
                          maxLines: 1,
                        ),
                      ),
                      subtitle: Text(filteredExercises[index].bodyPart),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetail(exercise: filteredExercises[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
