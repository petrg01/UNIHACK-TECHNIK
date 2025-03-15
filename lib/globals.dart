library globals;
import 'package:shared_preferences/shared_preferences.dart';

String userName = "John Johnson";
int points = 1000;

Future<void> loadPoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  points = prefs.getInt('points') ?? 1000;
}

Future<void> savePoints() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('points', points);
}
