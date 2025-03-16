import 'package:flutter/material.dart';
import 'package:technik/globals.dart';
import 'package:technik/data/friends_goals_data.dart';
import 'package:technik/widgets/friends_goals_table.dart';
import '../widgets/dynamic_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/pie_chart_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/add_transaction_dialog.dart'; // Import the Add Transaction dialog

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  bool showPieChartAnimation = false;

  @override
  void initState() {
    super.initState();
    // Print the global points variable to the terminal every time the page is opened.
    print("Global points: $points");
    // Load friends data if needed
    _loadFriendsData();
  }
  
  // Load friends data if not already loaded
  Future<void> _loadFriendsData() async {
    if (userFriends.isEmpty) {
      await loadFriends();
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate widget width based on screen width and horizontal padding
    final double screenWidth = MediaQuery.of(context).size.width;
    final double widgetWidth = screenWidth - 16; // 8px padding each side

    // Get friends' goals data
    final friendsGoals = FriendsGoalsData.getSampleFriendsGoals();

    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header section
              HeaderWidget(userName: userName),
              SizedBox(height: 20),
              // Overview charts section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  "Here is your overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              // Charts PageView with consistent widget width.
              Container(
                width: widgetWidth,
                height: 330,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    if (index == 1) {
                      setState(() {
                        showPieChartAnimation = true;
                      });
                    }
                  },
                  children: [
                    // Line Chart Page
                    DynamicWidget(
                      width: widgetWidth,
                      height: 330,
                      cornerRadius: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Monthly Spending Over Time",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: LineChartWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Pie Chart Page
                    DynamicWidget(
                      width: widgetWidth,
                      height: 330,
                      cornerRadius: 45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            "Spending by Category",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: PieChartWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _pageController,
                count: 2,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                  dotHeight: 8,
                  dotWidth: 8,
                ),
              ),
              SizedBox(height: 20),
              // Add Transaction Button
              DynamicWidget(
                width: widgetWidth,
                height: 100,
                cornerRadius: 45,
                color: Color(0xFF4CD964),
                onTap: () => showAddTransactionDialog(context),
                child: Center(
                  child: Text(
                    "Add Transaction",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Friends Goals Progress Table
              DynamicWidget(
                width: widgetWidth,
                height: null, // Auto height based on content
                cornerRadius: 45,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FriendsGoalsTable(
                    friends: userFriends,
                    friendsGoals: friendsGoals,
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
