import 'package:flutter/material.dart';
import '../db/db.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  Map<String, List<Transaction>> groupedTransactions = {};

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final data = await TransactionDB.getTransactions();
    List<Transaction> transactions = data.map((tx) => Transaction.fromMap(tx)).toList();

    // Group transactions by date
    Map<String, List<Transaction>> tempGrouped = {};
    for (var tx in transactions) {
      String formattedDate = _formatDate(tx.date);
      if (!tempGrouped.containsKey(formattedDate)) {
        tempGrouped[formattedDate] = [];
      }
      tempGrouped[formattedDate]!.add(tx);
    }

    setState(() {
      groupedTransactions = tempGrouped;
    });
  }

  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateTime today = DateTime.now();
    if (parsedDate.year == today.year &&
        parsedDate.month == today.month &&
        parsedDate.day == today.day) {
      return "Today";
    }
    return DateFormat("dd MMM. yyyy").format(parsedDate);
  }

  double _calculateTotal(List<Transaction> transactions) {
    return transactions.fold(0.0, (sum, tx) => sum + tx.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Transactions', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: groupedTransactions.entries.map((entry) {
          String date = entry.key;
          List<Transaction> transactions = entry.value;
          double total = _calculateTotal(transactions);

          // Show only the first 3 transactions initially
          List<Transaction> displayedTransactions = transactions.take(3).toList();

          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: GestureDetector(
              onTap: () => _showFullTransactionList(context, date, transactions),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF3e3d3d),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date header
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        date,
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(color: Colors.white54, height: 1),
                    // Transactions List (limited to 3)
                    ...displayedTransactions.map((tx) => _buildTransactionRow(tx)).toList(),
                    Divider(color: Colors.white54, height: 1),
                    // Total
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tap to view more",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          Row(
                            children: [
                              Text(
                                "Total: ",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${total == 0 ? '' : (total > 0 ? '+' : '')}${total.toStringAsFixed(2)}\$",
                                style: TextStyle(
                                  color: total > 0 ? Colors.green : (total < 0 ? Colors.red : Colors.white),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


Widget _buildTransactionRow(Transaction tx) {
  String time = "N/A"; // Default if time is missing
  try {
    if (tx.date.length > 10) {
      time = tx.date.substring(11, 16); // Extract time if available
    }
  } catch (e) {
    print("Error extracting time: $e");
  }

  // Correct formatting for numbers with thousand separators and exactly 2 decimal places
  final NumberFormat currencyFormatter = NumberFormat("#,##0.00", "en_US");

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Transaction Description & Time
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                tx.description, // Full name is visible
                style: TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 1, // Keep it on one line
                minFontSize: 10, // Prevents text from becoming too small
              ),
              AutoSizeText(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 12),
                maxLines: 1,
                minFontSize: 10,
              ),
            ],
          ),
        ),

        // Amount (Formatted correctly)
        Expanded(
          flex: 1,
          child: Align(
            alignment: Alignment.centerRight,
            child: AutoSizeText(
              "${tx.amount == 0 ? '' : (tx.amount > 0 ? '+' : '')}${currencyFormatter.format(tx.amount)}\$",
              style: TextStyle(
                color: tx.amount > 0 ? Colors.green : (tx.amount < 0 ? Colors.red : Colors.white),
                fontSize: 16, // Base size
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              minFontSize: 10, // Ensures text stays readable
            ),
          ),
        ),
      ],
    ),
  );
}
Future<void> _deleteTransaction(Transaction tx) async {
  await TransactionDB.deleteTransaction(tx.id!);
  setState(() {
    _loadTransactions(); // Refresh UI
  });
}

Future<bool?> _confirmDelete(BuildContext context, Transaction tx) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF3e3d3d), // Dark grey background
        title: Text("Delete Transaction", style: TextStyle(color: Colors.white)),
        content: Text(
          "Are you sure you want to delete this transaction?",
          style: TextStyle(color: Colors.white), // Now grey
        ),
        actions: [
          TextButton(
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}


 void _showFullTransactionList(BuildContext context, String date, List<Transaction> transactions) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xFF3e3d3d),
        title: Text(
          "Transactions - $date",
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.6, // Prevents overflow
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];

              return Dismissible(
                key: Key(tx.id.toString()), // Unique identifier
                direction: DismissDirection.endToStart, // Swipe left to delete
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await _confirmDelete(context, tx);
                },
                onDismissed: (direction) {
                  _deleteTransaction(tx);
                  transactions.removeAt(index); // Remove from UI
                },
                child: _buildTransactionRow(tx),
              );
            },
          ),
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

}
