import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FinanceEntry extends StatefulWidget {
  @override
  FinanceEntryState createState() => FinanceEntryState();
}


class FinanceEntryState extends State<FinanceEntry> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));

  String? cash;
  List<String> options = ["In", "Out"];

  String? _selectedItem;
  List<String> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('CashCategories').get();
    setState(() {
      _items = snapshot.docs.map((doc) => doc['category'] as String).toList();
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

            DropdownButton<String>(
              isExpanded: true,
              value: _selectedItem,
              hint: Text('Select category'),
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
              controller: DescriptionController,
              decoration: InputDecoration(labelText: 'Description?'),
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
                  'Category': _selectedItem,
                  'Description': DescriptionController.text,
                  'Date': dateController.text,
                });
                setState(() {
                  cash = null;
                  amountController.clear();
                  _selectedItem = null;
                  DescriptionController.clear();
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