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

  final _formKey = GlobalKey<FormState>();
  String? _selectedCustomer;
  String? _customerLocation;
  List<Map<String, dynamic>> _products = [];
  DateTime? _orderDate;
  final _productNameController = TextEditingController();
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
        _productNameController.clear();
        _quantityController.clear();
      });
    }
  }

  Future<void> _saveOrder() async {
    if (_selectedDate != null && _products.length > 0) {
      String date = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      await _firestore.collection('orders').add({
        'customerId': _selectedCustomer,
        'customerLocation': _customerLocation,
        'products': _products,
        'orderDate': Timestamp.fromDate(_selectedDate!), // Convert DateTime to Timestamp
      });

      setState(() {
        _products.clear();
        _selectedDate = DateTime.now();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('Products').get();
    setState(() {
      _items = snapshot.docs.map((doc) => doc['product'] as String).toList();
    });
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
                        value: doc['Customer'] as String, // Use customer name as value
                        child: Text('${doc['Customer']} - ${doc['Location']}'),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() {
                      _selectedCustomer = value; // Store customer name
                      _customerLocation = customers
                          .firstWhere((doc) => doc['Customer'] == value)['Location']; // Find location by name
                    }),
                    validator: (value) => value == null ? 'Select a customer' : null,
                  );
                },
              ),
              const SizedBox(height: 22),
              Row(
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
              const SizedBox(height: 22),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedItem,
                      hint: Text('Select a product'),
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
                  ),
                  const SizedBox(width:35),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
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
              // Product list
              Expanded(
                child: ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return ListTile(
                      title: Text('${product['name']} (Qty: ${product['quantity']})'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => setState(() => _products.removeAt(index)),
                      ),
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: _saveOrder,
                child: const Text('Save Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}