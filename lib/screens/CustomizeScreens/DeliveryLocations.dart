import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryLocations extends StatefulWidget {
  const DeliveryLocations({super.key});

  @override
  State<DeliveryLocations> createState() => DeliveryLocationsState();
}

class DeliveryLocationsState extends State<DeliveryLocations> {
  final _firestore = FirebaseFirestore.instance;
  final _cutController = TextEditingController();

  @override
  void dispose() {
    _cutController.dispose();
    super.dispose();
  }

  void _addCut(String location) async {
    if (location.isNotEmpty) {
      await _firestore.collection('DeliveryLocations').add({'Location': location});
      _cutController.clear();
    }
  }

  void _updateCut(String docId, String newCut) async {
    if (newCut.isNotEmpty) {
      await _firestore.collection('DeliveryLocations').doc(docId).update({'Location': newCut});
    }
  }

  void _deleteCut(String docId) async {
    await _firestore.collection('DeliveryLocations').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery locations')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('DeliveryLocations').snapshots(),
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
                final cut = doc['Location'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: cut),
                          decoration: const InputDecoration(
                            labelText: 'Delivery Location',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) => _updateCut(docId, value),
                        ),
                      ),
                      const SizedBox(width: 8),
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
                        labelText: 'New Delivery Location',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) => _addCut(value),
                    ),
                  ),
                  const SizedBox(width: 8),
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