import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class EggsEntry extends StatefulWidget {
  @override
  EggsEntrStatey createState() => EggsEntrStatey();
}


class EggsEntrStatey extends State<EggsEntry> {

  final TextEditingController eggCountController = TextEditingController();
  final TextEditingController mortalityController = TextEditingController();
  final TextEditingController sacksUsedController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController manHours = TextEditingController();
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

  bool AppleCiderVinegar = false;
  bool Calcium = false;
  bool Grit = false;
  bool Aloe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120),

              Text(
                'Chicken Data',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),

              SizedBox(height: 20),

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

              SizedBox(height: 20),

              TextField(
                controller: mortalityController,
                decoration: InputDecoration(labelText: 'Mortality?'),
              ),

              SizedBox(height: 20),

              TextField(
                controller: sacksUsedController,
                decoration: InputDecoration(labelText: 'Food sacks used'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty && double.tryParse(value) == null) {
                    sacksUsedController.text = value.substring(0, value.length - 1);
                  }
                },
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: AppleCiderVinegar,
                    onChanged: (bool? value) {
                      setState(() {
                        AppleCiderVinegar = value ?? false;
                      });
                    },
                  ),
                  Text('Apple Cider Vinegar'),
                  Checkbox(
                    value: Calcium,
                    onChanged: (bool? value) {
                      setState(() {
                        Calcium = value ?? false;
                      });
                    },
                  ),
                  Text('Calcium'),
                ],
              ),

              Row(
                children: [
                  Checkbox(
                    value: Grit,
                    onChanged: (bool? value) {
                      setState(() {
                        Grit = value ?? false;
                      });
                    },
                  ),
                  Text('Grit'),
                  Checkbox(
                    value: Aloe,
                    onChanged: (bool? value) {
                      setState(() {
                        Aloe = value ?? false;
                      });
                    },
                  ),
                  Text('Aloe'),
                ],
              ),

              SizedBox(height: 20),

              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: 'Notes/things to add'),
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

              Text(
                'Eggs Man Hours',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),

              SizedBox(height: 20),

              TextField(
                controller: manHours,
                decoration: InputDecoration(labelText: 'Man hours (mins)'),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {

                  String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                  if (eggCountController.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('ChickenData').add({
                      'Number of eggs': int.parse(eggCountController.text),
                      'Mortality?': mortalityController.text,
                      'Sacks used': sacksUsedController.text,
                      'Date': date,
                      'Notes': notesController.text,
                      'Calcium': Calcium,
                      'Grit': Grit,
                      'Aloe': Aloe,
                      'AppleCiderVinegar': AppleCiderVinegar,
                    });

                    setState(() {
                      eggCountController.clear();
                      mortalityController.clear();
                      sacksUsedController.clear();
                      notesController.clear();
                      Calcium = false;
                      Grit = false;
                      Aloe = false;
                      AppleCiderVinegar = false;
                    });
                  }

                  if (manHours.text.isNotEmpty) {
                    FirebaseFirestore.instance.collection('ManHours').add({
                      'Enterprise': 'Eggs',
                      'ManHours': manHours.text,
                      'Date': date,
                    });
                    setState(() {
                      manHours.clear();
                    });
                  }

                  setState(() {
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
      ),
    );
  }
}