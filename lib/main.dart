import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:technik/globals.dart';
import 'screens/main_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/transactions_screen.dart';
import 'screens/prize_draw_screen.dart';
import 'screens/advisor_screen.dart';
import 'screens/navigation.dart';

Future<void> main() async {
  // Load environment variables before running the app
  await dotenv.load(fileName: ".env");
  await loadPoints();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Financial Advisor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Navigation(),
    );
  }
}
