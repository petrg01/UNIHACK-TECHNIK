import 'package:flutter/material.dart';
import '../widgets/dynamic_widget.dart'; // Import the updated DynamicWidget

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2c2c2e), // Dark background
      child: Center(
        child: DynamicWidget(
          width: 365, // width, default is 365
          cornerRadius: 45, // corner radius, default is 49
          height: 100, // height, by default as tall as the content inside
          color: Color(0xFF50C878), // color, by default dark grey
          child: Center(
            child: Text(
              "Main Screen Content",
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
