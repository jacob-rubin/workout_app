import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/providers/tab_provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: Provider.of<TabProvider>(context).screenIndex,
      onDestinationSelected: (index) {
        Provider.of<TabProvider>(context, listen: false).screenIndex = index;
      },
      destinations: const <Widget>[
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
