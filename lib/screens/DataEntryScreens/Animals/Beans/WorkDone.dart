import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../LoginCode/CurrentUserData.dart';

class BeanWorkDone extends StatefulWidget {

  final currentUserData userData;
  BeanWorkDone({required this.userData});

  @override
  _BeansEntryState createState() => _BeansEntryState(userData: userData);
}

class _BeansEntryState extends State<BeanWorkDone> {

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Man Hours',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

                      if (manHours.text.isNotEmpty) {
                        FirebaseFirestore.instance.collection('ManHours').add({
                          'Enterprise': 'Beans',
                          'ManHours': manHours.text,
                          'Worker': userData.username,
                          'Task': task,
                          'Date': date,
                        });
                        setState(() {
                          manHours.clear();
                          task = null;
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

              DropdownButton<String>(
                isExpanded: true,
                value: task,
                hint: Text('Task'),
                items: options.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    task = newValue;
                  });
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
            ],
          ),
        ),
      ),
    );
  }
}