import 'package:flutter/material.dart';

class Goal {
  final String title;
  final String description;
  final double currentAmount;
  final double targetAmount;
  final DateTime? targetDate;
  final String category;
  final Color? categoryColor;

  Goal({
    required this.title,
    required this.description,
    required this.currentAmount,
    required this.targetAmount,
    this.targetDate,
    required this.category,
    this.categoryColor,
  });

  double get progressPercentage => currentAmount / targetAmount;
}

class GoalsList extends StatelessWidget {
  final List<Goal> goals;
  final Function(Goal)? onGoalTap;
  final Function(Goal)? onGoalRemoved;

  const GoalsList({
    super.key,
    required this.goals,
    this.onGoalTap,
    this.onGoalRemoved,
  });

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "You don't have any goals yet. Set some financial goals to track your progress!",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: goals.map((goal) => _buildDismissibleGoalItem(goal, context)).toList(),
    );
  }

  Widget _buildDismissibleGoalItem(Goal goal, BuildContext context) {
    return Dismissible(
      key: Key(goal.title), // Ideally use a unique ID for each goal
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (onGoalRemoved != null) {
          onGoalRemoved!(goal);
        }
      },
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF3c3c3e),
              title: Text(
                "Delete Goal",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Are you sure you want to delete this goal?",
                style: TextStyle(color: Colors.white70),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: _buildGoalItem(goal, context),
    );
  }

  Widget _buildGoalItem(Goal goal, BuildContext context) {
    return InkWell(
      onTap: onGoalTap != null ? () => onGoalTap!(goal) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Color(0xFF2c2c2e),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and category
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: goal.categoryColor ?? Color(0xFF4CD964),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    goal.category,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            
            // Description
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: Text(
                goal.description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: goal.progressPercentage,
                backgroundColor: Colors.grey[800],
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CD964)),
                minHeight: 10,
              ),
            ),
            
            // Progress details
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${goal.currentAmount.toStringAsFixed(2)} of \$${goal.targetAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (goal.targetDate != null)
                    Text(
                      'By ${_formatDate(goal.targetDate!)}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
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