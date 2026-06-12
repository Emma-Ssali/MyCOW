import 'package:flutter/material.dart';
import '../main.dart';
import '../models/cow.dart';
import '../constants/breeds.dart';

class AddCowScreen extends StatefulWidget {
  const AddCowScreen({super.key});

  @override
  State<AddCowScreen> createState() => _AddCowScreenState();
}

class _AddCowScreenState extends State<AddCowScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tagController = TextEditingController();
  final _customBreedController = TextEditingController();
  final _sourceController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedBreed = kCowBreeds.first;
  CowSex _selectedSex = CowSex.female;
  CowStatus _selectedStatus = CowStatus.active;
  DateTime? _dateOfBirth;
  DateTime _acquisitionDate = DateTime.now();

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

    final cow = Cow()
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
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.cows.put(cow);
    });

    if (mounted) {
      Navigator.pop(context, true); // return true = "saved successfully"
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Cow')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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

            DropdownButtonFormField<String>(
              initialValue: _selectedBreed,
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

            DropdownButtonFormField<CowSex>(
              initialValue: _selectedSex,
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

            DropdownButtonFormField<CowStatus>(
              initialValue: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: CowStatus.values
                  .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s.name[0].toUpperCase() + s.name.substring(1)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedStatus = value!);
              },
            ),
            const SizedBox(height: 16),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of Birth'),
              subtitle: Text(_formatDate(_dateOfBirth)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isDob: true),
            ),
            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Acquisition Date'),
              subtitle: Text(_formatDate(_acquisitionDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _pickDate(isDob: false),
            ),
            const Divider(),
            const SizedBox(height: 8),

            TextFormField(
              controller: _sourceController,
              decoration: const InputDecoration(
                labelText: 'Source (optional)',
                hintText: 'e.g. Bought from Kato, born on farm',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            FilledButton(
              onPressed: _saveCow,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Save Cow', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}