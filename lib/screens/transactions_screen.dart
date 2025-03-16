// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:technik/globals.dart';
import 'package:technik/widgets/header_widget.dart';
import '../db/db.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

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
    final NumberFormat currencyFormatter = NumberFormat("#,##0.00", "en_US");

    return Scaffold(
      backgroundColor: Color(0xFF2c2c2e),
      body: Column(
        children: [
          HeaderWidget(userName: userName), 
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: groupedTransactions.entries.map((entry) {
                String date = entry.key;
                List<Transaction> transactions = entry.value;
                double total = _calculateTotal(transactions);

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
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              date,
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(color: Colors.white54, height: 1),
                          ...displayedTransactions.map((tx) => _buildTransactionRow(tx)).toList(),
                          Divider(color: Colors.white54, height: 1),
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
                                        "${total == 0 ? '' : (total > 0 ? '+' : '')}${currencyFormatter.format(total)}\$",
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
          ),
        ],
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
        // Transaction Description & Time + Category
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                tx.description, // Full description
                style: TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 1, 
                minFontSize: 10,
              ),
              Row(
                children: [
                  AutoSizeText(
                    time,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    minFontSize: 10,
                  ),
                  if (tx.category?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: AutoSizeText(
                        tx.category!,
                        style: TextStyle(color: Colors.amberAccent, fontSize: 12),
                        maxLines: 1,
                        minFontSize: 10,
                      ),
                    ),
                ],
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              minFontSize: 10,
            ),
          ),
        ),
      ],
    ),
  );
}


Future<void> _deleteTransaction(Transaction tx) async {
    await TransactionDB.deleteTransaction(tx.id!);
    await _loadTransactions(); // Refresh UI after deletion completes
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
      // Wrap the dialog in a StatefulBuilder to allow local updates
      return StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setStateDialog) {
          return AlertDialog(
            backgroundColor: Color(0xFF3e3d3d),
            title: Text(
              "Transactions - $date",
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.6,
              // Reload the transactions from the DB so that any updates are reflected
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: TransactionDB.getTransactions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading transactions", style: TextStyle(color: Colors.white)));
                  }
                  // Convert the raw data into Transaction objects
                  List<Transaction> allTransactions = snapshot.data!
                      .map((tx) => Transaction.fromMap(tx))
                      .toList();
                  // Filter transactions for the specific date
                  List<Transaction> filteredTransactions = allTransactions.where((tx) {
                    return _formatDate(tx.date) == date;
                  }).toList();

                  if(filteredTransactions.isEmpty) {
                    return Center(child: Text("No transactions for this date", style: TextStyle(color: Colors.white)));
                  }

                  return ListView.builder(
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = filteredTransactions[index];
                      return Dismissible(
                        key: Key(tx.id.toString()),
                        background: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.blue,
                          child: Icon(Icons.edit, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: DismissDirection.horizontal,
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            // Delete case
                            bool? confirmed = await _confirmDelete(context, tx);
                            if (confirmed == true) {
                              await _deleteTransaction(tx);
                              // Refresh the dialog state
                              setStateDialog(() {});
                              return true;
                            }
                            return false;
                          } else if (direction == DismissDirection.startToEnd) {
                            // Edit case
                            _showEditDialog(context, tx, () async {
                                    await _loadTransactions(); // Explicitly reload transactions
                                    setStateDialog(() {});     // Refresh the list dialog after editing
                                  });
                            return false;
                          }
                          return false;
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFF3e3d3d),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _buildTransactionRow(tx),
                        ),
                      );
                    },
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
    },
  );
}


void _showEditDialog(BuildContext context, Transaction tx, VoidCallback onTransactionUpdated) {
  TextEditingController descController =
      TextEditingController(text: tx.description);

  DateTime selectedDateTime = DateTime.parse(tx.date);

  final List<String> withdrawalCategories = [
    "Food", "Transport", "Entertainment", "Bills", "Personal Care",
    "Healthcare", "Education", "Debt Payments", "Shopping", "Travel",
    "Gifts & Holidays", "Charity & Donations", "Other"
  ];

  final List<String> depositCategories = [
    "Salary", "Investment", "Gift", "Other"
  ];

  bool isWithdrawal = tx.amount < 0;
  String transactionType = isWithdrawal ? "Withdrawal" : "Deposit";
  String selectedCategory = (tx.category != null && tx.category!.isNotEmpty)
      ? tx.category!
      : (isWithdrawal ? withdrawalCategories[0] : depositCategories[0]);

  TextEditingController amountEditingController =
      TextEditingController(text: tx.amount.abs().toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            backgroundColor: Color(0xFF3e3d3d),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text("Edit Transaction", style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Transaction Type (Withdrawal or Deposit)
                  DropdownButtonFormField<String>(
                    value: transactionType,
                    dropdownColor: Color(0xFF2c2c2e),
                    items: ["Withdrawal", "Deposit"].map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type, style: TextStyle(color: Colors.white)),
                    )).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        transactionType = value!;
                        selectedCategory = transactionType == "Withdrawal"
                            ? withdrawalCategories[0]
                            : depositCategories[0];
                      });
                    },
                  ),

                  SizedBox(height: 10),

                  // Category Selection
                  DropdownButtonFormField<String>(
                    dropdownColor: Color(0xFF3e3d3d),
                    value: selectedCategory,
                    items: (transactionType == "Withdrawal"
                            ? withdrawalCategories
                            : depositCategories)
                        .map((String category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  // Date selector
                  GestureDetector(
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setStateDialog(() => selectedDateTime = pickedDate);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF2c2c2e),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDateTime)}", style: TextStyle(color: Colors.white)),
                          Icon(Icons.calendar_today, color: Colors.white54),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Description input
                  TextField(
                    controller: descController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Description",
                      labelStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Color(0xFF2c2c2e),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 10),
                  // Amount input
                  TextField(
                    controller: amountEditingController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: "Amount",
                      labelStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Save", style: TextStyle(color: Colors.blue)),
                onPressed: () async {
                  double amount = double.parse(amountEditingController.text);
                  amount = transactionType == "Withdrawal" ? -amount.abs() : amount.abs();
                  await TransactionDB.updateTransaction(tx.id!, {
                    'date': DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDateTime),
                    'description': descController.text,
                    'amount': amount,
                    'category': selectedCategory,
                  });
    
                  Navigator.pop(context);
                  await _loadTransactions();  
                  onTransactionUpdated();    
                },
              ),
            ],
          );
        },
      );
    },
  );
}


}
