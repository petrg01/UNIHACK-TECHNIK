import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2c2c2e), // Dark background
      child: Center(
        child: Text(
          "Main Screen Content",
          style: TextStyle(color: Colors.white, fontSize: 20), // White text
        ),
      ),
    );
  }
}
