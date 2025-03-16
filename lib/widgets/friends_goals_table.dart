import 'package:flutter/material.dart';
import 'package:technik/widgets/friends_list.dart';
import 'package:technik/widgets/goals_list.dart';

class FriendsGoalsTable extends StatelessWidget {
  final List<Friend> friends;
  final Map<String, List<Goal>> friendsGoals;

  const FriendsGoalsTable({
    Key? key,
    required this.friends,
    required this.friendsGoals,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "You don't have any friends yet. Add friends to see their progress!",
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
          padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
          child: Text(
            "Friends' Progress",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF3c3c3e),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 16,
                headingRowColor: MaterialStateProperty.all(Color(0xFF2c2c2e)),
                headingTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                dataTextStyle: TextStyle(
                  color: Colors.white,
                ),
                columns: [
                  DataColumn(
                    label: Text('Friend'),
                  ),
                  DataColumn(
                    label: Text('Goal'),
                  ),
                  DataColumn(
                    label: Text('Progress'),
                    numeric: true,
                  ),
                  DataColumn(
                    label: Text('Status'),
                  ),
                ],
                rows: _buildRows(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<DataRow> _buildRows() {
    List<DataRow> rows = [];
    
    for (var friend in friends) {
      final friendGoals = friendsGoals[friend.name] ?? [];
      
      if (friendGoals.isEmpty) {
        // If friend has no goals, add a single row
        rows.add(
          DataRow(
            cells: [
              DataCell(_buildFriendCell(friend)),
              DataCell(Text('No goals yet', style: TextStyle(color: Colors.white70))),
              DataCell(Text('-')),
              DataCell(Text('-')),
            ],
          ),
        );
      } else {
        // For friends with goals, add a row for each goal
        for (int i = 0; i < friendGoals.length; i++) {
          final goal = friendGoals[i];
          rows.add(
            DataRow(
              cells: [
                // Only show friend's name on the first goal row
                DataCell(i == 0 ? _buildFriendCell(friend) : SizedBox()),
                DataCell(_buildGoalCell(goal)),
                DataCell(_buildProgressCell(goal)),
                DataCell(_buildStatusCell(goal)),
              ],
            ),
          );
        }
      }
    }
    
    return rows;
  }

  Widget _buildFriendCell(Friend friend) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "@",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(friend.name),
      ],
    );
  }

  Widget _buildGoalCell(Goal goal) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: goal.categoryColor ?? Color(0xFF4CD964),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8),
        Text(goal.title),
      ],
    );
  }

  Widget _buildProgressCell(Goal goal) {
    final progressPercent = (goal.progressPercentage * 100).toInt();
    return Text('$progressPercent%');
  }

  Widget _buildStatusCell(Goal goal) {
    final progress = goal.progressPercentage;
    
    Color statusColor;
    String statusText;
    
    if (progress >= 1.0) {
      statusColor = Colors.green;
      statusText = 'Completed';
    } else if (progress >= 0.75) {
      statusColor = Colors.lightGreen;
      statusText = 'Almost there';
    } else if (progress >= 0.5) {
      statusColor = Colors.amber;
      statusText = 'Halfway';
    } else if (progress >= 0.25) {
      statusColor = Colors.orange;
      statusText = 'Started';
    } else {
      statusColor = Colors.red;
      statusText = 'Just began';
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 