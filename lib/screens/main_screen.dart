import 'package:flutter/material.dart';
import 'package:technik/globals.dart';
import '../widgets/dynamic_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/pie_chart_widget.dart'; // New pie chart widget file
import '../widgets/header_widget.dart';
import '../widgets/add_transaction_dialog.dart'; // Import the Add Transaction dialog

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
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
                padding: EdgeInsets.symmetric(horizontal: 20),
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
              Container(
                height: 330,
                child: PageView(
                  controller: _pageController,
                  children: [
                    // Line Chart Page
                    DynamicWidget(
                      width: 390,
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
                    // Pie Chart Page (renders random data with animation)
                    DynamicWidget(
                      width: 390,
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
                width: 365,
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
              // Additional static widget (New Widget Below)
              DynamicWidget(
                width: 390,
                height: 150,
                cornerRadius: 45,
                child: Center(
                  child: Text(
                    "New Widget Below",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
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
