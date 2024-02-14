import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/providers/tab_provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: context.watch<TabProvider>().index,
      onDestinationSelected: (index) {
        context.read<TabProvider>().index = index;
      },
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.menu_book),
          icon: Icon(Icons.menu_book_outlined),
          label: 'Exercises',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.add_circle_outline),
          icon: Icon(Icons.add),
          label: 'Log',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.history_outlined),
          icon: Icon(Icons.history),
          label: 'History',
        ),
      ],
    );
  }
}
