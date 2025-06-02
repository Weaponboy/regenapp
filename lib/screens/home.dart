import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:regendataapp/Colors.dart';
import 'package:regendataapp/LoginCode/CurrentUserData.dart';
import 'package:regendataapp/screens/AnimalDataEntry.dart';
import 'package:regendataapp/screens/Customize.dart';
import 'package:regendataapp/screens/ManagementDataEntry.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cardData = [
    {'id': '1', 'title': 'Animals'},
    {'id': '2', 'title': 'Management'},
    {'id': '3', 'title': 'Customize'},
  ];

  final currentUserData userData;
  HomeScreen({required this.userData});

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
        destinationPage = HomeScreen(userData: userData);
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

  Future<void> _deleteTask(String taskId) async {
    await FirebaseFirestore.instance.collection('Tasks').doc(taskId).delete();
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Hello ' + userData.username,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                    child: Text(
                      'My Tasks',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: colors().taskBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Tasks')
                            .where('Assigned Users', arrayContainsAny: [userData.username, 'Team'])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final tasks = snapshot.data!.docs;
                          return ListView.builder(
                            padding: EdgeInsets.all(8.0),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              var task = tasks[index].data() as Map<String, dynamic>;
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4.0),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${task['Task']} - ${task['UrgencyLevel']}',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => _deleteTask(tasks[index].id),
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all(colors().completedRed),
                                      ),
                                      child: Text(
                                        'Completed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
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