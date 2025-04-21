import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:myexpenseproject/models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];
  final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;

  // Get all transactions
  List<Transaction> get transactions => _transactions;

  // Add a new transaction (local + Firestore)
  void addTransaction(Transaction transaction) async {
    _transactions.add(transaction);
    notifyListeners();

    // Save to Firestore
    await _firestore.collection('transactions').doc(transaction.id).set({
      'id': transaction.id,
      'amount': transaction.amount,
      'title': transaction.title,
      'date': transaction.date.toIso8601String(),
      'category': transaction.category,
      'description': transaction.description, // Add description
    });
  }

  // Fetch transactions from Firestore
  Future<void> fetchAndSetTransactions() async {
    try {
      final snapshot = await _firestore.collection('transactions').get();
      _transactions.clear();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        _transactions.add(Transaction(
          id: data['id'],
          amount: (data['amount'] as num).toDouble(),
          title: data['title'],
          date: DateTime.parse(data['date']),
          category: data['category'],
          description: data['description'] ?? '', // Handle description
        ));
      }

      notifyListeners();
    } catch (error) {
      debugPrint("Error fetching transactions: $error");
    }
  }

  // Check if any income exists
  bool get hasIncome => _transactions.any((tx) => tx.amount > 0);

  // Get total income
  double get totalIncome => _transactions
      .where((txn) => txn.amount > 0)
      .fold(0.0, (sum, txn) => sum + txn.amount);

  // Get total expenses
  double get totalExpense => _transactions
      .where((txn) => txn.amount < 0)
      .fold(0.0, (sum, txn) => sum + txn.amount.abs());

  // Get total transactions count
  int get totalTransactionsCount => _transactions.length;

  // Get category-wise summary for pie chart
  Map<String, double> get categoryWiseSummary {
    Map<String, double> categorySummary = {};

    for (var txn in _transactions) {
      if (txn.amount < 0) {
        categorySummary[txn.category] =
            (categorySummary[txn.category] ?? 0) + txn.amount.abs();
      }
    }

    return categorySummary;
  }

  // For dashboard income vs expense comparison
  Map<String, double> get incomeVsExpenseComparison => {
        'Income': totalIncome,
        'Expense': totalExpense,
      };

  // Category pie chart data
  List<Map<String, dynamic>> get categoryPieChartData {
    double totalExpenses = totalExpense;
    List<Map<String, dynamic>> chartData = [];

    categoryWiseSummary.forEach((category, total) {
      double percentage = (total / totalExpenses) * 100;
      chartData.add({
        'category': category,
        'amount': total,
        'percentage': percentage,
      });
    });

    return chartData;
  }
}
