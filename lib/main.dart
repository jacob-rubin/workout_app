import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/providers/search_provider.dart';
import 'package:workout_app/providers/tab_provider.dart';
import 'package:workout_app/screens/home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => IsarService()),
        ChangeNotifierProvider(create: (context) => TabProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
      ],
      child: MaterialApp(
        title: 'Workout App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme.light(),
        ),
        home: const Home(),
      ),
    );
  }
}
