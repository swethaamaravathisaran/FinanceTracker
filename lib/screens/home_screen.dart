import 'package:flutter/material.dart';
import 'package:myexpenseproject/screens/monthly_summary_screen.dart';
import 'package:myexpenseproject/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:myexpenseproject/widgets/transaction_form.dart';
import 'package:myexpenseproject/widgets/transaction_list.dart';
import 'package:myexpenseproject/providers/transaction_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    final hasIncome = provider.hasIncome;
    final income = provider.totalIncome;
    final expense = provider.totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💸 Personal Finance Tracker'),
        backgroundColor: Colors.pink.shade600, // Changed to pink theme
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: "Dashboard View",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart),
            tooltip: "Monthly Overview",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MonthlySummaryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero image banner
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://www.shutterstock.com/image-photo/unrecognizable-lady-working-on-family-budget-2032739630',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Failed to load image',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Greeting or callout
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Track. Save. Thrive. 💰",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.pink.shade800, // Pink text
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Transaction Input Section
            const TransactionForm(isIncome: true),
            if (hasIncome) const TransactionForm(isIncome: false),

            const SizedBox(height: 16),

            // Summary Chart Preview
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8)
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Text(
                      'Snapshot: Income vs Expenses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 250,
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
                                getTitlesWidget: (value, _) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('Income');
                                    case 1:
                                      return const Text('Expenses');
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  fromY: 0,
                                  toY: income,
                                  color: Colors.green,
                                  width: 20,
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  fromY: 0,
                                  toY: expense,
                                  color: Colors.red,
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Full Dashboard Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade600, // Pink button color
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.auto_graph),
                label: const Text('Explore Full Dashboard'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                '🧾 Recent Financial Moves',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 300,
              child: TransactionList(),
            ),
          ],
        ),
      ),
    );
  }
}
