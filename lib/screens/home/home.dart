import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/components/bottom_navigation.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/providers/tab_provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<IsarService>(context).init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          bottomNavigationBar: const BottomNavigation(),
          body: context.watch<TabProvider>().screen,
        );
      },
    );
  }
}
