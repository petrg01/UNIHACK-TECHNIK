import 'package:flutter/material.dart';

class Subscription {
  final String name;
  final String description;
  final double price;
  final String period; // monthly, yearly, etc.
  final DateTime renewalDate;
  final bool isActive;
  final Color? color;

  Subscription({
    required this.name,
    required this.description,
    required this.price,
    required this.period,
    required this.renewalDate,
    required this.isActive,
    this.color,
  });
}

class SubscriptionList extends StatelessWidget {
  final List<Subscription> subscriptions;
  final Function(Subscription)? onSubscriptionTap;
  final Function(Subscription, bool)? onSubscriptionToggle;

  const SubscriptionList({
    Key? key,
    required this.subscriptions,
    this.onSubscriptionTap,
    this.onSubscriptionToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subscriptions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "You don't have any active subscriptions.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            "Manage your current subscriptions:",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ),
        ...subscriptions.map((sub) => _buildSubscriptionItem(sub, context)).toList(),
        
        SizedBox(height: 20),
        Row(
          children: [
            _buildInfoItem("Active", 
              "${subscriptions.where((s) => s.isActive).length}"),
            SizedBox(width: 16),
            _buildInfoItem("Monthly cost", 
              "\$${_calculateMonthlyCost().toStringAsFixed(2)}"),
            SizedBox(width: 16),
            _buildInfoItem("Annual cost", 
              "\$${(_calculateMonthlyCost() * 12).toStringAsFixed(2)}"),
          ],
        ),
      ],
    );
  }
  
  double _calculateMonthlyCost() {
    double monthlyCost = 0;
    for (var sub in subscriptions) {
      if (sub.isActive) {
        if (sub.period.toLowerCase() == "monthly") {
          monthlyCost += sub.price;
        } else if (sub.period.toLowerCase() == "yearly" || 
                  sub.period.toLowerCase() == "annual") {
          monthlyCost += sub.price / 12;
        } else if (sub.period.toLowerCase() == "quarterly") {
          monthlyCost += sub.price / 3;
        }
      }
    }
    return monthlyCost;
  }
  
  Widget _buildInfoItem(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color(0xFF2c2c2e),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionItem(Subscription subscription, BuildContext context) {
    return InkWell(
      onTap: onSubscriptionTap != null 
        ? () => onSubscriptionTap!(subscription) 
        : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color(0xFF2c2c2e),
          borderRadius: BorderRadius.circular(12),
          border: subscription.isActive 
            ? Border.all(color: subscription.color ?? Color(0xFF4CD964), width: 1) 
            : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Logo/Icon placeholder
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: subscription.color ?? Color(0xFF4CD964),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      subscription.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Subscription details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        subscription.description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Toggle switch
                Switch(
                  value: subscription.isActive,
                  onChanged: onSubscriptionToggle != null 
                    ? (value) => onSubscriptionToggle!(subscription, value) 
                    : null,
                  activeColor: subscription.color ?? Color(0xFF4CD964),
                  activeTrackColor: (subscription.color ?? Color(0xFF4CD964)).withOpacity(0.4),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Price and renewal info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${subscription.price.toStringAsFixed(2)}/${subscription.period}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Renews: ${_formatDate(subscription.renewalDate)}",
                  style: TextStyle(
                    color: subscription.isActive ? Colors.white70 : Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
} 