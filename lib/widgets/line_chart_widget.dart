import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../db/db.dart'; // Import your database helper

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  bool animate = false; // Controls animation start
  List<FlSpot> finalSpots = []; // Will hold final data from DB

  @override
  void initState() {
    super.initState();
    fetchChartData();
    // Trigger the animation after a short delay
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        animate = true;
      });
    });
  }

  /// Fetches transactions from the database, groups them by month, and computes totals.
  Future<void> fetchChartData() async {
    // Get transactions from DB (assumes date is stored as "YYYY-MM-DD HH:mm:ss")
    final List<Map<String, dynamic>> txMaps = await TransactionDB.getTransactions();
    // Create a list for monthly totals for 12 months (index 0 = Jan, index 11 = Dec)
    List<double> monthlyTotals = List.filled(12, 0.0);

    for (var txMap in txMaps) {
      try {
        DateTime date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(txMap['date']);
        int monthIndex = date.month - 1; // Month 1 (Jan) becomes index 0
        double amount = (txMap['amount'] is int)
            ? (txMap['amount'] as int).toDouble()
            : txMap['amount'];
        monthlyTotals[monthIndex] += amount;
      } catch (e) {
        print('Error parsing transaction: $e');
      }
    }

    // Create chart spots for each month based on the computed totals.
    List<FlSpot> spots = List.generate(12, (index) {
      return FlSpot(index.toDouble(), monthlyTotals[index]);
    });

    setState(() {
      finalSpots = spots;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use zero-value spots if not animating yet.
    List<FlSpot> displaySpots = (animate && finalSpots.isNotEmpty)
        ? finalSpots
        : List.generate(12, (index) => FlSpot(index.toDouble(), 0));

    // Optionally compute dynamic minY and maxY from the data (or use fixed values if preferred).
    double computedMinY = 500;
    double computedMaxY = 1200;
    if (finalSpots.isNotEmpty) {
      computedMinY = finalSpots.map((s) => s.y).reduce(min);
      computedMaxY = finalSpots.map((s) => s.y).reduce(max);
      // Add a little margin to the computed values.
      double margin = (computedMaxY - computedMinY) * 0.1;
      computedMinY = computedMinY - margin;
      computedMaxY = computedMaxY + margin;
      // Ensure minY is not less than zero.
      computedMinY = computedMinY < 0 ? 0 : computedMinY;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55,
              getTitlesWidget: (value, meta) {
                // Display labels every $100 step
                if (value % 100 == 0) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      '\$${value.toInt()}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec'
                ];
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    months[value.toInt()],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              },
              interval: 1,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: displaySpots,
            isCurved: true,
            color: Color(0xFF50c878), // Emerald Green
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(enabled: false),
        minX: 0,
        maxX: 11,
        minY: computedMinY,
        maxY: computedMaxY,
        clipData: FlClipData.all(),
      ),
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }
}
