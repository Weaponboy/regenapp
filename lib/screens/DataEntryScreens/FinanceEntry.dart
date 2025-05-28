import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FinanceEntry extends StatelessWidget {
  final TextEditingController milkController = TextEditingController();
  final TextEditingController cowsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
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
              'Cow Data',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),
            TextField(
              controller: milkController,
              decoration: InputDecoration(labelText: 'Amount of milk'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty && double.tryParse(value) == null) {
                  milkController.text = value.substring(0, value.length - 1);
                }
              },
            ),
            TextField(
              controller: cowsController,
              decoration: InputDecoration(labelText: 'Cows milked'),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location of the cows'),
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
            ElevatedButton(
              onPressed: () {
                if (milkController.text.isNotEmpty && cowsController.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection('CowData').add({
                    'Amount of milk': int.parse(milkController.text),
                    'Cows milked': cowsController.text,
                    'Location of the cows': locationController.text,
                    'Date': dateController.text,
                  });
                  milkController.clear();
                  cowsController.clear();
                  locationController.clear();
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