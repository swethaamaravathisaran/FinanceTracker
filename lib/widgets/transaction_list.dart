import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myexpenseproject/providers/transaction_provider.dart';
import 'package:animate_do/animate_do.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;

    return transactions.isEmpty
        ? const Center(
            child: Text(
              'No transactions yet 💤',
              style: TextStyle(color: Colors.white70),
            ),
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tx = transactions[index];
              return FadeInLeft(
                duration: Duration(milliseconds: 500 + index * 100),
                child: Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  color: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tx.amount > 0
                          ? Colors.pink.shade300
                          : Colors.pink.shade700,
                      radius: 28,
                      child: FittedBox(
                        child: Text(
                          '₹${tx.amount.abs().toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${tx.category} • ${tx.date.toLocal()}'.split(' ')[0],
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
