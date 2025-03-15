import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;

  const HeaderWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black, // Header background color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Image.asset(
            'lib/icons/logo.png', // Update with the correct path to your logo
            height: 50,
          ),

          // Greeting
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Good Afternoon,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                userName, // Dynamically passed name
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
