import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TransactionDB {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'transactions.db');
    return openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE transactions (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date TEXT,  -- Stores date & time in "YYYY-MM-DD HH:mm:ss"
          description TEXT,
          amount REAL
        )
      ''');
    });
  }

  static Future<void> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    await db.insert('transactions', transaction);
  }

  static Future<List<Map<String, dynamic>>> getTransactions() async {
    final db = await database;
    return await db.query('transactions', orderBy: 'date DESC');
  }

  static Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete('transactions', where: "id = ?", whereArgs: [id]);
  }

  static Future<void> updateTransaction(int id, Map<String, dynamic> updatedTransaction) async {
    final db = await database;
    await db.update('transactions', updatedTransaction, where: "id = ?", whereArgs: [id]);
  }
}
