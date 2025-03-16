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

  /// Fetches transactions from the database, filters expenses, groups them by month, and computes totals.
  Future<void> fetchChartData() async {
    final List<Map<String, dynamic>> txMaps = await TransactionDB.getTransactions();

    // Create a list for monthly totals (Jan = index 0, Dec = index 11)
    List<double> monthlyTotals = List.filled(12, 0.0);

    for (var txMap in txMaps) {
      try {
        DateTime date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(txMap['date']);
        int monthIndex = date.month - 1; // Convert month to index (Jan = 0)

        double amount = (txMap['amount'] is int)
            ? (txMap['amount'] as int).toDouble()
            : txMap['amount'];

        // Only consider transactions where amount is negative (expenses)
        if (amount < 0) {
          monthlyTotals[monthIndex] += amount.abs(); // Take absolute value
        }
      } catch (e) {
        print('Error parsing transaction: $e');
      }
    }

    // Create chart spots for each month based on computed totals.
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

    // Dynamically compute min/max Y values from the data.
    double computedMinY = 0;
    double computedMaxY = 1000; // Default max
    if (finalSpots.isNotEmpty) {
      computedMaxY = finalSpots.map((s) => s.y).reduce(max);
      double margin = computedMaxY * 0.1; // 10% margin
      computedMaxY += margin;
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
                  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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
