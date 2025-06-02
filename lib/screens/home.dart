import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:regendataapp/Colors.dart';
import 'package:regendataapp/screens/AnimalDataEntry.dart';
import 'package:regendataapp/screens/Customize.dart';
import 'package:regendataapp/screens/ManagementDataEntry.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Animals'},
    {'id': '2', 'title': 'Management'},
    {'id': '3', 'title': 'Customize'},
  ];

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = AnimalDataEntry();
        break;
      case '2':
        destinationPage = ManagementDataEntry();
        break;
      case '3':
        destinationPage = Customize();
        break;
      default:
        destinationPage = HomeScreen();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = 90.0;
    final padding = 50.0;
    final bottomPosition = size.height - circleSize - (padding + 50);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/grass.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Roboto',
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5),
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                ),
                onPressed: () => _logout(context),
                child: Text(
                  'Logout',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              left: padding,
              top: bottomPosition,
              child: GestureDetector(
                onTap: () => _navigateToPage(context, cardData[0]['id']),
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors().circleGreen,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      cardData[0]['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: bottomPosition - 120,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _navigateToPage(context, cardData[1]['id']),
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors().circleGreen,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      cardData[1]['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: padding,
              top: bottomPosition,
              child: GestureDetector(
                onTap: () => _navigateToPage(context, cardData[2]['id']),
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors().circleGreen,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(6, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      cardData[2]['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}