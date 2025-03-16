import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:technik/db/db.dart'; // Adjust the import path as needed
import 'dart:async';

class PieChartWidget extends StatefulWidget {
  PieChartWidget({Key? key}) : super(key: key);

  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  bool animate = false;
  List<PieChartSectionData> finalSections = [];

  @override
  void initState() {
    super.initState();
    fetchChartData();
    // Trigger the animation after a short delay.
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        animate = true;
      });
    });
  }

  /// Fetch transactions from the database, filter for expenses, group them by category,
  /// and compute the total amount for each category.
  Future<void> fetchChartData() async {
    final List<Map<String, dynamic>> txMaps = await TransactionDB.getTransactions();

    // Group transactions by category.
    Map<String, double> categoryTotals = {};
    for (var tx in txMaps) {
      String category = tx['category'] ?? "Other"; // Default to "Other" if null
      double amount = (tx['amount'] is int)
          ? (tx['amount'] as int).toDouble()
          : tx['amount'];

      // Only process negative amounts (expenses)
      if (amount < 0) {
        categoryTotals[category] = (categoryTotals[category] ?? 0) + amount.abs();
      }
    }

    // Predefined fixed colors (cycle through if there are more categories)
    final List<Color> fixedColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
    ];

    // Create a PieChartSectionData list from the grouped data.
    List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    categoryTotals.forEach((category, total) {
      sections.add(
        PieChartSectionData(
          color: fixedColors[colorIndex % fixedColors.length],
          value: total,
          title: '$category\n${total.toStringAsFixed(0)}',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      colorIndex++;
    });

    setState(() {
      finalSections = sections;
    });
  }

  /// If animation hasn't started, return sections with 0 values; otherwise, return final sections.
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
