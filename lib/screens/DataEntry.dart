import 'package:flutter/material.dart';
import 'package:regendataapp/screens/DataEntryScreens/BeefEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/ButcheryEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/ChickenDataEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/DairyEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/FinanceEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/SlaughterEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/TasksEntry.dart';
import 'package:regendataapp/screens/OutputData.dart';
import 'dart:math';

class DataEntry extends StatelessWidget {

  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Dairy cows'},
    {'id': '2', 'title': 'Beef cows'},
    {'id': '3', 'title': 'Eggs'},
    {'id': '4', 'title': 'Slaughter'},
    {'id': '5', 'title': 'Tasks'},
    {'id': '6', 'title': 'Butchery'},
    {'id': '7', 'title': 'Finances'},
  ];

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = DairyEntry();
        break;
      case '2':
        destinationPage = BeefEntry();
        break;
      case '3':
        destinationPage = EggsEntry();
        break;
      case '4':
        destinationPage = SlaughterEntry();
        break;
      case '5':
        destinationPage = TasksEntry();
        break;
      case '6':
        destinationPage = ButcheryEntry();
        break;
      case '7':
        destinationPage = EggsEntry();
        break;
      default:
        destinationPage = FinanceEntry();
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
            image: AssetImage('grass.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            // Title
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Data entry',
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
              final y = (centerY + radius * sin(angle) - circleSize / 2);

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
                      color: Colors.green,
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