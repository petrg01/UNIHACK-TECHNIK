library globals;
import 'package:shared_preferences/shared_preferences.dart';

String userName = "John Johnson";
int points = 1000;
String? profileImagePath; // Store the path to the selected profile image

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
