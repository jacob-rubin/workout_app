import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/services/isar_service.dart';
import 'package:workout_app/providers/tab_provider.dart';
import 'package:workout_app/screens/home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TabProvider()),
        Provider(create: (context) => IsarService()),
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
