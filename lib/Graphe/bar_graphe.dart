// ignore_for_file: camel_case_types, avoid_print

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/Graphe/bar_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math' show pow;

class Mybar_G extends StatefulWidget {
  const Mybar_G({super.key});

  @override
  State<Mybar_G> createState() => _Mybar_GState();
}

class _Mybar_GState extends State<Mybar_G> {
  bool isLoading = true;
  // ignore: non_constant_identifier_names
  late BarData bar_data;
  // Add a stream subscription to manage the listener
  StreamSubscription<QuerySnapshot>? _usersSubscription;
  
  @override
  void initState() {
    super.initState();
    // Initialize with zeros
    bar_data = BarData(
      janamount: 0,
      fivamount: 0,
      marnamount: 0,
      apramount: 0,
      maiamount: 0,
      junamount: 0,
      julamount: 0,
    );
    bar_data.intlist(); // Initialize barlist with zeros
    setupRealtimeUpdates();
  }
  
  void setupRealtimeUpdates() {
    final currentYear = DateTime.now().year;
    
    // Create a stream listener instead of a one-time fetch
    _usersSubscription = FirebaseFirestore.instance
        .collection('users')
        .where('createdAt', isGreaterThanOrEqualTo: DateTime(currentYear, 1, 1))
        .snapshots()
        .listen((snapshot) {
          updateChartData(snapshot);
        }, onError: (error) {
          print('Error in realtime updates: $error');
          setState(() {
            isLoading = false;
          });
        });
  }
  
  void updateChartData(QuerySnapshot snapshot) {
    try {
      final currentYear = DateTime.now().year;
      
      // Create counters for each month
      int janCount = 0;
      int febCount = 0;
      int marCount = 0;
      int aprCount = 0;
      int mayCount = 0;
      int junCount = 0;
      int julCount = 0;
      
      // Process each user document
      for (var doc in snapshot.docs) {
        // Get the timestamp from the user document
        final data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('createdAt')) {
          Timestamp timestamp = data['createdAt'];
          DateTime creationDate = timestamp.toDate();
          
          // Only count users from the current year
          if (creationDate.year == currentYear) {
            // Count users by month
            switch (creationDate.month) {
              case 1: janCount++; break;
              case 2: febCount++; break;
              case 3: marCount++; break;
              case 4: aprCount++; break;
              case 5: mayCount++; break;
              case 6: junCount++; break;
              case 7: julCount++; break;
              // Add more months if needed
            }
          }
        }
      }
      
      // Update bar data with real values
      if (mounted) {
        setState(() {
          bar_data = BarData(
            janamount: janCount.toDouble(),
            fivamount: febCount.toDouble(),
            marnamount: marCount.toDouble(),
            apramount: aprCount.toDouble(),
            maiamount: mayCount.toDouble(),
            junamount: junCount.toDouble(),
            julamount: julCount.toDouble(),
          );
          bar_data.intlist(); // Initialize the barlist with new data
          isLoading = false;
        });
      }
      
    } catch (e) {
      print('Error processing user data: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Cancel the subscription when the widget is removed
    _usersSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Find the maximum value for proper scaling
 // Find the maximum value for proper scaling
double maxValue = [
  bar_data.janamount, 
  bar_data.fivamount, 
  bar_data.marnamount,
  bar_data.apramount,
  bar_data.maiamount,
  bar_data.junamount,
  bar_data.julamount
].reduce((max, value) => value > max ? value : max);

// Custom scaling logic:
// If max value is 7, scale to 100 (7*10 rounded up)
// If max value is 70, scale to 1000 (70*10 rounded up)
double maxY;
if (maxValue <= 0) {
  maxY = 100; // Default if no data
} else {
  // Multiply by 10 and round to nearest power of 10
  int multiplied = (maxValue * 10).ceil();
  int digits = multiplied.toString().length;
  maxY = pow(10, digits).toDouble();
}

    return BarChart(
      BarChartData(
        maxY: maxY, // Dynamic max value based on data
        minY: 0,
        gridData: FlGridData(
          horizontalInterval: maxY / 5, // 5 horizontal grid lines
          show: true,
          drawHorizontalLine: true,
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                // Show month names on the bottom
                String text = '';
                if (value < bar_data.barlist.length) {
                  text = bar_data.barlist[value.toInt()].month;
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                // Show number of users on the left
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(fontSize: 12),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
  enabled: true,
  touchTooltipData: BarTouchTooltipData(
    tooltipPadding: const EdgeInsets.all(8),
    tooltipMargin: 8,
    getTooltipItem: (group, groupIndex, rod, rodIndex) {
      return BarTooltipItem(
        rod.toY.toInt().toString(), // the value to display
        TextStyle(
          color: const Color.fromARGB(255, 0, 0, 0), // 👈 Change this to any color you want
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );
    },
  ),
),
        barGroups: bar_data.barlist.map(
          (data) => BarChartGroupData(
            x: bar_data.barlist.indexOf(data),
            barRods: [
              BarChartRodData(
                toY: data.users,
                width: 20,
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(10),
              )
            ],
          ),
        ).toList(),
      ),
    );
  }
}