import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 60),
              // Profile Picture
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFF3c3c3e),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 90,
                      height: 90,
                      color: Colors.pink[50],
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // User Name
              Text(
                "John Johnson",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              // Quick Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.menu_book_outlined,
                    label: "Subscriptions",
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.notifications_none,
                    label: "Notification",
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.fitness_center,
                    label: "Goals",
                    onTap: () {},
                  ),
                  _buildActionButton(
                    icon: Icons.person,
                    label: "Friends",
                    onTap: () {},
                  ),
                ],
              ),
              SizedBox(height: 30),
              // My Statements Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Color(0xFF3c3c3e),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    "My statements",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              // Financial Health and Credit Rating Cards
              Row(
                children: [
                  Expanded(
                    child: _buildFinancialCard(
                      icon: Icons.park,
                      title: "Financial health",
                      iconBackgroundColor: Colors.white,
                      iconColor: Colors.black,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildFinancialCard(
                      icon: Icons.timer,
                      title: "Credital rating",
                      iconBackgroundColor: Colors.transparent,
                      iconColor: Colors.white70,
                      iconBorder: Border.all(color: Colors.white70, width: 2),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Color(0xFF4CD964), // Green color from image
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.black, size: 30),
            onPressed: onTap,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildFinancialCard({
    required IconData icon,
    required String title,
    required Color iconBackgroundColor,
    required Color iconColor,
    Border? iconBorder,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Color(0xFF3c3c3e),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
              border: iconBorder,
            ),
            child: Icon(
              icon,
              size: 40,
              color: iconColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
