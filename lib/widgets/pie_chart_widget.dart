import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatefulWidget {
  final bool animate;

  const PieChartWidget({Key? key, required this.animate}) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2, // Space between slices
        centerSpaceRadius: 40, // Space in center for a cleaner look
        borderData: FlBorderData(show: false), // Hide border
        sections: _generatePieSections(), // Call function to generate sections
      ),
    );
  }

  List<PieChartSectionData> _generatePieSections() {
    final data = {
      'Food': 300.0,
      'Transport': 150.0,
      'Entertainment': 200.0,
      'Shopping': 250.0,
      'Bills': 400.0,
    };

    final colors = [
      Color(0xFFFF6384), // Red - Food
      Color(0xFF36A2EB), // Blue - Transport
      Color(0xFFFFCE56), // Yellow - Entertainment
      Color(0xFF4BC0C0), // Green - Shopping
      Color(0xFF9966FF), // Purple - Bills
    ];

    return List.generate(data.length, (index) {
      final entry = data.entries.elementAt(index);
      return PieChartSectionData(
        color: colors[index],
        value: widget.animate ? entry.value : 0, // Animates from 0 to actual value
        title: widget.animate ? '${entry.key}\n\$${entry.value.toInt()}' : '', // Show label after animation
        radius: widget.animate ? 80 : 10, // Expands smoothly
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
