import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/services/isar_service.dart';

class TargetMuscleList extends StatelessWidget {
  const TargetMuscleList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<IsarService>(context).exerciseService.findAllTargetMuscles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
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
                    label: Text(snapshot.data![index]),
                    onPressed: () {},
                  ),
                );
              },
            ),
          );
        });
  }
}
