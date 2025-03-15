import 'package:flutter/material.dart';
import 'package:technik/widgets/custom_popup.dart';
import 'package:technik/widgets/friends_list.dart';
import 'package:technik/data/friends_data.dart';
import 'package:technik/widgets/goals_list.dart';
import 'package:technik/data/goals_data.dart';
import 'package:technik/widgets/notification_preferences_list.dart';
import 'package:technik/data/notification_preferences_data.dart';
import 'package:technik/widgets/subscription_list.dart';
import 'package:technik/data/subscription_data.dart';
import 'package:technik/widgets/add_goal_form.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // List of goals that can be updated when a new goal is added
  List<Goal> _goals = [];
  String _userName = "John Johnson";

  @override
  void initState() {
    super.initState();
    // Initialize with sample goals
    _goals = GoalsData.getSampleGoals();
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: _userName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF3e3d3e),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Edit Profile Name",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Name",
              labelStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFF2c2c2e),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    _userName = nameController.text.trim();
                  });
                  Navigator.of(context).pop();
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Profile name updated"),
                      backgroundColor: Color(0xFF4CD964),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Color(0xFF4CD964)),
              ),
            ),
          ],
        );
      },
    );
  }

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
              // User Name with Edit Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  InkWell(
                    onTap: () => _showEditNameDialog(context),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Color(0xFF4CD964).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                        color: Color(0xFF4CD964),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Quick Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.menu_book_outlined,
                    label: "Subscriptions",
                    onTap: () => _showSubscriptionsPopup(context),
                  ),
                  _buildActionButton(
                    icon: Icons.notifications_none,
                    label: "Notification",
                    onTap: () => _showNotificationPreferencesPopup(context),
                  ),
                  _buildActionButton(
                    icon: Icons.fitness_center,
                    label: "Goals",
                    onTap: () => _showGoalsPopup(context),
                  ),
                  _buildActionButton(
                    icon: Icons.person,
                    label: "Friends",
                    onTap: () => _showFriendsPopup(context),
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
  
  void _showAddGoalForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF3c3c3e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.all(20),
        child: AddGoalForm(
          onGoalAdded: (Goal newGoal) {
            // Add the new goal to the list
            setState(() {
              _goals.add(newGoal);
            });
            
            // Close the goals popup and show a success message
            Navigator.pop(context); // Close the bottom sheet
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Goal '${newGoal.title}' added successfully!"),
                backgroundColor: newGoal.categoryColor ?? Color(0xFF4CD964),
                behavior: SnackBarBehavior.floating,
              ),
            );
            
            // Show the updated goals list
            _showGoalsPopup(context);
          },
        ),
      ),
    );
  }
  
  void _showSubscriptionsPopup(BuildContext context) {
    // Get sample subscriptions data
    final subscriptions = SubscriptionData.getSampleSubscriptions();
    
    // Local variable to track changes
    List<Subscription> updatedSubscriptions = List.from(subscriptions);

    // Show the custom popup with subscriptions list
    CustomPopup.show(
      context: context,
      title: "Your Subscriptions",
      content: SubscriptionList(
        subscriptions: updatedSubscriptions,
        onSubscriptionTap: (subscription) {
          // Here you could navigate to a subscription details screen
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Subscription details: ${subscription.name}"),
              backgroundColor: subscription.color ?? Color(0xFF4CD964),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onSubscriptionToggle: (subscription, isActive) {
          // Update the toggled subscription status
          final index = updatedSubscriptions.indexOf(subscription);
          if (index != -1) {
            updatedSubscriptions[index] = Subscription(
              name: subscription.name,
              description: subscription.description,
              price: subscription.price,
              period: subscription.period,
              renewalDate: subscription.renewalDate,
              isActive: isActive,
              color: subscription.color,
            );
            // Note: In a real app, you would persist this change
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Show a message that subscriptions settings are saved
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Subscription preferences saved"),
                backgroundColor: Color(0xFF4CD964),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            "Save",
            style: TextStyle(color: Color(0xFF4CD964)),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Here you could navigate to a 'Add Subscription' screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Add subscription feature coming soon!"),
                backgroundColor: Color(0xFF4CD964),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            "Add New",
            style: TextStyle(color: Color(0xFF4CD964)),
          ),
        ),
      ],
    );
  }

  void _showNotificationPreferencesPopup(BuildContext context) {
    // Get sample notification preferences data
    final preferences = NotificationPreferencesData.getSamplePreferences();

    // Show the custom popup with notification preferences list
    CustomPopup.show(
      context: context,
      title: "Notification Settings",
      content: NotificationPreferencesList(
        preferences: preferences,
        onPreferencesChanged: (updatedPreferences) {
          // Here you would typically save these preferences to a backend
          print("Preferences updated");
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Notification preferences saved"),
                backgroundColor: Color(0xFF4CD964),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            "Save",
            style: TextStyle(color: Color(0xFF4CD964)),
          ),
        ),
      ],
    );
  }

  void _showGoalsPopup(BuildContext context) {
    // Use the managed goals list instead of getting sample goals
    final goals = _goals;

    // Show the custom popup with goals list
    CustomPopup.show(
      context: context,
      title: "Your Financial Goals",
      content: GoalsList(
        goals: goals,
        onGoalTap: (goal) {
          // Close the popup
          Navigator.of(context).pop();
          
          // Show a snackbar to demonstrate the action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Goal details: ${goal.title}"),
              backgroundColor: goal.categoryColor ?? Color(0xFF4CD964),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onGoalRemoved: (goal) {
          // Remove the goal from the list
          setState(() {
            _goals.remove(goal);
          });
          
          // Show a snackbar to confirm deletion
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Goal '${goal.title}' removed"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'UNDO',
                textColor: Colors.white,
                onPressed: () {
                  // Add the goal back if user taps undo
                  setState(() {
                    _goals.add(goal);
                    // Sort goals to maintain original order (optional)
                    // _goals.sort((a, b) => a.title.compareTo(b.title));
                  });
                  
                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Goal '${goal.title}' restored"),
                      backgroundColor: goal.categoryColor ?? Color(0xFF4CD964),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Open the Add Goal form
            _showAddGoalForm(context);
          },
          child: Text(
            "Add Goal",
            style: TextStyle(color: Color(0xFF4CD964)),
          ),
        ),
      ],
    );
  }

  void _showFriendsPopup(BuildContext context) {
    // Get sample friends data
    final friends = FriendsData.getSampleFriends();

    // Show the custom popup with friends list
    CustomPopup.show(
      context: context,
      title: "Your Friends",
      content: FriendsList(
        friends: friends,
        onFriendTap: (friend) {
          // Close the popup
          Navigator.of(context).pop();
          
          // Show a snackbar to demonstrate the action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Selected friend: ${friend.name}"),
              backgroundColor: Color(0xFF4CD964), // Green color
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Here you could navigate to a 'Add Friend' screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Add friend feature coming soon!"),
                backgroundColor: Color(0xFF4CD964), // Green color
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            "Add Friend",
            style: TextStyle(color: Color(0xFF4CD964)),
          ),
        ),
      ],
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
