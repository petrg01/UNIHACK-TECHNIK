import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Hide grid lines
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55, // Enough space for 4-digit numbers
              getTitlesWidget: (value, meta) {
                // Define labels explicitly to avoid missing numbers
                if (value % 100 == 0 && value >= 500 && value <= 1100) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      '\$${value.toInt()}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                  );
                }
                return Container(); // Hide other labels
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    months[value.toInt()],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                );
              },
              interval: 1, // Show every month
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide right Y-axis labels
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false), // Hide top X-axis labels
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Colors.white, width: 1),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 500),  // January
              FlSpot(1, 750),  // February
              FlSpot(2, 600),  // March
              FlSpot(3, 820),  // April
              FlSpot(4, 700),  // May
              FlSpot(5, 900),  // June
              FlSpot(6, 1000), // July
              FlSpot(7, 950),  // August
              FlSpot(8, 870),  // September
              FlSpot(9, 980),  // October
              FlSpot(10, 1100), // November
              FlSpot(11, 1050), // December
            ],
            isCurved: true,
            color: Color(0xFF50c878), // Emerald Green
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
