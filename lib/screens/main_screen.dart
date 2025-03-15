import 'package:flutter/material.dart';
import '../widgets/dynamic_widget.dart'; // Import dynamic widget
import '../widgets/line_chart_widget.dart'; // Import line chart widget

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Changed to Scaffold for better structure
      backgroundColor: Color(0xFF2c2c2e), // Dark background
      body: SafeArea( // Keeps content within screen bounds
        child: SingleChildScrollView( // Prevents overflow if content exceeds screen height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Aligns widgets to the top
            crossAxisAlignment: CrossAxisAlignment.center, // Center aligns horizontally
            children: [
              SizedBox(height: 20), // Add space at the top
              
              // First Widget - Line Chart
              DynamicWidget(
                width: 390,
                height: 300, // Adjusted for better chart visibility
                cornerRadius: 45,
                child: Padding(
                  padding: EdgeInsets.all(5), // Prevents content from touching edges
                  child: LineChartWidget(), // Displays the line chart
                ),
              ),

              SizedBox(height: 20), // Space between widgets

              // Second Widget - Placeholder for new content
              DynamicWidget(
                width: 390,
                height: 150, // Adjustable height for content
                cornerRadius: 45,
                child: Center(
                  child: Text(
                    "New Widget Below",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
