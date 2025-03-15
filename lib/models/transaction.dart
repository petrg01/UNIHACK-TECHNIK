class Transaction {
  final int? id;
  final String date;
  final String description;
  final double amount;

  Transaction({
    this.id,
    required this.date,
    required this.description,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'description': description,
      'amount': amount,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      date: map['date'],
      description: map['description'],
      amount: map['amount'],
    );
  }
}
