import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/transaction.dart';
import '../models/cow.dart';
import '../constants/transaction_categories.dart';

/// Form screen for recording a new income or expense transaction.
class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Default to income.
  TransactionType _type = TransactionType.income;

  // Category string — driven by the type selection.
  String _selectedCategory = kIncomeCategoryStrings.first;

  // Date defaults to today.
  DateTime _date = DateTime.now();

  // Optional cow link.
  int? _selectedCowId;

  // List of cows loaded from Isar for the cow picker dropdown.
  List<Cow> _cows = [];

  @override
  void initState() {
    super.initState();
    _loadCows();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  /// Loads all cows for the optional cow link dropdown.
  Future<void> _loadCows() async {
    final cows = await isar.cows.where().findAll();
    setState(() => _cows = cows);
  }

  /// When the transaction type changes, reset the category
  /// to the first option of the new type's list.
  void _onTypeChanged(TransactionType type) {
    setState(() {
      _type = type;
      _selectedCategory = type == TransactionType.income
          ? kIncomeCategoryStrings.first
          : kExpenseCategoryStrings.first;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(
          _amountController.text.trim().replaceAll(',', ''),
        ) ??
        0.0;

    final transaction = FarmTransaction()
      ..type = _type
      ..amountUgx = amount
      ..category = _selectedCategory
      ..description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim()
      ..date = _date
      ..cowId = _selectedCowId
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.farmTransactions.put(transaction);
    });

    if (mounted) Navigator.pop(context, true);
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  /// Returns the correct category list based on current type.
  List<String> get _categories => _type == TransactionType.income
      ? kIncomeCategoryStrings
      : kExpenseCategoryStrings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Transaction')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Transaction type toggle — Income or Expense.
            const Text(
              'Type',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text('Income'),
                  icon: Icon(Icons.arrow_downward),
                ),
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text('Expense'),
                  icon: Icon(Icons.arrow_upward),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (set) => _onTypeChanged(set.first),
              style: ButtonStyle(
                // Color the selected segment green for income, red for expense.
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return _type == TransactionType.income
                        ? Colors.green.withValues(alpha: 0.15)
                        : Colors.red.withValues(alpha: 0.15);
                  }
                  return null;
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Amount field in UGX.
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (UGX) *',
                hintText: 'e.g. 50000',
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                final parsed = double.tryParse(
                  value.trim().replaceAll(',', ''),
                );
                if (parsed == null || parsed <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category dropdown — changes based on type.
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: 16),

            // Description field — optional.
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'e.g. Sold 20 litres to Kampala Dairy',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Date picker.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(_formatDate(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Optional cow link dropdown.
            DropdownButtonFormField<int?>(
              initialValue: _selectedCowId,
              decoration: const InputDecoration(
                labelText: 'Linked Cow (optional)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('— Not linked to a cow —'),
                ),
                ..._cows.map(
                  (cow) => DropdownMenuItem(
                    value: cow.id,
                    child: Text('Tag: ${cow.tagNumber} (${cow.breed})'),
                  ),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _selectedCowId = value),
            ),
            const SizedBox(height: 24),

            // Save button — colored based on type.
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: _type == TransactionType.income
                    ? Colors.green
                    : Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                _type == TransactionType.income
                    ? 'Record Income'
                    : 'Record Expense',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}