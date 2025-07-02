import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BeefEntry extends StatefulWidget {
  @override
  BeefEntryState createState() => BeefEntryState();
}

class BeefEntryState extends State<BeefEntry> {

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
  final TextEditingController noteController = TextEditingController();

  String? _selectedItem;
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Fields').get();
    setState(() {
      _items = snapshot.docs.map((doc) => doc['Location'] as String).toList();
    });
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
              'Beef Cow Data',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            DropdownButton<String>(
              isExpanded: true,
              value: _selectedItem,
              hint: Text('Select a location'),
              items: _items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedItem = newValue;
                });
              },
            ),

            SizedBox(height: 20),

            TextField(
              controller: noteController,
              decoration: InputDecoration(labelText: 'Notes'),
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

                FirebaseFirestore.instance.collection('BeefData').add({
                  'Location': _selectedItem,
                  'Date': date,
                  'Notes': noteController.text
                });
                setState(() {
                  _selectedItem = null;
                  noteController.clear();
                  _selectedItem = null;
                  _selectedDate = DateTime.now();
                  date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                });

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