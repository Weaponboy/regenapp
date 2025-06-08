import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManHoursScreen extends StatefulWidget {
  @override
  _ManHoursScreenState createState() => _ManHoursScreenState();
}

class _ManHoursScreenState extends State<ManHoursScreen> {
  String? selectedMonth;
  Map<String, double> enterpriseHours = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Text(
                  'Man Hours',
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
                DropdownButton<String>(
                  hint: Text('Select Month'),
                  value: selectedMonth,
                  items: ['2025-06', '2025-07'].map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMonth = newValue;
                      enterpriseHours.clear();
                    });
                  },
                ),
              ]
            ),

            selectedMonth != null
                ? Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('ManHours')
                    .where('Date', isGreaterThanOrEqualTo: '$selectedMonth-01')
                    .where('Date', isLessThan: '${selectedMonth}-31')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  enterpriseHours = {};
                  snapshot.data!.docs.forEach((doc) {
                    String enterprise = doc['Enterprise'];
                    double minutes = double.parse(doc['ManHours']);
                    double hours = minutes / 60;
                    enterpriseHours[enterprise] = ((enterpriseHours[enterprise] ?? 0) + hours);
                  });
                  return ListView.builder(
                    itemCount: enterpriseHours.length,
                    itemBuilder: (context, index) {
                      String enterprise = enterpriseHours.keys.elementAt(index);
                      return ListTile(
                        title: Text('$enterprise: ${enterpriseHours[enterprise]?.toStringAsFixed(2)} hours'),
                      );
                    },
                  );
                },
              ),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}