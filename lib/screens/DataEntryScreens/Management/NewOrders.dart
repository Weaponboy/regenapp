import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class NewOrderScreen extends StatefulWidget {
  const NewOrderScreen({super.key});

  @override
  _NewOrderScreenState createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  DateTime? _selectedDate = DateTime.now();
  String? _selectedItem;
  List<String> _items = [];
  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomer;
  String? _customerLocation;
  List<Map<String, dynamic>> _products = [];
  final _quantityController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  int getWeekNumber(DateTime date) {
    return date.weekOfYear;
  }

  Stream<QuerySnapshot> getCustomers() {
    return _firestore.collection('Customers').snapshots();
  }

  void _addProduct() {
    if (_quantityController.text.isNotEmpty && _selectedItem != null) {
      setState(() {
        _products.add({
          'name': _selectedItem,
          'quantity': int.parse(_quantityController.text),
        });
        _selectedItem = null;
        _quantityController.clear();
      });
    }
  }

  Future<void> _editProduct(int index) async {
    final product = _products[index];
    _selectedItem = product['name'];
    _quantityController.text = product['quantity'].toString();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedItem,
                hint: const Text('Select a product'),
                decoration: const InputDecoration(
                  labelText: 'Product',
                  border: OutlineInputBorder(),
                ),
                items: _items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedItem = value),
                validator: (value) => value == null ? 'Select a product' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_selectedItem != null && _quantityController.text.isNotEmpty) {
                  setState(() {
                    _products[index] = {
                      'name': _selectedItem!,
                      'quantity': int.parse(_quantityController.text),
                    };
                    _selectedItem = null;
                    _quantityController.clear();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveOrder(BuildContext context) async {
    if (_selectedCustomer != null && _selectedDate != null && _products.isNotEmpty) {
      try {
        final weekNumber = DateFormat('w').format(_selectedDate!);
        // print('Saving order with weekNumber: $weekNumber');

        await _firestore.collection('orders').add({
          'customerId': _selectedCustomer,
          'customerLocation': _customerLocation,
          'products': _products,
          'orderDate': Timestamp.fromDate(_selectedDate!),
          'weekNumber': weekNumber,
          'createdAt': Timestamp.now(),
        });
        if (!mounted) return; // Check if widget is still mounted
        setState(() {
          _products.clear();
          _selectedDate = DateTime.now();
          _selectedCustomer = null;
          _customerLocation = null;
          _selectedItem = null;
        });
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error saving order: $e'); // Debug log
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving order: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Products').get();
    setState(() {
      _items = snapshot.docs.map((doc) => doc['product'] as String).toList();
    });
  }

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
      appBar: AppBar(title: const Text('New Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Customer dropdown
              StreamBuilder<QuerySnapshot>(
                stream: getCustomers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final customers = snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    hint: const Text('Select Customer'),
                    items: customers.map((doc) {
                      return DropdownMenuItem(
                        value: doc['Customer'] as String,
                        child: Text('${doc['Customer']} - ${doc['Location']}'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      _selectedCustomer = value;
                      _customerLocation = customers.firstWhere((doc) => doc['Customer'] == value)['Location'];
                    }),
                    validator: (value) => value == null ? 'Select a customer' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              // Date picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Select a date'
                          : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Product input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedItem,
                      hint: const Text('Select a product'),
                      decoration: const InputDecoration(
                        labelText: 'Product',
                        border: OutlineInputBorder(),
                      ),
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
                      validator: (value) => value == null ? 'Select a product' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter quantity' : null,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addProduct,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Product list
              Expanded(
                child: ListView.builder(
                  itemCount: _products.length,  
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text('${product['name']} (Qty: ${product['quantity']})'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editProduct(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => setState(() => _products.removeAt(index)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  if (_selectedCustomer != null && _selectedDate != null && _products.isNotEmpty) {
                    try {
                      final weekNumber = DateFormat('w').format(_selectedDate!);
                      // print('Saving order with weekNumber: $weekNumber');

                      _firestore.collection('orders').add({
                        'customerId': _selectedCustomer,
                        'customerLocation': _customerLocation,
                        'products': _products,
                        'orderDate': Timestamp.fromDate(_selectedDate!),
                        'weekNumber': weekNumber,
                        'createdAt': Timestamp.now(),
                      });

                      if (!mounted) return; // Check if widget is still mounted
                      setState(() {
                        _products.clear();
                        _selectedDate = DateTime.now();
                        _selectedCustomer = null;
                        _customerLocation = null;
                        _selectedItem = null;
                      });
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      print('Error saving order: $e'); // Debug log
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error saving order: $e')),
                      );
                    }
                  }
                },
                child: const Text('Save Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}