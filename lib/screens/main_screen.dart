import 'package:flutter/material.dart';
import '../widgets/dynamic_widget.dart'; // Corrected lowercase import

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2c2c2e), // Dark background
      child: Center(
        child: DynamicWidget(
          width: 365,
          cornerRadius: 45,
          height: 100, // height, by default as high as content
          color: Color(0xFF50C878), // Colour, by default dark grey
          onTap: () {
            print("Button Pressed!"); // Action when clicked, if N/A not a button
          },
          child: Center(
            child: Text(
              "Press Me",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
