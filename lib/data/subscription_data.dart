import 'package:flutter/material.dart';
import 'package:technik/widgets/subscription_list.dart';

// Sample subscription data provider
class SubscriptionData {
  static List<Subscription> getSampleSubscriptions() {
    final now = DateTime.now();
    
    return [
      Subscription(
        name: "Premium Plan",
        description: "Advanced financial tools and insights",
        price: 9.99,
        period: "monthly",
        renewalDate: DateTime(now.year, now.month + 1, now.day),
        isActive: true,
        color: Color(0xFF4CD964), // Green
      ),
      Subscription(
        name: "Spotify",
        description: "Music streaming service",
        price: 12.99,
        period: "monthly",
        renewalDate: DateTime(now.year, now.month + 1, 15),
        isActive: true,
        color: Color(0xFF1DB954), // Spotify green
      ),
      Subscription(
        name: "Netflix",
        description: "Video streaming service",
        price: 15.99,
        period: "monthly",
        renewalDate: DateTime(now.year, now.month + 1, 3),
        isActive: true,
        color: Color(0xFFE50914), // Netflix red
      ),
      Subscription(
        name: "Adobe Creative",
        description: "Creative suite of applications",
        price: 52.99,
        period: "monthly",
        renewalDate: DateTime(now.year, now.month + 1, 10),
        isActive: false,
        color: Color(0xFFFF0000), // Adobe red
      ),
      Subscription(
        name: "Amazon Prime",
        description: "Shopping and entertainment",
        price: 119.00,
        period: "yearly",
        renewalDate: DateTime(now.year + 1, 2, 15),
        isActive: true,
        color: Color(0xFF00A8E1), // Amazon blue
      ),
      Subscription(
        name: "Gym Membership",
        description: "Monthly fitness membership",
        price: 39.99,
        period: "monthly",
        renewalDate: DateTime(now.year, now.month + 1, 1),
        isActive: true,
        color: Color(0xFFFF9500), // Orange
      ),
    ];
  }
} 