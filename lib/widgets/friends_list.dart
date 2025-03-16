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
  final Function(Friend)? onFriendRemoved;

  const FriendsList({
    Key? key,
    required this.friends,
    this.onFriendTap,
    this.onFriendRemoved,
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
      children: friends.map((friend) => _buildDismissibleFriendItem(friend, context)).toList(),
    );
  }

  Widget _buildDismissibleFriendItem(Friend friend, BuildContext context) {
    return Dismissible(
      key: Key(friend.name), // Unique key for each item
      background: _buildDismissibleBackground(),
      direction: DismissDirection.endToStart, // Only allow right to left swipe
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color(0xFF3c3c3e),
              title: Text(
                "Remove Friend",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "Are you sure you want to remove @${friend.name} from your friends list?",
                style: TextStyle(color: Colors.white70),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text(
                    "Remove",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Call the callback to remove the friend
        if (onFriendRemoved != null) {
          onFriendRemoved!(friend);
        }
      },
      child: _buildFriendItem(friend, context),
    );
  }

  // Background widget shown when swiping the item
  Widget _buildDismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Remove",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
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