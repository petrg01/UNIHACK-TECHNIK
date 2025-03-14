import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2c2c2e),
      child: Center(
        child: Text(
          "Profile Screen Content",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
