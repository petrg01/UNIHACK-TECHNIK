import 'package:flutter/material.dart';
import '../db/db.dart'; // Adjust the import path as needed
import '../models/transaction.dart'; // Assuming you have a Transaction model with a fromMap constructor

class TransactionsScreenTest extends StatefulWidget {
  @override
  _TransactionsScreenTestState createState() => _TransactionsScreenTestState();
}

class _TransactionsScreenTestState extends State<TransactionsScreenTest> {
  late Future<List<Map<String, dynamic>>> transactionsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch transactions from the database
    transactionsFuture = TransactionDB.getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No transactions found.'));
          } else {
            // Convert the raw data into a list of Transaction objects.
            final transactions = snapshot.data!
                .map((txMap) => Transaction.fromMap(txMap))
                .toList();
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  title: Text(tx.description),
                  subtitle: Text(tx.date),
                  trailing: Text('\$${tx.amount.toString()}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
