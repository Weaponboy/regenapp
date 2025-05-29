import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SoilCarbon extends StatefulWidget {
  @override
  SoilCarbonState createState() => SoilCarbonState();
}

class SoilCarbonState extends State<SoilCarbon> {

  final TextEditingController notesController =TextEditingController();
  final TextEditingController carbonController =TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

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
              'Soil Carbon',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            TextField(
              controller: carbonController,
              decoration: InputDecoration(labelText: 'Carbon level'),
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
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes'),
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
                FirebaseFirestore.instance.collection('CarbonContent').add({
                  'Carbon level': carbonController.text,
                  'Field': _selectedItem,
                  'Notes': notesController.text,
                  'Date': dateController.text,
                });
                setState(() {
                  _selectedItem = null;
                  carbonController.clear();
                  notesController.clear();
                  dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                });
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}