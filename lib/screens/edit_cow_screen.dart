import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/cow.dart';
import '../constants/breeds.dart';

/// Edit screen — pre-fills all fields with the existing cow's data.
/// On save, updates the record in Isar using the same id.
class EditCowScreen extends StatefulWidget {
  final Cow cow;

  const EditCowScreen({super.key, required this.cow});

  @override
  State<EditCowScreen> createState() => _EditCowScreenState();
}

class _EditCowScreenState extends State<EditCowScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _tagController;
  late TextEditingController _customBreedController;
  late TextEditingController _sourceController;
  late TextEditingController _notesController;

  late String _selectedBreed;
  late CowSex _selectedSex;
  late CowStatus _selectedStatus;
  late DateTime? _dateOfBirth;
  late DateTime _acquisitionDate;

  @override
  void initState() {
    super.initState();

    // Pre-fill all controllers and state with the existing cow's values.
    _tagController = TextEditingController(text: widget.cow.tagNumber);
    _sourceController = TextEditingController(text: widget.cow.source ?? '');
    _notesController = TextEditingController(text: widget.cow.notes ?? '');

    // Breed: if the cow's breed is in our predefined list, select it.
    // Otherwise, select 'Other' and put the value in the custom field.
    if (kCowBreeds.contains(widget.cow.breed)) {
      _selectedBreed = widget.cow.breed;
      _customBreedController = TextEditingController();
    } else {
      _selectedBreed = 'Other';
      _customBreedController = TextEditingController(text: widget.cow.breed);
    }

    _selectedSex = widget.cow.sex;
    _selectedStatus = widget.cow.status;
    _dateOfBirth = widget.cow.dateOfBirth;
    _acquisitionDate = widget.cow.acquisitionDate;
  }

  @override
  void dispose() {
    _tagController.dispose();
    _customBreedController.dispose();
    _sourceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDob}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDob ? (_dateOfBirth ?? DateTime.now()) : _acquisitionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isDob) {
          _dateOfBirth = picked;
        } else {
          _acquisitionDate = picked;
        }
      });
    }
  }

  Future<void> _saveCow() async {
    if (!_formKey.currentState!.validate()) return;

    final breedValue = _selectedBreed == 'Other'
        ? _customBreedController.text.trim()
        : _selectedBreed;

    // Update the existing cow object's fields — keeping the same id
    // ensures Isar updates the record rather than creating a new one.
    final cow = widget.cow
      ..tagNumber = _tagController.text.trim()
      ..breed = breedValue.isEmpty ? 'Unknown' : breedValue
      ..sex = _selectedSex
      ..status = _selectedStatus
      ..dateOfBirth = _dateOfBirth
      ..acquisitionDate = _acquisitionDate
      ..source = _sourceController.text.trim().isEmpty
          ? null
          : _sourceController.text.trim()
      ..notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim()
      ..updatedAt = DateTime.now()
      ..syncStatus = SyncStatus.pending; // Mark for re-sync on next connection

    await isar.writeTxn(() async {
      await isar.cows.put(cow);
    });

    if (mounted) {
      // Pop twice: return true signals both the edit screen
      // and the detail screen to refresh.
      Navigator.pop(context, true);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Cow ${widget.cow.tagNumber}')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Tag number — required.
            TextFormField(
              controller: _tagController,
              decoration: const InputDecoration(
                labelText: 'Tag Number *',
                hintText: 'e.g. UG-2024-001',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a tag number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Breed dropdown.
            DropdownButtonFormField<String>(
              value: _selectedBreed,
              decoration: const InputDecoration(
                labelText: 'Breed',
                border: OutlineInputBorder(),
              ),
              items: kCowBreeds
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedBreed = value!);
              },
            ),

            // Custom breed text field — only shown when 'Other' is selected.
            if (_selectedBreed == 'Other') ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _customBreedController,
                decoration: const InputDecoration(
                  labelText: 'Enter breed name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (_selectedBreed == 'Other' &&
                      (value == null || value.trim().isEmpty)) {
                    return 'Please enter a breed name';
                  }
                  return null;
                },
              ),
            ],
            const SizedBox(height: 16),

            // Sex dropdown.
            DropdownButtonFormField<CowSex>(
              value: _selectedSex,
              decoration: const InputDecoration(
                labelText: 'Sex',
                border: OutlineInputBorder(),
              ),
              items: CowSex.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s == CowSex.female ? 'Female' : 'Male'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedSex = value!);
              },
            ),
            const SizedBox(height: 16),

            // Status dropdown.
            DropdownButtonFormField<CowStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: CowStatus.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(
                          s.name[0].toUpperCase() + s.name.substring(1),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
              },
            ),
            const SizedBox(height: 16),

            // Date of birth picker.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of Birth'),
              subtitle: Text(_formatDate(_dateOfBirth)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isDob: true),
            ),
            const Divider(),

            // Acquisition date picker.
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Acquisition Date'),
              subtitle: Text(_formatDate(_acquisitionDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isDob: false),
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Source field.
            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source (optional)',
                hintText: 'e.g. Bought from Kato, born on farm',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes field.
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Save button.
            FilledButton(
              onPressed: _saveCow,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}