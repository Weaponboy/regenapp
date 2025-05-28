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
  final TextEditingController notesController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  bool AppleCiderVinegar = false;
  bool Calcium = false;
  bool Grit = false;
  bool Aloe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

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

            ElevatedButton(
              onPressed: () {
                if (eggCountController.text.isNotEmpty) {
                  FirebaseFirestore.instance.collection('ChickenData').add({
                    'Number of eggs': int.parse(eggCountController.text),
                    'Mortality?': mortalityController.text,
                    'Date': dateController.text,
                    'Notes': notesController.text,
                    'Calcium': Calcium,
                    'Grit': Grit,
                    'Aloe': Aloe,
                    'AppleCiderVinegar': AppleCiderVinegar,

                  });
                  setState(() {
                    eggCountController.clear();
                    mortalityController.clear();
                    notesController.clear();
                    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    Calcium = false;
                    Grit = false;
                    Aloe = false;
                    AppleCiderVinegar = false;
                  });

                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}