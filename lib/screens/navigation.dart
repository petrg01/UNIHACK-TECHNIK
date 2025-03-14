import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/prize_draw_screen.dart';
import '../screens/advisor_screen.dart';
import '../screens/profile_screen.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    TransactionsScreen(),
    AdvisorScreen(),
    PrizeDrawScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.blueAccent, width: 2)), // Blue outline
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.black, // Dark theme
          selectedItemColor: Colors.white, // White for selected items
          unselectedItemColor: Colors.grey, // Grey for unselected items
          type: BottomNavigationBarType.fixed, // Keeps labels visible
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('icons/mynaui_home.png'), size: 30),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('icons/gala_calendar.png'), size: 30), // Fixed path for History
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('mynaui_home.png'), size: 30),
              label: "", // No text for Advisor
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/icons/prizes.png'), size: 30),
              label: "Prizes",
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('lib/icons/profile.png'), size: 30),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
