import 'package:flutter/material.dart';
import 'package:regendataapp/Colors.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/Beans/BeanInputs.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/Beans/WorkDone.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/BeansEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/BeefEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/DucksEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/EggsEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/DairyEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/HomeFlockEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/PigsEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Animals/TurkeyEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Management/SlaughterEntry.dart';
import 'package:regendataapp/screens/DataEntryScreens/Management/TasksEntry.dart';
import 'dart:math';

import '../../../LoginCode/CurrentUserData.dart';

class BeansEntry extends StatelessWidget {

  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Inputs'},
    {'id': '2', 'title': 'Work done'},
    {'id': '3', 'title': 'Irrigation'},
    {'id': '4', 'title': 'Turkeys'}
  ];

  final currentUserData userData;
  BeansEntry({required this.userData});

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = BeanInput(userData: userData);
        break;
      case '2':
        destinationPage = BeanWorkDone(userData: userData);
        break;
      case '3':
        destinationPage = EggsEntry();
        break;
      case '4':
        destinationPage = TurkeyEntry();
        break;
      case '5':
        destinationPage = DucksEntry();
        break;
      case '6':
        destinationPage = PigsEntry();
        break;
      case '7':
        destinationPage = HomeFlockEntry();
        break;
      case '8':
        destinationPage = BeansEntry(userData: userData);
        break;
      default:
        destinationPage = BeansEntry(userData: userData);
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
            image: AssetImage('assets/cow.jpg'),
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
                  'Enterprises',
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
              final y = (centerY + radius * sin(angle) - circleSize / 2) + 60;

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