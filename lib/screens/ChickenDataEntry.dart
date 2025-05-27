import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChickenDataEntry extends StatelessWidget {
  final TextEditingController eggCountController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
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
              'Chicken Data',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            TextField(
              controller: eggCountController,
              decoration: InputDecoration(labelText: 'Number of eggs collected'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty && double.tryParse(value) == null) {
                  eggCountController.text = value.substring(0, value.length - 1);
                }
              },
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location of the chickens'),
            ),
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
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes/things to add'),
            ),
            ElevatedButton(
              onPressed: () {
                if (eggCountController.text.isNotEmpty && locationController.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection('ChickenData').add({
                    'Number of eggs': int.parse(eggCountController.text),
                    'Location of the Chickens': locationController.text,
                    'Date': dateController.text,
                    'Notes': notesController.text,
                  });
                  eggCountController.clear();
                  locationController.clear();
                  notesController.clear();
                  dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}