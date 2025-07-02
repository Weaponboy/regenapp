import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:week_of_year/week_of_year.dart';

class OrderWeekSearchScreen extends StatefulWidget {
  const OrderWeekSearchScreen({super.key});

  @override
  _OrderWeekSearchScreenState createState() => _OrderWeekSearchScreenState();
}

class _OrderWeekSearchScreenState extends State<OrderWeekSearchScreen> {
  DateTime? _selectedDate = DateTime.now();
  final _firestore = FirebaseFirestore.instance;
  String? _selectedCustomer;
  String? _customerLocation;
  String? _selectedItem;
  List<String> _items = [];

  int getWeekNumber(DateTime date) {
    return date.weekOfYear;
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
        _enforceFilterLimit();
      });
    }
  }

  Stream<QuerySnapshot> getCustomers() {
    return _firestore.collection('Customers').snapshots();
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('DeliveryLocations').get();
    setState(() {
      _items = snapshot.docs.map((doc) => doc['Location'] as String).toList();
    });
  }

  void _enforceFilterLimit() {
    int activeFilters = 0;
    if (_selectedDate != null) activeFilters++;
    if (_selectedCustomer != null) activeFilters++;
    if (_selectedItem != null) activeFilters++;

    if (activeFilters > 2) {
      setState(() {
        if (_selectedDate != null) _selectedDate = null;
        else if (_selectedCustomer != null) _selectedCustomer = null;
        else if (_selectedItem != null) _selectedItem = null;
      });
    }
  }

  Stream<QuerySnapshot> _getOrders() {
    Query<Map<String, dynamic>> query = _firestore.collection('orders');

    if (_selectedCustomer != null) {
      query = query.where('customerId', isEqualTo: _selectedCustomer);
    }
    if (_selectedItem != null) {
      query = query.where('customerLocation', isEqualTo: _selectedItem);
    }
    if (_selectedDate != null) {
      final startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
      query = query
          .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('orderDate', isLessThan: Timestamp.fromDate(startOfDay.add(Duration(days: 1))));
    }

    return query.snapshots();
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: getCustomers(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final customers = snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    hint: const Text('Select Customer'),
                    items: customers.map((doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text('${doc['Customer']} - ${doc['Location']}'),
                      );
                    }).toList(),
                    value: _selectedCustomer,
                    onChanged: (value) => setState(() {
                      _selectedCustomer = value;
                      _customerLocation = customers
                          .firstWhere((doc) => doc.id == value)['Location'];
                      _enforceFilterLimit();
                    }),
                    validator: (value) => value == null ? 'Select a customer' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedItem,
                hint: Text('Sort by location'),
                items: _items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                    _enforceFilterLimit();
                  });
                },
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: _getOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final orders = snapshot.data!.docs;
                  if (orders.isEmpty) {
                    return const Text('No orders found.');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      final products = (order['products'] as List).map((p) => '(${p['name']}: ${p['quantity']})').join(', ');
                      return ListTile(
                        title: Text('Customer: ${order['customerId']}'),
                        subtitle: Text(
                              'Location: ${order['customerLocation']}\n'
                              'Date: ${DateFormat('yyyy-MM-dd').format((order['orderDate'] as Timestamp).toDate())}\n'
                              'Products: $products',
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}