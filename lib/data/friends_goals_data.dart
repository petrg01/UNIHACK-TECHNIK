import 'package:flutter/material.dart';
import 'package:technik/widgets/goals_list.dart';
import 'package:technik/widgets/friends_list.dart';
import 'package:technik/data/friends_data.dart';

class FriendsGoalsData {
  // Method to get sample goals for friends
  static Map<String, List<Goal>> getSampleFriendsGoals() {
    final Map<String, List<Goal>> friendsGoals = {};
    
    // Get list of sample friends
    final friends = FriendsData.getSampleFriends();
    
    // Generate sample goals for each friend
    for (var friend in friends) {
      friendsGoals[friend.name] = _generateGoalsForFriend(friend);
    }
    
    return friendsGoals;
  }
  
  // Helper method to generate goals for a specific friend
  static List<Goal> _generateGoalsForFriend(Friend friend) {
    // Generate different goals based on the friend's name
    // This is just for demo purposes - in a real app, this would come from a backend
    switch (friend.name) {
      case "Alex Smith":
        return [
          Goal(
            title: "New Home",
            description: "Save for a down payment on a house",
            currentAmount: 50000,
            targetAmount: 80000,
            targetDate: DateTime(2025, 6, 1),
            category: "Savings",
            categoryColor: Color(0xFF4CD964), // Green
          ),
          Goal(
            title: "Retirement",
            description: "Long-term investment for retirement",
            currentAmount: 120000,
            targetAmount: 1000000,
            category: "Investment",
            categoryColor: Color(0xFFFF9500), // Orange
          ),
        ];
        
      case "Emma Johnson":
        return [
          Goal(
            title: "Student Loan",
            description: "Pay off remaining student loan balance",
            currentAmount: 22000,
            targetAmount: 30000,
            targetDate: DateTime(2024, 12, 31),
            category: "Debt",
            categoryColor: Color(0xFF5856D6), // Purple
          ),
          Goal(
            title: "Europe Trip",
            description: "Save for a vacation in Europe",
            currentAmount: 2500,
            targetAmount: 5000,
            targetDate: DateTime(2024, 7, 15),
            category: "Travel",
            categoryColor: Color(0xFFFF2D55), // Red
          ),
          Goal(
            title: "New Laptop",
            description: "Professional equipment upgrade",
            currentAmount: 1800,
            targetAmount: 2000,
            targetDate: DateTime(2023, 12, 1),
            category: "Purchase",
            categoryColor: Color(0xFF5AC8FA), // Blue
          ),
        ];
        
      case "Michael Brown":
        return [
          Goal(
            title: "Emergency Fund",
            description: "3-month expense buffer",
            currentAmount: 2000,
            targetAmount: 15000,
            category: "Savings",
            categoryColor: Color(0xFF4CD964), // Green
          ),
        ];
        
      case "Sophia Williams":
        return [
          Goal(
            title: "Wedding",
            description: "Save for wedding expenses",
            currentAmount: 12000,
            targetAmount: 25000,
            targetDate: DateTime(2024, 9, 20),
            category: "Event",
            categoryColor: Color(0xFFFF9500), // Orange
          ),
          Goal(
            title: "Business Startup",
            description: "Initial capital for small business",
            currentAmount: 15000,
            targetAmount: 50000,
            category: "Business",
            categoryColor: Color(0xFF5AC8FA), // Blue
          ),
        ];
        
      case "James Davis":
        return [
          Goal(
            title: "Car Loan",
            description: "Pay off car loan early",
            currentAmount: 18000,
            targetAmount: 25000,
            targetDate: DateTime(2025, 2, 28),
            category: "Debt",
            categoryColor: Color(0xFF5856D6), // Purple
          ),
          Goal(
            title: "Home Renovation",
            description: "Kitchen and bathroom remodel",
            currentAmount: 7500,
            targetAmount: 30000,
            targetDate: DateTime(2025, 5, 15),
            category: "Home Improvement",
            categoryColor: Color(0xFF4CD964), // Green
          ),
        ];
        
      default:
        // Default goals for any other friends
        return [
          Goal(
            title: "Savings Goal",
            description: "General savings goal",
            currentAmount: 1000,
            targetAmount: 10000,
            category: "Savings",
            categoryColor: Color(0xFF4CD964), // Green
          ),
        ];
    }
  }
} 