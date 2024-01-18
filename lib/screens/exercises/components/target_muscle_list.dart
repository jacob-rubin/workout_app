import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/providers/search_provider.dart';

class TargetMuscleList extends StatefulWidget {
  const TargetMuscleList({super.key});

  @override
  State<TargetMuscleList> createState() => _TargetMuscleListState();
}

class _TargetMuscleListState extends State<TargetMuscleList> {
  late Future<List<String>> _targetMuscles;

  // Only fetch data once, so query the data in initState
  @override
  void initState() {
    super.initState();
    _targetMuscles = context.read<IsarService>().exerciseService.findAllTargetMuscles();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _targetMuscles,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
            return const SizedBox(
              height: 50,
            );
          }

          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InputChip(
                    selected: index == context.read<SearchProvider>().chipIndex,
                    onSelected: (bool selected) {
                      setState(() {
                        if (index == context.read<SearchProvider>().chipIndex) {
                          context.read<SearchProvider>().chipIndex = null;
                        } else {
                          context.read<SearchProvider>().chipIndex = index;
                        }
                      });
                    },
                    label: Text(snapshot.data![index]),
                  ),
                );
              },
            ),
          );
        });
  }
}
