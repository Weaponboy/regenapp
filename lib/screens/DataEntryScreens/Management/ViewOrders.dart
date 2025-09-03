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

  List<String> _itemsCus = [];
  List<String> _itemsLoc = [];

  List<String> options = ["Location", "Customer"];
  String? sortBy;

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
        // _enforceFilterLimit();
      });
    }
  }

  Stream<QuerySnapshot> getCustomers() {
    return _firestore.collection('Customers').snapshots();
  }

  void updateItems(){
    if (sortBy.toString() == options.first){
      _selectedItem = null;
      _items = _itemsLoc;
    }else{
      _selectedItem = null;
      _items = _itemsCus;
    }
  }

  Future<void> _fetchLocations() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('DeliveryLocations').get();
    setState(() {
      _itemsLoc = snapshot.docs.map((doc) => doc['Location'] as String).toList();
      _items = snapshot.docs.map((doc) => doc['Location'] as String).toList();
    });

    QuerySnapshot snapshot1 =
    await FirebaseFirestore.instance.collection('Customers').get();
    setState(() {
      _itemsCus = snapshot1.docs.map((doc) => doc['Customer'] as String).toList();
    });

  }

  // void _enforceFilterLimit() {
  //   int activeFilters = 0;
  //   if (_selectedDate != null) activeFilters++;
  //   if (_selectedCustomer != null) activeFilters++;
  //   if (_selectedItem != null) activeFilters++;
  //
  //   if (activeFilters > 2) {
  //     setState(() {
  //       if (_selectedDate != null) _selectedDate = null;
  //       else if (_selectedCustomer != null) _selectedCustomer = null;
  //       else if (_selectedItem != null) _selectedItem = null;
  //     });
  //   }
  // }

  Stream<QuerySnapshot> _getOrders() {
    Query<Map<String, dynamic>> query = _firestore.collection('orders');

    // if (_selectedItem != null) {
    //   final startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);
    //   query = query.where('customerId', isEqualTo: _selectedItem)
    //       .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
    //       .where('orderDate', isLessThan: Timestamp.fromDate(startOfDay.add(Duration(days: 1))));
    // }

    if (_selectedDate != null) {
      final startOfDay = DateTime(_selectedDate!.year, _selectedDate!.month, _selectedDate!.day);

      if(sortBy.toString() == options.first){
        query = query
            .where('customerLocation', isEqualTo: _selectedItem)
            .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('orderDate', isLessThan: Timestamp.fromDate(startOfDay.add(Duration(days: 1))));
      }else{
        query = query
            .where('customerId', isEqualTo: _selectedItem)
            .where('orderDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('orderDate', isLessThan: Timestamp.fromDate(startOfDay.add(Duration(days: 1))));
      }

    }

    return query.snapshots();
  }

  @override
  void initState() {
    super.initState();
    sortBy = options.first;
    _fetchLocations();
    updateItems();
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

              DropdownButton<String>(
                isExpanded: true,
                value: sortBy,
                hint: Text('Sort by'),
                items: options.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    sortBy = newValue;
                    updateItems();
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButton<String>(
                isExpanded: true,
                value: _selectedItem,
                hint: Text('Select ' + sortBy.toString()),
                items: _items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                    // _enforceFilterLimit();
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