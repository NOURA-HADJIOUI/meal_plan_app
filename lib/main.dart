import 'package:flutter/material.dart';
import 'package:meal_plan_app/FirstPage.dart';
import 'package:meal_plan_app/intro.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart'; 

void main() async {
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
    return MaterialApp(
      title: 'YumPlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        fontFamily: 'Quicksand',
      ),
      home: const SplashScreen(
        nextPage: Intro1(),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
