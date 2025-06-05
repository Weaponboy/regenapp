import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ButcheryEntry extends StatefulWidget {
  const ButcheryEntry({super.key});

  @override
  ButcheryEntryState createState() => ButcheryEntryState();
}

class ButcheryEntryState extends State<ButcheryEntry> {
  
  final TextEditingController dateController =
  TextEditingController(text: DateFormat('yyyy-MM-dd').format(DateTime.now()));
  final _firestore = FirebaseFirestore.instance;
  String? _selectedItem;
  List<String> _items = [];
  Map<String, TextEditingController> _cutControllers = {};

  @override
  void initState() {
    super.initState();
    getCarcasses();
    getCuts();
  }

  @override
  void dispose() {
    dateController.dispose();
    _cutControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> getCarcasses() async {
    QuerySnapshot snapshot = await _firestore
        .collection('Carcasses')
        .where('Animal type', isEqualTo: 'Cow')
        .get();
    setState(() {
      _items = snapshot.docs.map((doc) => '${doc['ID']} + ${doc['Name']}').toList();
    });
  }

  Future<void> getCuts() async {
    QuerySnapshot snapshot = await _firestore.collection('BeefCuts').get();
    setState(() {
      _cutControllers = {
        for (var doc in snapshot.docs)
          doc['Cut']: TextEditingController()
      };
    });
  }

  Future<void> _loadExistingData(String? selectedItem) async {
    if (selectedItem == null) {
      _cutControllers.forEach((_, controller) => controller.clear());
      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      return;
    }

    QuerySnapshot existingDocs = await _firestore
        .collection('butcheredBeef')
        .where('ID', isEqualTo: selectedItem)
        .get();

    if (existingDocs.docs.isNotEmpty) {
      var docData = existingDocs.docs.first.data() as Map<String, dynamic>;
      setState(() {
        dateController.text = docData['Date'] ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
        _cutControllers.forEach((cut, controller) {
          var value = docData['${cut}_value'];
          controller.text = value != null ? value.toString() : '';
        });
      });
    } else {
      setState(() {
        _cutControllers.forEach((_, controller) => controller.clear());
        dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      });
    }
  }

  Future<void> _submitData() async {
    if (_selectedItem != null) {
      Map<String, dynamic> data = {
        'ID': _selectedItem,
        'Date': dateController.text,
      };
      _cutControllers.forEach((cut, controller) {
        if (controller.text.isNotEmpty) {
          data['${cut}_value'] = double.tryParse(controller.text) ?? 0.0;
        }
      });

      QuerySnapshot existingDocs = await _firestore
          .collection('butcheredBeef')
          .where('ID', isEqualTo: _selectedItem)
          .get();

      if (existingDocs.docs.isNotEmpty) {
        await _firestore
            .collection('butcheredBeef')
            .doc(existingDocs.docs.first.id)
            .update(data);
      } else {
        await _firestore.collection('butcheredBeef').add(data);
      }

      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
        // _cutControllers.forEach((_, controller) => controller.clear());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    'Beef butchery data',
                    style: TextStyle(fontSize: 30, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedItem,
                  hint: const Text('Select a carcass'),
                  items: _items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Center(child: Text(item)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue;
                      _loadExistingData(newValue);
                    });
                  },
                  alignment: Alignment.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  keyboardType: TextInputType.datetime,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                    }
                  },
                ),
                const SizedBox(height: 20),
                ..._cutControllers.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: TextField(
                      controller: entry.value,
                      decoration: InputDecoration(
                        labelText: entry.key,
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitData,
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}