import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class PieChartWidget extends StatefulWidget {
  PieChartWidget({Key? key}) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  bool animate = false;
  late List<PieChartSectionData> finalSections;

  @override
  void initState() {
    super.initState();
    // Generate final data with fixed colors for each category.
    finalSections = _generateFinalSections();
    // Trigger the animation after a short delay.
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        animate = true;
      });
    });
  }

  List<PieChartSectionData> _generateFinalSections() {
    final random = Random();
    // Define the categories and fixed colors for each category.
    final categories = ['Food', 'Transport', 'Entertainment', 'Bills', 'Others'];
    final List<Color> categoryColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];
    return List.generate(categories.length, (index) {
      final value = random.nextDouble() * 100 + 10;
      return PieChartSectionData(
        color: categoryColors[index],
        value: value,
        title: '${categories[index]}\n${value.toStringAsFixed(0)}',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  /// If animation hasn't started, show sections with 0 value; otherwise, display final values.
  List<PieChartSectionData> _generateDisplaySections() {
    if (!animate) {
      return finalSections.map((section) {
        return PieChartSectionData(
          color: section.color,
          value: 0,
          title: '',
          radius: section.radius,
        );
      }).toList();
    } else {
      return finalSections;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: _generateDisplaySections(),
        centerSpaceRadius: 40,
        sectionsSpace: 2,
      ),
      swapAnimationDuration: Duration(seconds: 1),
      swapAnimationCurve: Curves.easeInOut,
    );
  }
}
