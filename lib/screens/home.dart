import 'package:flutter/material.dart';
import 'package:regendataapp/CustomDisplays/InfoCardHome.dart';
import 'package:regendataapp/screens/ChickenDataEntry.dart';
import 'package:regendataapp/screens/CowDataEntry.dart';

class HomeScreen extends StatelessWidget{

  // Sample data for scalability
  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Card 1', 'description': 'Description for card 1', 'icon': Icons.star},
    {'id': '2', 'title': 'Card 2', 'description': 'Description for card 2', 'icon': Icons.favorite},
  ];

  void _navigateToPage(BuildContext context, String id) {
    Widget destinationPage;
    switch (id) {
      case '1':
        destinationPage = CowDataEntry();
        break;
      case '2':
        destinationPage = ChickenDataEntry();
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
    return Scaffold(
      body: ListView.builder(
        itemCount: cardData.length,
        itemBuilder: (context, index) {
          return InfoCardHome(
            id: cardData[index]['id'],
            title: cardData[index]['title'],
            description: cardData[index]['description'],
            icon: cardData[index]['icon'],
            onTap: () => _navigateToPage(context, cardData[index]['id']),
          );
        },
      ),
    );
    throw UnimplementedError();
  }
}