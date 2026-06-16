import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/transaction.dart';
import '../models/cow.dart';
import '../constants/transaction_categories.dart';

/// Pre-filled form for editing an existing transaction.
class EditTransactionScreen extends StatefulWidget {
  final FarmTransaction transaction;

  const EditTransactionScreen({super.key, required this.transaction});

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;

  late TransactionType _type;
  late String _selectedCategory;
  late DateTime _date;
  int? _selectedCowId;
  List<Cow> _cows = [];

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _amountController =
        TextEditingController(text: tx.amountUgx.toStringAsFixed(0));
    _descriptionController =
        TextEditingController(text: tx.description ?? '');
    _type = tx.type;
    _selectedCategory = tx.category;
    _date = tx.date;
    _selectedCowId = tx.cowId;
    _loadCows();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadCows() async {
    final cows = await isar.cows.where().findAll();
    setState(() => _cows = cows);
  }

  void _onTypeChanged(TransactionType type) {
    setState(() {
      _type = type;
      // Only reset category if current one doesn't belong to the new type.
      final validCategories = type == TransactionType.income
          ? kIncomeCategoryStrings
          : kExpenseCategoryStrings;
      if (!validCategories.contains(_selectedCategory)) {
        _selectedCategory = validCategories.first;
      }
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

    final tx = widget.transaction
      ..type = _type
      ..amountUgx = amount
      ..category = _selectedCategory
      ..description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim()
      ..date = _date
      ..cowId = _selectedCowId
      ..updatedAt = DateTime.now()
      ..syncStatus = TransactionSyncStatus.pending;

    await isar.writeTxn(() async {
      await isar.farmTransactions.put(tx);
    });

    if (mounted) Navigator.pop(context, true);
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  List<String> get _categories => _type == TransactionType.income
      ? kIncomeCategoryStrings
      : kExpenseCategoryStrings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Transaction')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Type toggle.
            const Text('Type',
                style: TextStyle(fontSize: 13, color: Colors.grey)),
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

            // Amount.
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (UGX) *',
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an amount';
                }
                final parsed =
                    double.tryParse(value.trim().replaceAll(',', ''));
                if (parsed == null || parsed <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Category.
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

            // Description.
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
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

            // Linked cow.
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
              onChanged: (value) => setState(() => _selectedCowId = value),
            ),
            const SizedBox(height: 24),

            // Save button.
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                backgroundColor: _type == TransactionType.income
                    ? Colors.green
                    : Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save Changes',
                  style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}