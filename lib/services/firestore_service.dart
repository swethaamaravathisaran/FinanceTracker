import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myexpenseproject/models/transaction.dart';

class FirestoreService {
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;

  // Add a transaction to Firestore
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User not logged in.");
        return;
      }

      // Log transaction details to ensure they are correct
      print("Adding transaction to Firestore:");
      print("Amount: ${transaction.amount}");
      print("Category: ${transaction.category}");
      print("Date: ${transaction.date}");
      print("Description: ${transaction.description}");

      // Add the transaction to Firestore
      await _db.collection('users').doc(userId).collection('transactions').add({
        'amount': transaction.amount,
        'category': transaction.category,
        'date': transaction.date.toIso8601String(),
        'description': transaction.description,
      });

      print("Transaction added successfully.");
    } catch (e) {
      print("Error adding transaction: $e");
    }
  }

  // Fetch all transactions from Firestore
  Stream<List<Transaction>> getTransactions() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print("User not logged in.");
      return Stream.value([]);
    }

    return _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      final transactions = snapshot.docs
          .map((doc) => Transaction.fromFirestore(doc)) // Change here
          .toList();

      // Log the fetched transactions
      print("Fetched ${transactions.length} transactions from Firestore.");
      return transactions;
    });
  }
}
