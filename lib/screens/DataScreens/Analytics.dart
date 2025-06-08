import 'package:flutter/material.dart';
import 'package:regendataapp/Colors.dart';
import 'package:regendataapp/screens/DataScreens/FullDayData.dart';
import 'package:regendataapp/screens/DataScreens/ManHours.dart';
import 'package:regendataapp/screens/DataScreens/dairyGraphing.dart';
import 'dart:math';
import 'package:regendataapp/screens/DataScreens/eggGraphing.dart';

class Analytics extends StatelessWidget {

  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Day entries'},
    {'id': '2', 'title': 'Egg graphs'},
    {'id': '3', 'title': 'Dairy graphs'},
    {'id': '4', 'title': 'Man hours'},
    {'id': '5', 'title': 'Profit'},
    {'id': '6', 'title': 'Stock'},
  ];

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = MultiCollectionDateSearchScreen();
        break;
      case '2':
        destinationPage = EggGraphing();
        break;
      case '3':
        destinationPage = DairyGraphing();
        break;
      case '4':
        destinationPage = ManHoursScreen();
        break;
      default:
        destinationPage = Analytics();
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width * 0.3; // Radius of the large circle
    final circleSize = 80.0; // Size of each small circle

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/data2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Title
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Roboto', // Ensure Roboto is in pubspec.yaml
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
            // Circles
            ...List.generate(cardData.length, (index) {
              final angle = 2 * pi * index / cardData.length;
              final x = (centerX + radius * cos(angle) - circleSize / 2);
              final y = (centerY + radius * sin(angle) - circleSize / 2) + 40;

              return Positioned(
                left: x,
                top: y,
                child: GestureDetector(
                  onTap: () => _navigateToPage(context, cardData[index]['id']),
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
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        cardData[index]['title'],
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
              );
            }),
          ],
        ),
      ),
    );
  }
}