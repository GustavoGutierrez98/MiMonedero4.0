// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:mimonedero/models/pagos.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mimonedero/models/ingreso.dart';

class BalanceDatabase {
  static final BalanceDatabase instance = BalanceDatabase._init();
  static Database? _database;

  BalanceDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'balance_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE balances(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        date TEXT
      )
    ''');
  }

  

  Future<int> insertBalance(Balance balance) async {
    final db = await database;
    return await db.insert('balances', balance.toMap());
  }

  Future<List<Balance>> getAllBalances() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('balances');
    return List.generate(maps.length, (i) {
      return Balance(
        id: maps[i]['id'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
      );
    });
  }
}
class PaymentDatabase {
  static final PaymentDatabase instance = PaymentDatabase._init();
  static Database? _database;

  PaymentDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'payment_database.db');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amount REAL,
        date TEXT,
        category TEXT,
        type TEXT
      )
    """);
  }

  Future<int> insertPayment(Payment payment) async {
    final db = await database;
    return await db.insert('payments', payment.toMap());
  }

  Future<List<Payment>> getAllPayments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('payments');
    return List.generate(maps.length, (i) {
      return Payment(
        id: maps[i]['id'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        category:maps[i]['category'], 
        type: maps[i]['type'],
      );
    });
  }
}