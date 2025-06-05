import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:regendataapp/LoginCode/CurrentUserData.dart';

class TasksEntry extends StatefulWidget {

  final currentUserData userData;
  TasksEntry({required this.userData});

  @override
  TasksEntryState createState() => TasksEntryState(userData: userData);
}

class TasksEntryState extends State<TasksEntry> {

  final TextEditingController TaskController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  List<String> _selectedUsers = [];
  List<String> _users = [];
  String? urgency;
  List<String> urgencyLevel = ["High", "Medium", "Low"];
  final _multiSelectKey = GlobalKey<FormFieldState>(); // Keep for potential form validation

  final currentUserData userData;
  TasksEntryState({required this.userData});

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      _users = snapshot.docs.map((doc) => doc['username'] as String).toList();
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
              'Task entry',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            TextField(
              controller: TaskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            SizedBox(height: 20),
            MultiSelectDialogField(
              key: _multiSelectKey,
              items: _users
                  .map((email) => MultiSelectItem<String>(email, email))
                  .toList(),
              initialValue: _selectedUsers, // Bind to _selectedUsers
              title: Text('Select Users'),
              selectedColor: Colors.blue,
              buttonText: Text('Select Users'),
              onConfirm: (List<String> values) {
                setState(() {
                  _selectedUsers = values;
                });
              },
              chipDisplay: MultiSelectChipDisplay(
                items: _selectedUsers
                    .map((email) => MultiSelectItem<String>(email, email))
                    .toList(),
                onTap: (value) {
                  setState(() {
                    _selectedUsers.remove(value);
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              isExpanded: true,
              value: urgency,
              hint: Text('Urgency level'),
              items: urgencyLevel.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  urgency = newValue;
                });
              },
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
                FirebaseFirestore.instance.collection('Tasks').add({
                  'Task': TaskController.text,
                  'UrgencyLevel': urgency,
                  'Assigned Users': _selectedUsers,
                  'Created by': userData.username,
                  'Date': dateController.text,
                });
                setState(() {
                  TaskController.clear();
                  urgency = null;
                  _selectedUsers = []; // Clear selected users
                  dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  _multiSelectKey.currentState?.reset(); // Force reset form field
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