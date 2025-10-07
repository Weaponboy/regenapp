import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../LoginCode/CurrentUserData.dart';

class BeanInput extends StatefulWidget {

  final currentUserData userData;
  BeanInput({required this.userData});

  @override
  _BeansEntryState createState() => _BeansEntryState(userData: userData);
}

class _BeansEntryState extends State<BeanInput> {

  final TextEditingController beanInputController = TextEditingController();
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

  final currentUserData userData;
  _BeansEntryState({required this.userData});

  String? task;
  List<String> options = ["Ground prep", "Irrigation", "Week control", "Inputs", "Harvest", "General"];

  final TextEditingController manHours = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 90),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Inputs',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                      if (beanInputController.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection('BeanInputs').add({
                          'Input': double.parse(beanInputController.text),
                          'Notes': notesController.text,
                          'Date': date,
                        });
                        setState(() {
                          beanInputController.clear();
                          notesController.clear();
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
                controller: beanInputController,
                decoration: InputDecoration(labelText: 'Input type'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  if (value.isNotEmpty && double.tryParse(value) == null) {
                    beanInputController.text = value.substring(0, value.length - 1);
                  }
                },
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
            ],
          ),
        ),
      ),
    );
  }
}