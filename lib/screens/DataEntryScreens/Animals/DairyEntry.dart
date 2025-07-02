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

  String? _selectedItem;
  List<String> _items = [];

  final TextEditingController manHours = TextEditingController();

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Dairy Data',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                      if (milkController.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection('DairyData').add({
                          'Amount of milk': double.parse(milkController.text),
                          'Cows milked': cowsController.text,
                          'Location of the cows': _selectedItem,
                          'Notes': notesController.text,
                          'Date': date,
                        });
                        setState(() {
                          milkController.clear();
                          cowsController.clear();
                          notesController.clear();
                          _selectedItem = null;
                          _selectedDate = DateTime.now();
                          date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                  ),
                ],
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
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes/things to add'),
              ),

              SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Dairy Man Hours',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                      if (manHours.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection('ManHours').add({
                          'Enterprise': 'Dairy',
                          'ManHours': manHours.text,
                          'Date': date,
                        });
                        setState(() {
                          manHours.clear();
                          _selectedDate = DateTime.now();
                          date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                        });
                      }

                      Navigator.pop(context);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),

              SizedBox(height: 20),

              TextField(
                controller: manHours,
                decoration: InputDecoration(labelText: 'Man hours (mins)'),
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

                  if (milkController.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('DairyData').add({
                      'Amount of milk': double.parse(milkController.text),
                      'Cows milked': cowsController.text,
                      'Location of the cows': _selectedItem,
                      'Notes': notesController.text,
                      'Date': date,
                    });
                    setState(() {
                      milkController.clear();
                      cowsController.clear();
                      notesController.clear();
                      _selectedItem = null;
                    });
                  }

                  if (manHours.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('ManHours').add({
                      'Enterprise': 'Dairy',
                      'ManHours': manHours.text,
                      'Date': date,
                    });
                    setState(() {
                      manHours.clear();
                    });
                  }

                  if (manHours.text.isNotEmpty || milkController.text.isNotEmpty) {
                    setState(() {
                      _selectedDate = DateTime.now();
                      date = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                    });
                  }

                  Navigator.pop(context);
                },
                child: Text('Submit All'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}