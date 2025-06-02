import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:regendataapp/LoginCode/CurrentUserData.dart';
import 'package:regendataapp/LoginCode/screens/login.dart';
import 'package:regendataapp/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the generated firebase_options.dart file
import 'firebase_options.dart'; // This file will be generated after setup

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => AuthWrapper(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  Future<void> _fetchUserData(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      currentUserData().username = querySnapshot.docs.first.get('username');
      currentUserData().admin = querySnapshot.docs.first.get('admin');
      print(currentUserData().username);
      print(currentUserData().admin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          final user = snapshot.data!;
          print(user.email);
          currentUserData().email = user.email ?? '';
          _fetchUserData(user.email ?? '');
          return HomeScreen();
        }
        return LoginScreen();
      },
    );
  }
}