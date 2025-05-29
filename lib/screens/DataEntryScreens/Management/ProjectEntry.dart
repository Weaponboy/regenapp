import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProjectEntry extends StatefulWidget {
  @override
  ProjectEntryState createState() => ProjectEntryState();
}

class ProjectEntryState extends State<ProjectEntry> {

  final TextEditingController ProjectController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

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
              'Project entry',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            TextField(
              controller: ProjectController,
              decoration: InputDecoration(labelText: 'Project'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Date'),
              keyboardType: TextInputType.datetime,
              onChanged: (value) {
                dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Projects').add({
                  'Project': ProjectController.text,
                  'Date': dateController.text,
                });
                setState(() {
                  ProjectController.clear();
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