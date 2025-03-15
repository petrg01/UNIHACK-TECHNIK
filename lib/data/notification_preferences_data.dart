import 'package:flutter/material.dart';
import 'package:technik/widgets/notification_preferences_list.dart';

// Sample notification preferences data provider
class NotificationPreferencesData {
  static List<NotificationPreference> getSamplePreferences() {
    return [
      NotificationPreference(
        title: "Account Activity",
        description: "Get notified about login attempts and security alerts",
        icon: Icons.security,
        iconColor: Color(0xFF4CD964), // Green
        isEnabled: true,
      ),
      NotificationPreference(
        title: "Financial Updates",
        description: "Receive updates on your financial health and spending",
        icon: Icons.attach_money,
        iconColor: Color(0xFF5AC8FA), // Blue
        isEnabled: true,
      ),
      NotificationPreference(
        title: "Bill Reminders",
        description: "Get reminded about upcoming bills and payments",
        icon: Icons.calendar_today,
        iconColor: Color(0xFFFF9500), // Orange
        isEnabled: true,
      ),
      NotificationPreference(
        title: "Goal Progress",
        description: "Be notified when you reach milestones on your goals",
        icon: Icons.flag,
        iconColor: Color(0xFFFF2D55), // Red
        isEnabled: false,
      ),
      NotificationPreference(
        title: "Investment Alerts",
        description: "Get alerts about significant changes in your investments",
        icon: Icons.trending_up,
        iconColor: Color(0xFF5856D6), // Purple
        isEnabled: true,
      ),
      NotificationPreference(
        title: "Marketing & Promotions",
        description: "Special offers and promotions from our partners",
        icon: Icons.local_offer,
        iconColor: Color(0xFFAFB1B3), // Gray
        isEnabled: false,
      ),
    ];
  }
} 