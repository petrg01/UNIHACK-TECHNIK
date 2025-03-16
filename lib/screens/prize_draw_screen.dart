import 'package:flutter/material.dart';
import '../widgets/slot_machine_widget.dart';

class PrizeDrawScreen extends StatefulWidget {
  @override
  _PrizeDrawScreenState createState() => _PrizeDrawScreenState();
}

class _PrizeDrawScreenState extends State<PrizeDrawScreen> {
  int totalWinnings = 0;
  
  void _handleWin(int amount) {
    setState(() {
      totalWinnings += amount;
    });
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.33) {
      return Colors.red;
    } else if (progress < 0.66) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  Widget buildBadge(String name, String description, double progress) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 8,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor(progress)),
              ),
            ),
          ),
          SizedBox(height: 8),
          Icon(
            Icons.emoji_events,
            size: 50,
            color: Colors.amber,
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Text appears first now
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Text(
                  "Use your points to win prizes!",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Slot Machine Widget is now below the text
              SlotMachineWidget(
                onWin: _handleWin,
              ),

              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Badges",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Container(
                height: 160,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      buildBadge("First Place", "Have the highest score at the end of the month", 1.0),
                      buildBadge("Consistent", "Log your expenses every day for a month", 0.67),
                      buildBadge("Debt Demolisher", "Pay off your debts. Consistency is key", 0.34),
                      buildBadge("Achiever", "Achieve your savings goals", 0.2),
                      buildBadge("Gambler", "Spin the slots 1000 times", 0.1),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
