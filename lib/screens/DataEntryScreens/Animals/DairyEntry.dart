import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DairyEntry extends StatefulWidget {
  @override
  _DairyEntryState createState() => _DairyEntryState();
}

class _DairyEntryState extends State<DairyEntry> {

  final TextEditingController milkController = TextEditingController();
  final TextEditingController cowsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController feedSupController = TextEditingController();

  final TextEditingController dateController =
  TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  String? _selectedItem;
  List<String> _items = [];

  String? manHours;
  List<String> timeIncrements = ["10min", "20min", "30min", "40min", "50min", "60min"];

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
      body: SingleChildScrollView( // Add this
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),

              Text(
                'Dairy Cow Data',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),

              SizedBox(height: 20),

              TextField(
                controller: milkController,
                decoration: InputDecoration(labelText: 'Litres of milk'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  if (value.isNotEmpty && double.tryParse(value) == null) {
                    milkController.text = value.substring(0, value.length - 1);
                  }
                },
              ),

              SizedBox(height: 20),

              TextField(
                controller: cowsController,
                decoration: InputDecoration(labelText: 'Number of cows milked'),
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
                controller: feedSupController,
                decoration: InputDecoration(labelText: 'Feed supplements'),
              ),

              SizedBox(height: 20),

              DropdownButton<String>(
                isExpanded: true,
                value: manHours,
                hint: Text('Time spent milking'),
                items: timeIncrements.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    manHours = newValue;
                  });
                },
              ),

              SizedBox(height: 20),

              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes/things to add'),
              ),

              SizedBox(height: 20),

              TextField(
                controller: dateController,
                decoration: InputDecoration(labelText: 'Date'),
                keyboardType: TextInputType.datetime,
                onChanged: (value) {
                  if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                    dateController.text =
                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                  }
                },
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (milkController.text.isNotEmpty &&
                      cowsController.text.isNotEmpty &&
                      _selectedItem != null) {
                    FirebaseFirestore.instance.collection('DairyData').add({
                      'Amount of milk': double.parse(milkController.text),
                      'Cows milked': cowsController.text,
                      'Location of the cows': _selectedItem,
                      'Feed supplements': feedSupController.text,
                      'Time spent milking': manHours,
                      'Notes': notesController.text,
                      'Date': dateController.text,
                    });
                    setState(() {
                      milkController.clear();
                      cowsController.clear();
                      notesController.clear();
                      feedSupController.clear();
                      _selectedItem = null;
                      manHours = null;
                      dateController.text =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}