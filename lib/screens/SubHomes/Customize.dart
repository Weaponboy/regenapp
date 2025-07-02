import 'package:flutter/material.dart';
import 'package:regendataapp/Colors.dart';
import 'package:regendataapp/screens/CustomizeScreens/CashCategories.dart';
import 'package:regendataapp/screens/CustomizeScreens/Customers.dart';
import 'package:regendataapp/screens/CustomizeScreens/DeliveryLocations.dart';
import 'package:regendataapp/screens/CustomizeScreens/Fields.dart';
import 'package:regendataapp/screens/CustomizeScreens/Products.dart';
import 'package:regendataapp/screens/DataScreens/FullDayData.dart';
import 'package:regendataapp/screens/CustomizeScreens/MeatCuts.dart';
import 'dart:math';
import 'package:regendataapp/screens/DataScreens/eggGraphing.dart';

class Customize extends StatelessWidget {

  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Meat cuts'},
    {'id': '2', 'title': 'Users'},
    {'id': '3', 'title': 'Fields'},
    {'id': '4', 'title': 'Cash categories'},
    {'id': '5', 'title': 'Customers'},
    {'id': '6', 'title': 'Delivery locations'},
    {'id': '7', 'title': 'Products'},
  ];

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = MeatCutsScreen();
        break;
      case '2':
        destinationPage = EggGraphing();
        break;
      case '3':
        destinationPage = Fields();
        break;
      case '4':
        destinationPage = CashCategories();
        break;
      case '5':
        destinationPage = Customers();
        break;
      case '6':
        destinationPage = DeliveryLocations();
        break;
      case '7':
        destinationPage = Products();
        break;
      default:
        destinationPage = Customize();
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
            image: AssetImage('assets/wheat.jpeg'),
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
                  'Customize',
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