import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myexpenseproject/providers/transaction_provider.dart';
import 'package:myexpenseproject/models/transaction.dart';

class TransactionForm extends StatefulWidget {
  final bool isIncome;

  const TransactionForm({super.key, required this.isIncome});

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'General';

  void submitData() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim()) ?? 0;
    final description = descriptionController.text.trim();

    if (title.isEmpty || amount <= 0 || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('🚫 Please enter a valid title, amount, and description')),
      );
      return;
    }

    final transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: widget.isIncome ? amount : -amount,
      date: DateTime.now(),
      category: selectedCategory,
      description: description,
    );

    Provider.of<TransactionProvider>(context, listen: false)
        .addTransaction(transaction);

    titleController.clear();
    amountController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.pink.shade50.withOpacity(0.85),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              widget.isIncome
                  ? '💰 Record Your Income'
                  : '🛍️ Record Your Expense',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink.shade900,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Transaction Title',
                labelStyle: TextStyle(color: Colors.pink.shade800),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                labelStyle: TextStyle(color: Colors.pink.shade800),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.pink.shade800),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.pink.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            if (!widget.isIncome)
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  labelStyle: TextStyle(color: Colors.pink.shade800),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                dropdownColor: Colors.pink.shade100,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                items: [
                  'Food',
                  'Transport',
                  'Entertainment',
                  'Bills',
                  'General'
                ]
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat,
                              style: TextStyle(color: Colors.pink.shade900)),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: submitData,
              icon: const Icon(Icons.add_circle_outline),
              label: Text(widget.isIncome ? 'Add Income' : 'Add Expense'),
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.isIncome
                    ? Colors.pink.shade300
                    : Colors.pink.shade600,
                foregroundColor: Colors.white,
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
