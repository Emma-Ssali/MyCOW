import 'package:flutter/material.dart';
import '../main.dart';
import '../models/milk_production.dart';

/// Form for recording a daily milk production entry for a specific cow.
class AddMilkProductionScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const AddMilkProductionScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<AddMilkProductionScreen> createState() =>
      _AddMilkProductionScreenState();
}

class _AddMilkProductionScreenState
    extends State<AddMilkProductionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _morningController = TextEditingController();
  final _eveningController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _morningController.dispose();
    _eveningController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    super.dispose();
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

  /// Live total shown as the user types.
  double get _previewTotal {
    final morning =
        double.tryParse(_morningController.text.trim()) ?? 0.0;
    final evening =
        double.tryParse(_eveningController.text.trim()) ?? 0.0;
    return morning + evening;
  }

  /// Revenue preview based on total litres × price per litre.
  double? get _revenuePreview {
    final price =
        double.tryParse(_priceController.text.trim()) ?? 0.0;
    if (price <= 0) return null;
    return _previewTotal * price;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final morning =
        double.tryParse(_morningController.text.trim()) ?? 0.0;
    final evening =
        double.tryParse(_eveningController.text.trim()) ?? 0.0;
    final price =
        double.tryParse(_priceController.text.trim());

    final record = MilkProduction()
      ..cowId = widget.cowId
      ..date = _date
      ..morningLitres = morning
      ..eveningLitres = evening
      ..totalLitres = morning + evening
      ..pricePerLitreUgx = price
      ..notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.milkProductions.put(record);
    });

    if (mounted) Navigator.pop(context, true);
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  String _formatAmount(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'UGX $formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk Entry — ${widget.cowTag}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Date picker.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date'),
              subtitle: Text(_formatDate(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),
            const Divider(),
            const SizedBox(height: 16),

            // Morning yield.
            TextFormField(
              controller: _morningController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: const InputDecoration(
                labelText: 'Morning Yield (litres)',
                hintText: 'e.g. 5.5',
                suffixText: 'L',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter morning yield (use 0 if none)';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Evening yield.
            TextFormField(
              controller: _eveningController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: const InputDecoration(
                labelText: 'Evening Yield (litres)',
                hintText: 'e.g. 4.0',
                suffixText: 'L',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter evening yield (use 0 if none)';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Live total preview.
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Daily Yield',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${_previewTotal.toStringAsFixed(1)} L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price per litre.
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true),
              decoration: const InputDecoration(
                labelText: 'Price per Litre (UGX) — optional',
                hintText: 'e.g. 1200',
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() {}),
            ),

            // Revenue preview.
            if (_revenuePreview != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Estimated Revenue',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _formatAmount(_revenuePreview!),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Notes.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g. Cow seemed unwell, reduced yield',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Save button.
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Save Milk Entry',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}