import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeFlockEntry extends StatefulWidget {
  @override
  HomeFlockEntryState createState() => HomeFlockEntryState();
}

class HomeFlockEntryState extends State<HomeFlockEntry> {

  final TextEditingController bagsUsed = TextEditingController();
  final TextEditingController eggsController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Home flock data',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            TextField(
              controller: eggsController,
              decoration: InputDecoration(labelText: 'Number of eggs collected'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty && double.tryParse(value) == null) {
                  eggsController.text = value.substring(0, value.length - 1);
                }
              },
            ),

            SizedBox(height: 20),

            TextField(
              controller: bagsUsed,
              decoration: InputDecoration(labelText: 'Food sacks used'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty && double.tryParse(value) == null) {
                  bagsUsed.text = value.substring(0, value.length - 1);
                }
              },
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
                FirebaseFirestore.instance.collection('HomeFlock').add({
                  'Eggs': eggsController.text,
                  'Bags used': bagsUsed.text,
                  'Date': dateController.text,
                });

                bagsUsed.clear();
                eggsController.clear();
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