import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class SlaughterEntry extends StatefulWidget {
  @override
  SlaughterEntryState createState() => SlaughterEntryState();
}

class SlaughterEntryState extends State<SlaughterEntry> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController useController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  num Id = 0;
  String? animal;
  List<String> animals = ["Cow", "Sheep", "Pig"];

  @override
  void initState() {
    super.initState();
    getDocumentCount();
  }

  void getDocumentCount() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Carcasses').get();
    Id = snapshot.docs.length + 1;
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
              'Slaughter entry',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            DropdownButton<String>(
              isExpanded: true,
              value: animal,
              hint: Text('Animal type'),
              items: animals.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  animal = newValue;
                });
              },
            ),

            SizedBox(height: 20),

            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Animal name (if applicable)'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Animal description'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: useController,
              decoration: InputDecoration(labelText: 'Carcass intention'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Carcass weight'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (value.isNotEmpty && double.tryParse(value) == null) {
                  weightController.text = value.substring(0, value.length - 1);
                }
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
                  dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                }
              },
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                FirebaseFirestore.instance.collection('Carcasses').add({
                  'ID': Id,
                  'Animal type': animal,
                  'Name': nameController.text,
                  'Description': descriptionController.text,
                  'Use': useController.text,
                  'Weight': weightController.text,
                  'Notes': notesController.text,
                  'date': dateController.text,
                });

                setState(() {
                  Id++;
                  animal = null;
                  nameController.clear();
                  descriptionController.clear();
                  useController.clear();
                  weightController.clear();
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