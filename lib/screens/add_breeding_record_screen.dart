import 'package:flutter/material.dart';
import '../main.dart';
import '../models/breeding_record.dart';

/// Form for recording a new breeding event for a specific cow.
class AddBreedingRecordScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const AddBreedingRecordScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<AddBreedingRecordScreen> createState() =>
      _AddBreedingRecordScreenState();
}

class _AddBreedingRecordScreenState
    extends State<AddBreedingRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bullController = TextEditingController();
  final _notesController = TextEditingController();
  final _calvesController = TextEditingController();

  DateTime? _heatDate;
  DateTime? _serviceDate;
  DateTime? _expectedCalvingDate;
  DateTime? _actualCalvingDate;

  bool _artificialInsemination = false;
  PregnancyStatus _pregnancyStatus = PregnancyStatus.unknown;

  @override
  void dispose() {
    _bullController.dispose();
    _notesController.dispose();
    _calvesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(String field) async {
    final initial = _getDate(field) ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _setDate(field, picked));
    }
  }

  DateTime? _getDate(String field) {
    switch (field) {
      case 'heat':
        return _heatDate;
      case 'service':
        return _serviceDate;
      case 'expected':
        return _expectedCalvingDate;
      case 'actual':
        return _actualCalvingDate;
    }
    return null;
  }

  void _setDate(String field, DateTime date) {
    switch (field) {
      case 'heat':
        _heatDate = date;
        break;
      case 'service':
        _serviceDate = date;
        // Auto-calculate expected calving date (283 days from service).
        _expectedCalvingDate =
            date.add(const Duration(days: 283));
        break;
      case 'expected':
        _expectedCalvingDate = date;
        break;
      case 'actual':
        _actualCalvingDate = date;
        break;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final record = BreedingRecord()
      ..cowId = widget.cowId
      ..heatDate = _heatDate
      ..serviceDate = _serviceDate
      ..bullUsed = _bullController.text.trim().isEmpty
          ? null
          : _bullController.text.trim()
      ..artificialInsemination = _artificialInsemination
      ..pregnancyStatus = _pregnancyStatus
      ..expectedCalvingDate = _expectedCalvingDate
      ..actualCalvingDate = _actualCalvingDate
      ..calvesBorn = int.tryParse(_calvesController.text.trim())
      ..notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim()
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.breedingRecords.put(record);
    });

    if (mounted) Navigator.pop(context, true);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _statusLabel(PregnancyStatus status) {
    switch (status) {
      case PregnancyStatus.unknown:
        return 'Unknown';
      case PregnancyStatus.confirmed:
        return 'Confirmed';
      case PregnancyStatus.notPregnant:
        return 'Not Pregnant';
      case PregnancyStatus.delivered:
        return 'Delivered';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breeding Record — ${widget.cowTag}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Heat date.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Heat Date (optional)'),
              subtitle: Text(_formatDate(_heatDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate('heat'),
            ),
            const Divider(),

            // Service date.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Service Date'),
              subtitle: Text(_formatDate(_serviceDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate('service'),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Bull used / semen source.
            TextFormField(
              controller: _bullController,
              decoration: const InputDecoration(
                labelText: 'Bull / Semen Source (optional)',
                hintText: 'e.g. Ankole Bull, Semex AI straw',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Artificial insemination toggle.
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Artificial Insemination (AI)'),
              subtitle: const Text(
                  'Toggle on if AI was used instead of natural mating'),
              value: _artificialInsemination,
              onChanged: (value) =>
                  setState(() => _artificialInsemination = value),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Pregnancy status.
            DropdownButtonFormField<PregnancyStatus>(
              initialValue: _pregnancyStatus,
              decoration: const InputDecoration(
                labelText: 'Pregnancy Status',
                border: OutlineInputBorder(),
              ),
              items: PregnancyStatus.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(_statusLabel(s)),
                      ))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _pregnancyStatus = value!),
            ),
            const SizedBox(height: 16),

            // Expected calving date — auto-filled when service date is set.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Expected Calving Date'),
              subtitle: Text(
                _serviceDate != null
                    ? '${_formatDate(_expectedCalvingDate)} (auto-calculated)'
                    : _formatDate(_expectedCalvingDate),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate('expected'),
            ),
            const Divider(),

            // Actual calving date.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Actual Calving Date (optional)'),
              subtitle: Text(_formatDate(_actualCalvingDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate('actual'),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Number of calves born.
            TextFormField(
              controller: _calvesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Calves Born (optional)',
                hintText: 'e.g. 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g. Healthy calf, difficult delivery',
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
                'Save Breeding Record',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}