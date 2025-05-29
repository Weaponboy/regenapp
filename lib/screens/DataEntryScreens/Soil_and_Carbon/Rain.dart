import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Rain extends StatelessWidget {

  final TextEditingController rainController = TextEditingController();
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
              'Rain',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            TextField(
              controller: rainController,
              decoration: InputDecoration(labelText: 'Amount of rain (mm)'),
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
                FirebaseFirestore.instance.collection('Rain').add({
                  'Amount of rain': rainController.text,
                  'Date': dateController.text,
                });
                rainController.clear();
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