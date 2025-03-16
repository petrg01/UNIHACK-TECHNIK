import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:technik/globals.dart';
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
import 'package:technik/widgets/add_friend_form.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../widgets/header_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // List of goals that can be updated when a new goal is added
  List<Goal> _goals = [];
  // Instance of ImagePicker to pick images from gallery
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize with sample goals
    _goals = GoalsData.getSampleGoals();
    // Load profile image if available
    _loadProfileImage();
    // Load friends data
    _loadFriendsData();
  }
  
  // Load profile image from shared preferences
  Future<void> _loadProfileImage() async {
    await loadProfileImage();
    // Update UI if image path is loaded
    if (mounted) {
      setState(() {});
    }
  }
  
  // Load friends data from shared preferences
  Future<void> _loadFriendsData() async {
    await loadFriends();
    // Update UI if needed
    if (mounted) {
      setState(() {});
    }
  }
  
  // Function to pick image from gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );
      
      if (pickedImage != null) {
        setState(() {
          profileImagePath = pickedImage.path;
        });
        // Save the profile image path
        await saveProfileImage();
      }
    } catch (e) {
      // Show error message if image picking fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick image: $e"),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  //final String userName = "John Johnson";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              //HeaderWidget(userName: userName),
              SizedBox(height: 60),
              // Profile Picture
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
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
                            color: profileImagePath == null ? Colors.pink[50] : null,
                            child: profileImagePath == null 
                                ? _buildDefaultProfileIcon() 
                                : _buildProfileImage(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Color(0xFF4CD964),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // User Name
              Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
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
              GestureDetector(
  onTap: () => _showStatementsPopup(context),  // ✅ Corrected function call
  child: Container(
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
),

              SizedBox(height: 30),
              // Financial Health and Credit Rating Cards
              Row(
                children: [
                  GestureDetector(
  onTap: () => _showFinancialHealthPopup(context),
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
                      onTap: () => _showCreditRatingPopup(context),
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


void _showCreditRatingPopup(BuildContext context) {
  // Calculate credit rating using given data
  double creditScore = calculateCreditScore(
    paymentHistory: 95, 
    creditUtilization: 25, 
    creditAge: 5, 
    creditMix: 3, 
    newCreditInquiries: 2
  );

  // Determine credit rating category
  String ratingText;
  Color ratingColor;

  if (creditScore >= 800) {
    ratingText = "Excellent";
    ratingColor = Colors.green;
  } else if (creditScore >= 740) {
    ratingText = "Very Good";
    ratingColor = Colors.lightGreen;
  } else if (creditScore >= 670) {
    ratingText = "Good";
    ratingColor = Colors.yellow;
  } else if (creditScore >= 580) {
    ratingText = "Fair";
    ratingColor = Colors.orange;
  } else {
    ratingText = "Poor";
    ratingColor = Colors.red;
  }

  // Show Credit Rating Popup
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF2c2c2e), // Dark theme
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Text(
              "Credit Rating",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(height: 20),

            // Credit Score Display
            Text(
              "${creditScore.toStringAsFixed(0)} - $ratingText",
              style: TextStyle(
                color: ratingColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),

            // Improvement Suggestions
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("✅ Pay Bills on Time – Avoid late payments.", style: _tipStyle()),
                  Text("✅ Keep Credit Utilization Low – Aim below 30%.", style: _tipStyle()),
                  Text("✅ Don't Apply for Too Many Loans – Avoid frequent hard inquiries.", style: _tipStyle()),
                  Text("✅ Maintain Long Credit History – Keep old accounts open.", style: _tipStyle()),
                  Text("✅ Diversify Credit Types – Have a mix of credit cards, loans, and mortgages.", style: _tipStyle()),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close", style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}

// Helper Text Style for Suggestions
TextStyle _tipStyle() {
  return TextStyle(color: Colors.white70, fontSize: 16);
}

// Function to Calculate Credit Score
double calculateCreditScore({
  required double paymentHistory,  // 0-100%
  required double creditUtilization,  // 0-100%
  required double creditAge,  // in years
  required int creditMix,  // Number of credit types
  required int newCreditInquiries,  // Recent hard inquiries
}) {
  double score = (0.35 * (paymentHistory * 8.5)) +  // Normalize 100% -> 850 scale
                 (0.30 * ((100 - creditUtilization) * 8.5)) + // Lower is better
                 (0.15 * (creditAge * 50)) + // Normalize age impact
                 (0.10 * (creditMix * 80)) + // More diverse = better
                 (0.10 * ((5 - newCreditInquiries) * 100)); // Fewer = better

  return score.clamp(300, 850); // Ensure within range
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
          },
          child: Text(
            "Close",
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

  void _showAddFriendForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Color(0xFF3c3c3e),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          // Add extra padding when keyboard appears
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: AddFriendForm(
            onFriendAdded: (Friend newFriend) async {
              // Add the new friend to global list
              await addFriend(newFriend);
              
              // Close the form
              Navigator.pop(context);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Friend @${newFriend.name} added successfully!"),
                  backgroundColor: Color(0xFF4CD964),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              
              // Update UI
              setState(() {});
              
              // Show the updated friends list
              _showFriendsPopup(context);
            },
          ),
        ),
      ),
    );
  }

  void _showFriendsPopup(BuildContext context) {
    // Use the global friends list instead of sample data
    final friends = userFriends;

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
              content: Text("Selected username: @${friend.name}"),
              backgroundColor: Color(0xFF4CD964), // Green color
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onFriendRemoved: (friend) async {
          // Remove the friend from the global list
          await removeFriend(friend);
          
          // Update UI
          setState(() {});
          
          // Show a snackbar to confirm removal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("@${friend.name} removed from your friends list"),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'UNDO',
                textColor: Colors.white,
                onPressed: () async {
                  // Add the friend back if user taps undo
                  await addFriend(friend);
                  
                  // Update UI
                  setState(() {});
                  
                  // Show the friends list with the restored friend
                  _showFriendsPopup(context);
                  
                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("@${friend.name} added back to your friends list"),
                      backgroundColor: Color(0xFF4CD964),
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
            // Show the Add Friend form
            _showAddFriendForm(context);
          },
          child: Text(
            "Add Friend",
            style: TextStyle(color: Color(0xFF4CD964)),
          ),
        ),
      ],
    );
  }

  void _showStatementsPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF2c2c2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Center(
          child: Text(
            "Bank Statements",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickStatementFile(),
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text("Upload Statement"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4CD964),
                foregroundColor: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            _buildTransactionsList(),
          ],
        ),
      );
    },
  );
}

List<String> transactions = [];

Future<void> _pickStatementFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'txt'], // Restrict to CSV and text files
  );

  if (result != null) {
    File file = File(result.files.single.path!);
    String content = await file.readAsString();

    // Parse transactions (assuming CSV format with each line as a transaction)
    List<String> lines = content.split("\n");
    setState(() {
      transactions = lines.where((line) => line.isNotEmpty).toList();
    });

    // Refresh popup to show transactions
    Navigator.pop(context); 
    _showStatementsPopup(context);
  }
}

Widget _buildTransactionsList() {
  if (transactions.isEmpty) {
    return Text(
      "No transactions uploaded yet.",
      style: TextStyle(color: Colors.white70, fontSize: 16),
    );
  }

  return Container(
    height: 200,
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.monetization_on, color: Colors.white),
          title: Text(
            transactions[index],
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    ),
  );
}

void _showFinancialHealthPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF2c2c2e), // Dark mode background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Financial Health",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // Circular Indicator
            CircularPercentIndicator(
              radius: 70.0,
              lineWidth: 10.0,
              percent: 0.35, // 35% financial health
              center: Text(
                "35%",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              progressColor: Colors.yellowAccent,
              backgroundColor: Colors.white24,
              circularStrokeCap: CircularStrokeCap.round,
            ),

            SizedBox(height: 10),
            Text(
              "Basic Level",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            Divider(color: Colors.white24, height: 30),

            // Financial Categories Breakdown
            _buildFinancialHealthItem(Icons.shopping_cart, "Expenses", "50%", "You spent less than you earned."),
            _buildFinancialHealthItem(Icons.savings, "Savings", "0%", "Start building your savings."),
            _buildFinancialHealthItem(Icons.trending_up, "Investments", "0%", "Get your first portfolio recommendation."),
            _buildFinancialHealthItem(Icons.security, "Protection", "0%", "You have no emergency fund."),
          ],
        ),
      );
    },
  );
}

// Function to Build Each Financial Item
Widget _buildFinancialHealthItem(IconData icon, String title, String value, String description) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title – $value",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              description,
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
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
  VoidCallback? onTap, // 👈 Add this parameter
}) {
  return GestureDetector(
    onTap: onTap, // 👈 Allow tapping the card
    child: Container(
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
    ),
  );
}


  // Helper method to build the default profile icon
  Widget _buildDefaultProfileIcon() {
    return Icon(
      Icons.person,
      size: 60,
      color: Colors.black54,
    );
  }
  
  // Helper method to build the profile image with error handling
  Widget _buildProfileImage() {
    final file = File(profileImagePath!);
    
    // Check if file exists
    if (!file.existsSync()) {
      // If file doesn't exist, reset the path and return default icon
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          profileImagePath = null;
        });
      });
      return _buildDefaultProfileIcon();
    }
    
    // Otherwise try to load the image with error handling
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: 90,
      height: 90,
      errorBuilder: (context, error, stackTrace) {
        // If there's an error loading the image, log it and return default icon
        print('Error loading profile image: $error');
        
        // Reset path on next frame to avoid repeated errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            profileImagePath = null;
          });
        });
        
        return _buildDefaultProfileIcon();
      },
    );
  }
}