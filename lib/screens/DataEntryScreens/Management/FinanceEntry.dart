import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FinanceEntry extends StatefulWidget {
  @override
  FinanceEntryState createState() => FinanceEntryState();
}


class FinanceEntryState extends State<FinanceEntry> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController personController = TextEditingController();
  final TextEditingController whatController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  String? cash;
  List<String> options = ["In", "Out"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cash entry',
              style: TextStyle(fontSize: 30, color: Colors.black),
            ),

            SizedBox(height: 20),

            DropdownButton<String>(
              isExpanded: true,
              value: cash,
              hint: Text('In or Out'),
              items: options.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  cash = newValue;
                });
              },
            ),

            SizedBox(height: 20),

            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Amount (Rand)'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: personController,
              decoration: InputDecoration(labelText: 'What was it for?'),
            ),

            SizedBox(height: 20),

            TextField(
              controller: whatController,
              decoration: InputDecoration(labelText: 'Why?'),
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

                FirebaseFirestore.instance.collection('Cash').add({
                  'Amount': amountController.text,
                  'In or Out': cash,
                  'What for': personController.text,
                  'Why': whatController.text,
                  'Date': dateController.text,
                });
                setState(() {
                  cash = null;
                  amountController.clear();
                  personController.clear();
                  whatController.clear();
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