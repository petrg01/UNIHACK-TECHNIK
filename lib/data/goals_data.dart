import 'package:flutter/material.dart';
import 'package:technik/widgets/goals_list.dart';

// Sample goals data provider
class GoalsData {
  static List<Goal> getSampleGoals() {
    return [
      Goal(
        title: "Emergency Fund",
        description: "Build a safety net for unexpected expenses",
        currentAmount: 3500,
        targetAmount: 10000,
        targetDate: DateTime(2024, 12, 31),
        category: "Savings",
        categoryColor: Color(0xFF4CD964), // Green
      ),
      Goal(
        title: "New Car",
        description: "Save for a down payment on a new vehicle",
        currentAmount: 4200,
        targetAmount: 15000,
        targetDate: DateTime(2025, 6, 30),
        category: "Purchase",
        categoryColor: Color(0xFF5AC8FA), // Blue
      ),
      Goal(
        title: "Retirement",
        description: "Long-term investment for retirement",
        currentAmount: 25000,
        targetAmount: 500000,
        category: "Investment",
        categoryColor: Color(0xFFFF9500), // Orange
      ),
      Goal(
        title: "Vacation",
        description: "Summer trip to Europe",
        currentAmount: 1800,
        targetAmount: 5000,
        targetDate: DateTime(2024, 7, 1),
        category: "Travel",
        categoryColor: Color(0xFFFF2D55), // Red
      ),
      Goal(
        title: "Student Loan",
        description: "Pay off remaining student loan balance",
        currentAmount: 8500,
        targetAmount: 12000,
        targetDate: DateTime(2025, 3, 15),
        category: "Debt",
        categoryColor: Color(0xFF5856D6), // Purple
      ),
    ];
  }
} 