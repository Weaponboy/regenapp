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

  DateTime? _selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

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

            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? "Select a date"
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text("Pick Date"),
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                FirebaseFirestore.instance.collection('HomeFlock').add({
                  'Eggs': eggsController.text,
                  'Bags used': bagsUsed.text,
                  'Date': date,
                });

                bagsUsed.clear();
                eggsController.clear();
                _selectedDate = DateTime.now();
                date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                Navigator.pop(context);

              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}