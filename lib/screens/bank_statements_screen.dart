import 'package:flutter/material.dart';

class BankStatementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e), // Dark mode background
      appBar: AppBar(
        backgroundColor: Color(0xFF2c2c2e),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "eStatements and eAdvices",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bank Account Info
            Text(
              "HSBC One",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              "730-557659-833",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),

            // Filters (Dropdowns)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton("Period"),
                _buildFilterButton("Document type"),
              ],
            ),

            SizedBox(height: 16),

            // Statements List
            Expanded(
              child: ListView(
                children: [
                  _buildMonthSection("March 2025", [
                    _buildStatementItem("Advice - Confirmation for credit transaction", "12 Mar 2025"),
                    _buildStatementItem("Advice - Confirmation for debit transaction", "11 Mar 2025"),
                  ]),
                  _buildMonthSection("February 2025", [
                    _buildStatementItem("Statement - HSBC One", "17 Feb 2025"),
                    _buildStatementItem("Advice - Payment", "10 Feb 2025"),
                    _buildStatementItem("Advice - Global Transfers", "01 Feb 2025"),
                  ]),
                  _buildMonthSection("January 2025", [
                    _buildStatementItem("Statement - HSBC One", "17 Jan 2025"),
                    _buildStatementItem("Advice - Fund transfer credit", "14 Jan 2025"),
                    _buildStatementItem("Advice - Payment", "11 Jan 2025"),
                    _buildStatementItem("Advice - Payment", "06 Jan 2025"),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter Buttons
  Widget _buildFilterButton(String title) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0xFF3c3c3e),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }

  // Month Header Section
  Widget _buildMonthSection(String month, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            month,
            style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Column(children: items),
      ],
    );
  }

  // Statement Item
  Widget _buildStatementItem(String title, String date) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white24, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
