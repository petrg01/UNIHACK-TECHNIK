import 'package:flutter/material.dart';

class Friend {
  final String name;
  final String? avatarUrl;
  final String? status;

  Friend({
    required this.name,
    this.avatarUrl,
    this.status,
  });
}

class FriendsList extends StatelessWidget {
  final List<Friend> friends;
  final Function(Friend)? onFriendTap;

  const FriendsList({
    Key? key,
    required this.friends,
    this.onFriendTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (friends.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "You don't have any friends yet.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: friends.map((friend) => _buildFriendItem(friend, context)).toList(),
    );
  }

  Widget _buildFriendItem(Friend friend, BuildContext context) {
    return InkWell(
      onTap: onFriendTap != null ? () => onFriendTap!(friend) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Color(0xFF2c2c2e),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Avatar with @ symbol to indicate username
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "@",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Username
            Expanded(
              child: Text(
                friend.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Chevron icon
            Icon(
              Icons.chevron_right,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
} 