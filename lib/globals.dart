library globals;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technik/widgets/friends_list.dart';
import 'package:technik/data/friends_data.dart';

String userName = "John Johnson";
int points = 1000;
String? profileImagePath; // Store the path to the selected profile image
List<Friend> userFriends = []; // Store the user's friends

Future<void> loadPoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  points = prefs.getInt('points') ?? 1000;
}

Future<void> savePoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('points', points);
}

// Load profile image path from SharedPreferences
Future<void> loadProfileImage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  profileImagePath = prefs.getString('profileImagePath');
}

// Save profile image path to SharedPreferences
Future<void> saveProfileImage() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (profileImagePath != null) {
    await prefs.setString('profileImagePath', profileImagePath!);
  }
}

// Load friends from SharedPreferences
Future<void> loadFriends() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final friendsJson = prefs.getStringList('userFriends');
  
  if (friendsJson != null && friendsJson.isNotEmpty) {
    userFriends = friendsJson.map((friendString) {
      final Map<String, dynamic> friendMap = json.decode(friendString);
      return Friend(
        name: friendMap['name'],
        status: friendMap['status'],
        avatarUrl: friendMap['avatarUrl'],
      );
    }).toList();
  } else {
    // Initialize with sample friends data if no saved friends
    userFriends = FriendsData.getSampleFriends();
  }
}

// Save friends to SharedPreferences
Future<void> saveFriends() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> friendsJson = userFriends.map((friend) {
    return json.encode({
      'name': friend.name,
      'status': friend.status,
      'avatarUrl': friend.avatarUrl,
    });
  }).toList();
  
  await prefs.setStringList('userFriends', friendsJson);
}

// Add a new friend and save to SharedPreferences
Future<void> addFriend(Friend newFriend) async {
  userFriends.add(newFriend);
  await saveFriends();
}

// Remove a friend and save to SharedPreferences
Future<void> removeFriend(Friend friend) async {
  userFriends.removeWhere((f) => f.name == friend.name);
  await saveFriends();
}
