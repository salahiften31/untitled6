import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/Graphe/bar_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Mybar_G extends StatefulWidget {
  const Mybar_G({super.key});

  @override
  State<Mybar_G> createState() => _Mybar_GState();
}

class _Mybar_GState extends State<Mybar_G> {
  bool isLoading = true;
  late BarData bar_data;
  
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
    fetchMonthlyUserCounts();
  }
  
  Future<void> fetchMonthlyUserCounts() async {
    try {
      final currentYear = DateTime.now().year;
      
      // Get all users
      final QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('createdAt', isGreaterThanOrEqualTo: DateTime(currentYear, 1, 1))
          .get();
      
      // Create counters for each month
      int janCount = 0;
      int febCount = 0;
      int marCount = 0;
      int aprCount = 0;
      int mayCount = 0;
      int junCount = 0;
      int julCount = 0;
      
      // Process each user document
      for (var doc in userSnapshot.docs) {
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
      
    } catch (e) {
      print('Error fetching monthly user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
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
    
    // Set the max Y to be slightly higher than the maximum value
    double maxY = maxValue > 0 ? (maxValue * 1.2) : 100;

    return BarChart(
      BarChartData(
        maxY: 100, // Dynamic max value
        minY: 0,
        gridData: FlGridData(
          horizontalInterval: maxY / 5, // 5 horizontal grid lines
          show: true,
          drawHorizontalLine: false,
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