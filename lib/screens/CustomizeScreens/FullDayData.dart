import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MultiCollectionDateSearchScreen extends StatefulWidget {
  @override
  _MultiCollectionDateSearchScreenState createState() => _MultiCollectionDateSearchScreenState();
}

class _MultiCollectionDateSearchScreenState extends State<MultiCollectionDateSearchScreen> {
  DateTime? _selectedDate;
  final List<String> _collections = ['ChickenData', 'CowData', 'HomeFlock', 'DairyData'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Date Search")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
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
          ),
          Expanded(
            child: _selectedDate == null
                ? Center(child: Text("Please select a date"))
                : FutureBuilder<List<QuerySnapshot>>(
              future: Future.wait(
                _collections.map(
                      (collection) => FirebaseFirestore.instance
                      .collection(collection)
                      .where('Date', isEqualTo: DateFormat('yyyy-MM-dd').format(_selectedDate!))
                      .get(),
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                final allDocs = snapshot.data?.expand((query) => query.docs).toList() ?? [];
                if (allDocs.isEmpty) {
                  return Center(child: Text("No documents found"));
                }
                return ListView.builder(
                  itemCount: allDocs.length,
                  itemBuilder: (context, index) {
                    final doc = allDocs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    // Exclude the 'date' field
                    final fields = data.entries.where((entry) => entry.key != 'Date').toList();
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.reference.parent.path.split('/').last,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            ...fields.map(
                                  (entry) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 4),
                                child: Text("${entry.key}: ${entry.value}"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}