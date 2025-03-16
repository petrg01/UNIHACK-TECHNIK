import 'package:flutter/foundation.dart';

class Transaction {
  final int? id;
  final String date;
  final String description;
  final double amount;
  final String? category; // New field for category

  Transaction({
    this.id,
    required this.date,
    required this.description,
    required this.amount,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'description': description,
      'amount': amount,
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      date: map['date'],
      description: map['description'],
      amount: map['amount'],
      category: map['category'] ?? '', // default to empty string if null
    );
  }
}
