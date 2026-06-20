import 'package:flutter/material.dart';
import '../main.dart';
import '../models/health_record.dart';

/// Form for recording a new health event for a specific cow.
class AddHealthRecordScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const AddHealthRecordScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<AddHealthRecordScreen> createState() =>
      _AddHealthRecordScreenState();
}

class _AddHealthRecordScreenState extends State<AddHealthRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationController = TextEditingController();
  final _vetController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();

  HealthRecordType _selectedType = HealthRecordType.vaccination;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _medicationController.dispose();
    _vetController.dispose();
    _costController.dispose();
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cost = double.tryParse(
      _costController.text.trim().replaceAll(',', ''),
    );

    final record = HealthRecord()
      ..cowId = widget.cowId
      ..type = _selectedType
      ..date = _date
      ..medication = _medicationController.text.trim().isEmpty
          ? null
          : _medicationController.text.trim()
      ..veterinarian = _vetController.text.trim().isEmpty
          ? null
          : _vetController.text.trim()
      ..costUgx = cost
      ..notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.healthRecords.put(record);
    });

    if (mounted) Navigator.pop(context, true);
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  /// Human-readable label for each health record type.
  String _typeLabel(HealthRecordType type) {
    switch (type) {
      case HealthRecordType.vaccination:
        return 'Vaccination';
      case HealthRecordType.treatment:
        return 'Treatment';
      case HealthRecordType.deworming:
        return 'Deworming';
      case HealthRecordType.vetVisit:
        return 'Vet Visit';
      case HealthRecordType.disease:
        return 'Disease';
      case HealthRecordType.other:
        return 'Other';
    }
  }

  /// Icon for each health record type.
  IconData _typeIcon(HealthRecordType type) {
    switch (type) {
      case HealthRecordType.vaccination:
        return Icons.vaccines;
      case HealthRecordType.treatment:
        return Icons.medical_services;
      case HealthRecordType.deworming:
        return Icons.bug_report;
      case HealthRecordType.vetVisit:
        return Icons.local_hospital;
      case HealthRecordType.disease:
        return Icons.coronavirus;
      case HealthRecordType.other:
        return Icons.note_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Record — ${widget.cowTag}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Record type selector.
            const Text(
              'Record Type',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: HealthRecordType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(_typeLabel(type)),
                  avatar: Icon(
                    _typeIcon(type),
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey,
                  ),
                  selected: isSelected,
                  selectedColor:
                      Theme.of(context).colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                  onSelected: (_) =>
                      setState(() => _selectedType = type),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

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

            // Medication / vaccine name.
            TextFormField(
              controller: _medicationController,
              decoration: const InputDecoration(
                labelText: 'Medication / Vaccine (optional)',
                hintText: 'e.g. Ivermectin, FMD Vaccine',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Veterinarian name.
            TextFormField(
              controller: _vetController,
              decoration: const InputDecoration(
                labelText: 'Veterinarian (optional)',
                hintText: 'e.g. Dr. Ssali',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Cost in UGX.
            TextFormField(
              controller: _costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cost (UGX) — optional',
                prefixText: 'UGX ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g. Follow-up in 2 weeks',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save button.
            FilledButton(
              onPressed: _save,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Save Health Record',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}