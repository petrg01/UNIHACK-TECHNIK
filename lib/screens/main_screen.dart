import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Import swipe dots
import '../widgets/dynamic_widget.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/pie_chart_widget.dart'; // Import pie chart widget

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(); // Tracks page index
  bool showPieChartAnimation = false; // Tracks whether to animate the pie chart

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e), // Dark background
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20), // Space from top

            // PageView Headers (Dynamically Switches Text)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  int pageIndex = _pageController.hasClients && _pageController.page != null
                      ? _pageController.page!.round()
                      : 0;
                  return Text(
                    pageIndex == 0 ? "Your Spending Over Last Year" : "Your Spending by Category",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),

            // Swipable PageView for Graph & Pie Chart
            SizedBox(
              height: 300, // Fixed height for the swipable area
              child: PageView(
                controller: _pageController, // Attach controller
                onPageChanged: (index) {
                  if (index == 1) {
                    setState(() {
                      showPieChartAnimation = true; // Trigger pie chart animation
                    });
                  }
                },
                children: [
                  // First Page - Line Chart
                  DynamicWidget(
                    width: 390,
                    height: 300,
                    cornerRadius: 45,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: LineChartWidget(),
                    ),
                  ),

                  // Second Page - Pie Chart (Money Spent by Category)
                  DynamicWidget(
                    width: 390,
                    height: 300,
                    cornerRadius: 45,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: PieChartWidget(animate: showPieChartAnimation),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10), // Space between swipe dots and widget

            // Swipe Indicator Dots
            SmoothPageIndicator(
              controller: _pageController, // Attach to PageView controller
              count: 2, // Number of pages
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),

            SizedBox(height: 20), // Space between widgets

            // Second Static Widget Below
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
          ],
        ),
      ),
    );
  }
}
