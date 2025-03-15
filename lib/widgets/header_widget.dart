import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String userName;

  const HeaderWidget({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 10),
      decoration: const BoxDecoration(
        color: Colors.black, 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'lib/icons/logo.png', 
            height: 57,
            width: 56,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "Good Afternoon,",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                userName, 
                style: const TextStyle(
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
