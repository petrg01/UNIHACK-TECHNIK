import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'transactions_screen.dart';
import 'prize_draw_screen.dart';
import 'advisor_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    TransactionsScreen(),
    PrizeDrawScreen(),
    AdvisorScreen(),
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
              icon: Icon(Icons.home, size: 30),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today, size: 30), // History Icon
              label: "History",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard, size: 30), // Prize Icon
              label: "Prizes",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.memory, size: 30), // AI/Advisor Icon
              label: "Advisor",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30), // Profile Icon
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
