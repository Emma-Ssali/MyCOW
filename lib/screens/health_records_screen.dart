import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/health_record.dart';
import 'add_health_record_screen.dart';

/// Lists all health records for a specific cow.
class HealthRecordsScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const HealthRecordsScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<HealthRecordsScreen> createState() => _HealthRecordsScreenState();
}

class _HealthRecordsScreenState extends State<HealthRecordsScreen> {
  List<HealthRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final all = await isar.healthRecords.where().findAll();
    setState(() {
      _records = all
          .where((r) => r.cowId == widget.cowId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loading = false;
    });
  }

  Future<void> _deleteRecord(HealthRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete record?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await isar.writeTxn(() async {
        await isar.healthRecords.delete(record.id);
      });
      _loadRecords();
    }
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

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

  Color _typeColor(HealthRecordType type) {
    switch (type) {
      case HealthRecordType.vaccination:
        return Colors.blue;
      case HealthRecordType.treatment:
        return Colors.orange;
      case HealthRecordType.deworming:
        return Colors.purple;
      case HealthRecordType.vetVisit:
        return Colors.teal;
      case HealthRecordType.disease:
        return Colors.red;
      case HealthRecordType.other:
        return Colors.grey;
    }
  }

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
        title: Text('Health — ${widget.cowTag}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(
                  child: Text(
                    'No health records yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRecords,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      final color = _typeColor(record.type);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          // Type icon.
                          leading: CircleAvatar(
                            backgroundColor:
                                color.withValues(alpha: 0.15),
                            child: Icon(
                              _typeIcon(record.type),
                              color: color,
                              size: 20,
                            ),
                          ),

                          // Type label + date.
                          title: Text(
                            _typeLabel(record.type),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              if (record.medication != null)
                                Text(record.medication!,
                                    style: const TextStyle(
                                        fontSize: 12)),
                              if (record.veterinarian != null)
                                Text('Vet: ${record.veterinarian}',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey)),
                              if (record.costUgx != null)
                                Text(
                                  'Cost: ${_formatAmount(record.costUgx!)}',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              if (record.notes != null)
                                Text(record.notes!,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey)),
                              Text(
                                _formatDate(record.date),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          isThreeLine: true,

                          // Delete button.
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () => _deleteRecord(record),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddHealthRecordScreen(
                cowId: widget.cowId,
                cowTag: widget.cowTag,
              ),
            ),
          );
          if (saved == true) _loadRecords();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}