import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DairyGraphing extends StatefulWidget {
  @override
  DairyGraphingState createState() => DairyGraphingState();
}

class DairyGraphingState extends State<DairyGraphing> {
  String? _selectedMonth;
  List<String> _availableMonths = [];
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadAvailableMonths();
  }

  // Fetch available months from Firestore
  void _loadAvailableMonths() async {
    final snapshot = await FirebaseFirestore.instance.collection('DairyData').orderBy('Date').get();
    final months = snapshot.docs
        .map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final date = (data['Date'] is Timestamp)
          ? (data['Date'] as Timestamp).toDate()
          : DateTime.parse(data['Date'] as String);
      return DateFormat('yyyy-MM').format(date);
    })
        .toSet()
        .toList()
      ..sort();
    setState(() {
      _availableMonths = months;
      _selectedMonth = months.isNotEmpty ? months.last : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dairy Production'),
        actions: [
          Container(
            width: 120,
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedMonth,
                hint: Text('Select Month'),
                items: _availableMonths.map((month) {
                  final date = DateFormat('yyyy-MM').parse(month);
                  return DropdownMenuItem<String>(
                    value: month,
                    child: Text(
                      DateFormat('MMMM yyyy').format(date),
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('DairyData').orderBy('Date').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          // Process data
          List<FlSpot> spots = [];
          List<String> dateLabels = [];
          final docs = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final date = (data['Date'] is Timestamp)
                ? (data['Date'] as Timestamp).toDate()
                : DateTime.parse(data['Date'] as String);
            return _selectedMonth == null ||
                DateFormat('yyyy-MM').format(date) == _selectedMonth;
          }).toList();

          for (int i = 0; i < docs.length; i++) {
            final data = docs[i].data() as Map<String, dynamic>;
            final eggCount = (data['Amount of milk'] as num?)?.toDouble() ?? 0.0;
            spots.add(FlSpot(i.toDouble(), eggCount));
            final date = (data['Date'] is Timestamp)
                ? (data['Date'] as Timestamp).toDate()
                : DateTime.parse(data['Date'] as String);
            dateLabels.add(DateFormat('MM/dd').format(date));
          }

          return Padding(
            padding: EdgeInsets.all(25),
            child: SizedBox(
              height: 350,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < dateLabels.length) {
                            return Text(dateLabels[index], style: TextStyle(fontSize: 12));
                          }
                          return Text('');
                        },
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.blue,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      maxContentWidth: 50,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final index = spot.x.toInt();
                          final data = docs[index].data() as Map<String, dynamic>;
                          return LineTooltipItem(
                            data['Amount of milk'].toString(),
                            TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                            ),
                          );
                        }).toList();
                      },
                    ),
                    handleBuiltInTouches: true,
                    getTouchedSpotIndicator: (barData, spotIndexes) {
                      return spotIndexes.map((index) {
                        return TouchedSpotIndicatorData(
                          FlLine(color: Colors.black, strokeWidth: 2),
                          FlDotData(show: true),
                        );
                      }).toList();
                    },
                  ),
                  minX: 0,
                  maxX: (docs.length - 1).toDouble(),
                  minY: 0,
                  maxY: spots.isNotEmpty
                      ? (spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.2)
                      : 10,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}