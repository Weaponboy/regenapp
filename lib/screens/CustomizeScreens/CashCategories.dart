import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CashCategories extends StatefulWidget {
  const CashCategories({super.key});

  @override
  State<CashCategories> createState() => CashCategoriesState();
}

class CashCategoriesState extends State<CashCategories> {

  final _firestore = FirebaseFirestore.instance;
  final _cutController = TextEditingController();

  @override
  void dispose() {
    _cutController.dispose();
    super.dispose();
  }

  void _addCut(String cut) async {
    if (cut.isNotEmpty) {
      await _firestore.collection('CashCategories').add({'category': cut});
      _cutController.clear();
    }
  }

  void _updateCut(String docId, String newCut) async {
    if (newCut.isNotEmpty) {
      await _firestore.collection('CashCategories').doc(docId).update({'category': newCut});
    }
  }

  void _deleteCut(String docId) async {
    await _firestore.collection('CashCategories').doc(docId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CashCategories')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('CashCategories').snapshots(),
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
                final cut = doc['category'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(text: cut),
                          decoration: const InputDecoration(
                            labelText: 'Category Name',
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
                        labelText: 'New Category',
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