import 'package:flutter/material.dart';
import 'package:regendataapp/screens/Customize.dart';
import 'package:regendataapp/screens/DataEntry.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Data entry'},
    {'id': '2', 'title': 'Customize'},
  ];

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = DataEntry();
        break;
      case '2':
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = 90.0; // Size of each small circle
    final padding = 50.0; // Padding from edges
    final bottomPosition = size.height - circleSize - (padding + 50); // Same height for both

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('grass.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Bottom-left circle
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Roboto', // Popular, clean font (ensure it's added in pubspec.yaml)
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.5), // Semi-transparent black shadow
                        offset: Offset(2.0, 2.0), // Slight offset for depth
                      ),
                    ],
                    color: Colors.white, // Maintains visibility
                  ),
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
                    color: Colors.green,
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
            // Bottom-right circle
            Positioned(
              right: padding,
              top: bottomPosition,
              child: GestureDetector(
                onTap: () => _navigateToPage(context, cardData[1]['id']),
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
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
          ],
        ),
      ),

    );
  }
}