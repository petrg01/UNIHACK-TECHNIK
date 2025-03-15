import 'package:flutter/material.dart';
import '../widgets/dynamic_widget.dart'; // Import your custom widget
import '../db/db.dart';
import '../models/transaction.dart';

class MainScreen extends StatelessWidget {
  Future<void> _addTransaction(BuildContext context) async {
    final newTx = Transaction(
      date: DateTime.now().subtract(Duration(days: 1)).toIso8601String().substring(0, 10),
      description: "Investment - Bank of America",
      amount: -100000.2,
    );

    await TransactionDB.insertTransaction(newTx.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Transaction Added!"), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2c2c2e), // Dark background
      child: Center(
        child: DynamicWidget(
          width: 365,
          cornerRadius: 45,
          height: 100, // Fixed height
          color: Color(0xFF50C878), // Green button color
          onTap: () => _addTransaction(context), // Calls function on tap
          child: Center(
            child: Text(
              "Add Transaction",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
