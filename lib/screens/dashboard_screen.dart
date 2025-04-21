import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myexpenseproject/providers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final income = provider.totalIncome;
    final expense = provider.totalExpense;
    final transactions = provider.transactions;

    double food = 0, transport = 0, entertainment = 0, bills = 0;

    for (var txn in transactions) {
      if (txn.amount < 0) {
        switch (txn.category.toLowerCase()) {
          case 'food':
            food += txn.amount.abs();
            break;
          case 'transport':
            transport += txn.amount.abs();
            break;
          case 'entertainment':
            entertainment += txn.amount.abs();
            break;
          case 'bills':
            bills += txn.amount.abs();
            break;
        }
      }
    }

    // Debug print
    print(
        'Food: $food, Transport: $transport, Entertainment: $entertainment, Bills: $bills');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '📊 Dashboard',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink.shade300,
      ),
      backgroundColor: Colors.pink.shade50,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Income vs Expense Bar Chart
            Text(
              'Income vs Expense',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 250,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: BarChart(
                BarChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              value == 0 ? 'Income' : 'Expense',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: income,
                        width: 24,
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(6),
                      )
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: expense,
                        width: 24,
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      )
                    ]),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Expense Breakdown Pie Chart
            Text(
              'Expense Breakdown',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 300,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6)
                ],
              ),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    if (food > 0)
                      PieChartSectionData(
                        value: food,
                        color: Colors.pink.shade400,
                        title: 'Food\n₹${food.toStringAsFixed(0)}',
                        radius: 60,
                        titleStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (transport > 0)
                      PieChartSectionData(
                        value: transport,
                        color: Colors.deepPurple,
                        title: 'Transport\n₹${transport.toStringAsFixed(0)}',
                        radius: 60,
                        titleStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (entertainment > 0)
                      PieChartSectionData(
                        value: entertainment,
                        color: Colors.orange,
                        title: 'Fun\n₹${entertainment.toStringAsFixed(0)}',
                        radius: 60,
                        titleStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (bills > 0)
                      PieChartSectionData(
                        value: bills,
                        color: Colors.teal,
                        title: 'Bills\n₹${bills.toStringAsFixed(0)}',
                        radius: 60,
                        titleStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
