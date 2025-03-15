import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatefulWidget {
  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  bool animate = false; // Controls animation start

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        animate = true; // Triggers animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Hide grid lines
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55, // Ensures space for labels
              getTitlesWidget: (value, meta) {
                // Ensure fixed Y-axis labels for every $100 step
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
                return Container(); // Hide unwanted labels
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
              FlSpot(0, animate ? 500 : 0),  
              FlSpot(1, animate ? 750 : 0),  
              FlSpot(2, animate ? 600 : 0),  
              FlSpot(3, animate ? 820 : 0),  
              FlSpot(4, animate ? 700 : 0),  
              FlSpot(5, animate ? 900 : 0),  
              FlSpot(6, animate ? 1000 : 0), 
              FlSpot(7, animate ? 950 : 0),  
              FlSpot(8, animate ? 870 : 0),  
              FlSpot(9, animate ? 980 : 0),  
              FlSpot(10, animate ? 1100 : 0), 
              FlSpot(11, animate ? 1050 : 0), 
            ],
            isCurved: true,
            color: Color(0xFF50c878), // Emerald Green
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(enabled: false), // Disable touch effect
        minX: 0,
        maxX: 11,
        minY: 500, // Prevents Y-axis auto-scaling
        maxY: 1200,
        clipData: FlClipData.all(), // Ensures the animation stays within bounds
      ),
      duration: Duration(seconds: 1), // Animation duration
      curve: Curves.easeInOut, // Smooth animation
    );
  }
}
