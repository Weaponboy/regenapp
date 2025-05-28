import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OutputData extends StatefulWidget {
  @override
  _OutputDataState createState() => _OutputDataState();
}

class _OutputDataState extends State<OutputData> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  Future<QuerySnapshot<Map<String, dynamic>>>? _dataFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Output Cow Data', style: TextStyle(fontSize: 30, color: Colors.black)),
            TextField(
              controller: startDateController,
              decoration: InputDecoration(labelText: 'Start Date (yyyy-MM-dd)'),
            ),
            TextField(
              controller: endDateController,
              decoration: InputDecoration(labelText: 'End Date (yyyy-MM-dd)'),
            ),
            ElevatedButton(
              onPressed: () {
                if (startDateController.text.isNotEmpty && endDateController.text.isNotEmpty) {
                  DateTime start = DateFormat('yyyy-MM-dd').parse(startDateController.text);
                  DateTime end = DateFormat('yyyy-MM-dd').parse(endDateController.text);
                  setState(() {
                    _dataFuture = FirebaseFirestore.instance
                        .collection('CowData')
                        .where('Date', isGreaterThanOrEqualTo: start.toIso8601String().split('T')[0])
                        .where('Date', isLessThanOrEqualTo: end.toIso8601String().split('T')[0])
                        .orderBy('Date')
                        .get();
                  });
                }
              },
              child: Text('Show Data'),
            ),
            if (_dataFuture != null)
              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No data found');
                  }
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data();
                        return ListTile(
                          title: Text('Milk: ${data['Amount of milk']} | Cows: ${data['Cows milked']} | Date: ${data['Date']}'),
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}