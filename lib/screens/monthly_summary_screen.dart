import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myexpenseproject/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlySummaryScreen extends StatelessWidget {
  const MonthlySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<TransactionProvider>(context).transactions;
    final currentMonth = DateTime.now().month;
    final currentYear = DateTime.now().year;

    final filteredTransactions = transactions
        .where((tx) =>
            tx.date.month == currentMonth && tx.date.year == currentYear)
        .toList();

    double totalIncome = 0;
    double totalExpense = 0;
    Map<String, double> categoryExpenses = {};

    for (var tx in filteredTransactions) {
      if (tx.amount >= 0) {
        totalIncome += tx.amount;
      } else {
        totalExpense += tx.amount.abs();
        categoryExpenses[tx.category] =
            (categoryExpenses[tx.category] ?? 0) + tx.amount.abs();
      }
    }

    double balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Monthly Summary'),
        backgroundColor: Colors.pink.shade400,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary Cards
                SummaryCard(
                    label: 'Total Income',
                    amount: totalIncome,
                    color: Colors.green),
                SummaryCard(
                    label: 'Total Expenses',
                    amount: totalExpense,
                    color: Colors.red),
                SummaryCard(
                    label: 'Remaining Balance',
                    amount: balance,
                    color: Colors.purpleAccent),

                const SizedBox(height: 30),

                // Monthly Expense Bar Chart
                Text(
                  '📊 Monthly Expenses by Category',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700),
                ),
                const SizedBox(height: 16),
                if (categoryExpenses.isNotEmpty)
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: BarChart(
                      BarChartData(
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final keys = categoryExpenses.keys.toList();
                                if (value.toInt() >= keys.length) {
                                  return const SizedBox();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    keys[value.toInt()],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles:
                                SideTitles(showTitles: true, reservedSize: 40),
                          ),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: categoryExpenses.entries
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                          return BarChartGroupData(
                            x: entry.key,
                            barRods: [
                              BarChartRodData(
                                toY: entry.value.value,
                                width: 24,
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.pink.shade400,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                const SizedBox(height: 30),

                // Transactions List
                Text(
                  '📌 Transactions This Month',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink.shade900),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTransactions.length,
                  itemBuilder: (context, index) {
                    final tx = filteredTransactions[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: Icon(
                          tx.amount >= 0
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color: tx.amount >= 0 ? Colors.green : Colors.red,
                        ),
                        title: Text(tx.title),
                        subtitle: Text(DateFormat.yMMMd().format(tx.date)),
                        trailing: Text(
                          "₹${tx.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: tx.amount >= 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const SummaryCard(
      {super.key,
      required this.label,
      required this.amount,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.account_balance_wallet, color: color),
        title: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        trailing: Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
