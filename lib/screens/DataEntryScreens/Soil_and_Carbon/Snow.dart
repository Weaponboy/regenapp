import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Snow extends StatelessWidget {

  final TextEditingController snowController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Snow',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            TextField(
              controller: snowController,
              decoration: InputDecoration(labelText: 'How heavy?'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.datetime,
              onChanged: (value) {
                if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                  dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                }
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Snow').add({
                  'Snow description': snowController.text,
                  'Date': dateController.text,
                });
                snowController.clear();
                dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}