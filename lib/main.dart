import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_app/database/providers/database_provider.dart';
import 'package:workout_app/database/providers/exercise_search_provider.dart';
import 'package:workout_app/database/providers/tab_provider.dart';
import 'package:workout_app/screens/home/home.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => TabProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseSearchProvider()),
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
