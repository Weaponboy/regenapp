import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:regendataapp/screens/home.dart';
import 'firebase_options.dart';
import 'LoginCode/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}