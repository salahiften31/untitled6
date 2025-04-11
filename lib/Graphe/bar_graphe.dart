import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:untitled6/Graphe/bar_data.dart';


class Mybar_G extends StatelessWidget {
  const Mybar_G({super.key});

  @override
  Widget build(BuildContext context) {
    BarData bar_data = BarData(
      janamount: 50,
      fivamount: 140,
      marnamount: 270,
      apramount: 580,
      maiamount: 620,
      junamount: 780,
      julamount: 1200,
    );

    bar_data.intlist();  // ✅ Initialize the barlist

    return BarChart(
      BarChartData(
        maxY: 4000,
        minY: 0,
       
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))


        ),
        barGroups: bar_data.barlist.map(
          (data) => BarChartGroupData(
            x: bar_data.barlist.indexOf(data),  // ✅ x expects an int
            barRods: [BarChartRodData(toY: data.users,
            width: 20,
            borderRadius: BorderRadius.circular(10)
            )],
          ),
        ).toList(),
      ),
    );
  }
}
