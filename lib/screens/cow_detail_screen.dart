import 'package:flutter/material.dart';
import '../models/cow.dart';
import 'edit_cow_screen.dart';

/// Displays the full details of a single cow.
/// Receives the Cow object from the list screen — no extra DB query needed.
class CowDetailScreen extends StatelessWidget {
  final Cow cow;

  const CowDetailScreen({super.key, required this.cow});

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not set';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Color _statusColor(CowStatus status) {
    switch (status) {
      case CowStatus.active:
        return Colors.green;
      case CowStatus.sold:
        return Colors.blue;
      case CowStatus.dead:
        return Colors.grey;
      case CowStatus.missing:
        return Colors.orange;
    }
  }

  /// A single row of label + value, used throughout the detail view.
  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cow ${cow.tagNumber}'),
        actions: [
          // Edit button — opens the edit screen with this cow's data pre-filled.
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit cow',
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCowScreen(cow: cow),
                ),
              );
              if (updated == true && context.mounted) {
                // Pop back to the list so it can refresh with updated data.
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status badge at the top — quick visual summary.
          Center(
            child: Chip(
              label: Text(
                _capitalize(cow.status.name),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: _statusColor(cow.status),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
          const SizedBox(height: 20),

          // Identification section.
          const Text(
            'Identification',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _detailRow('Tag Number', cow.tagNumber),
          _detailRow('Breed', cow.breed),
          _detailRow('Sex', cow.sex == CowSex.female ? 'Female' : 'Male'),

          const SizedBox(height: 20),

          // Dates section.
          const Text(
            'Dates',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _detailRow('Date of Birth', _formatDate(cow.dateOfBirth)),
          _detailRow('Acquisition Date', _formatDate(cow.acquisitionDate)),

          const SizedBox(height: 20),

          // Additional info section.
          const Text(
            'Additional Info',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _detailRow(
            'Source',
            cow.source?.isNotEmpty == true ? cow.source! : 'Not recorded',
          ),
          _detailRow(
            'Notes',
            cow.notes?.isNotEmpty == true ? cow.notes! : 'None',
          ),

          const SizedBox(height: 20),

          // Record info section.
          const Text(
            'Record Info',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          _detailRow('Created', _formatDate(cow.createdAt)),
          _detailRow('Last Updated', _formatDate(cow.updatedAt)),
          _detailRow('Sync Status', _capitalize(cow.syncStatus.name)),
        ],
      ),
    );
  }
}