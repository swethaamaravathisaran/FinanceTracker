import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;
  final String description;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    required this.description,
  });

  // Create a Transaction object from a Firestore document snapshot
  factory Transaction.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Transaction(
      id: doc.id, // Get document ID
      title: data['title'] ?? '',
      amount: (data['amount'] as num).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      category: data['category'] ?? 'General',
      description: data['description'] ?? '',
    );
  }

  // Convert a Transaction object into a Map (for Firestore storage)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'date': Timestamp.fromDate(date),
      'category': category,
      'description': description,
    };
  }
}
