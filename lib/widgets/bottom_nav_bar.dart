import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/prize_draw_screen.dart';
import '../screens/advisor_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  
  BottomNavBar({required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = MainScreen();
        break;
      case 1:
        nextScreen = TransactionsScreen();
        break;
      case 2:
        nextScreen = PrizeDrawScreen();
        break;
      case 3:
        nextScreen = AdvisorScreen();
        break;
      case 4:
        nextScreen = ProfileScreen();
        break;
      default:
        nextScreen = MainScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) => _onItemTapped(context, index),
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: "Transactions"),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: "Prize Draw"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Advisor"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
