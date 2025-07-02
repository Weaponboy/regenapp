import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => CustomerState();
}

class CustomerState extends State<Customers> {
  final _firestore = FirebaseFirestore.instance;
  final _cutController = TextEditingController();
  Map<String, String?> _selectedLocations = {};
  List<String> _items = [];

  @override
  void dispose() {
    _cutController.dispose();
    super.dispose();
  }

  void _addCut(String cut) async {
    if (cut.isNotEmpty && _selectedLocations['new'] != null) {
      await _firestore.collection('Customers').add({
        'Customer': cut,
        'Location': _selectedLocations['new'], // Stores location from DeliveryLocations
      });
      _cutController.clear();
      setState(() => _selectedLocations['new'] = null);
    }
  }

  void _updateCut(String docId, String newCut) async {
    if (newCut.isNotEmpty) {
      await _firestore.collection('Customers').doc(docId).update({
        'Customer': newCut,
        'Location': _selectedLocations[docId],
      });
    }
  }

  void _deleteCut(String docId) async {
    await _firestore.collection('Customers').doc(docId).delete();
    setState(() => _selectedLocations.remove(docId));
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot = await _firestore.collection('DeliveryLocations').get();
    setState(() {
      _items = snapshot.docs.map((doc) => doc['Location'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('Customers').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final cuts = snapshot.data!.docs;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...cuts.map((doc) {
                final docId = doc.id;
                final cut = doc['Customer'] as String;
                final location = doc['Location'] as String?;
                _selectedLocations[docId] ??= location;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: cut),
                          decoration: const InputDecoration(
                            labelText: 'Customer Name',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) => _updateCut(docId, value),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedLocations[docId],
                          hint: const Text('Location'),
                          items: _items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedLocations[docId] = newValue;
                            });
                            _updateCut(docId, cut); // Update Firestore with new location
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCut(docId),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cutController,
                      decoration: const InputDecoration(
                        labelText: 'New Customer',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => _addCut(value),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedLocations['new'],
                      hint: const Text('Location'),
                      items: _items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLocations['new'] = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () => _addCut(_cutController.text),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}