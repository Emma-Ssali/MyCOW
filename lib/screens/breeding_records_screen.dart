import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/breeding_record.dart';
import 'add_breeding_record_screen.dart';

/// Lists all breeding records for a specific cow.
class BreedingRecordsScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const BreedingRecordsScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<BreedingRecordsScreen> createState() =>
      _BreedingRecordsScreenState();
}

class _BreedingRecordsScreenState
    extends State<BreedingRecordsScreen> {
  List<BreedingRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final all = await isar.breedingRecords.where().findAll();
    setState(() {
      _records = all
          .where((r) => r.cowId == widget.cowId)
          .toList()
        ..sort((a, b) {
          final aDate = a.serviceDate ?? a.createdAt;
          final bDate = b.serviceDate ?? b.createdAt;
          return bDate.compareTo(aDate);
        });
      _loading = false;
    });
  }

  Future<void> _deleteRecord(BreedingRecord record) async {
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
        await isar.breedingRecords.delete(record.id);
      });
      _loadRecords();
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
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

  Color _statusColor(PregnancyStatus status) {
    switch (status) {
      case PregnancyStatus.unknown:
        return Colors.grey;
      case PregnancyStatus.confirmed:
        return Colors.green;
      case PregnancyStatus.notPregnant:
        return Colors.red;
      case PregnancyStatus.delivered:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breeding — ${widget.cowTag}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const Center(
                  child: Text(
                    'No breeding records yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRecords,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _records.length,
                    itemBuilder: (context, index) {
                      final record = _records[index];
                      final statusColor =
                          _statusColor(record.pregnancyStatus);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              // Status badge + AI indicator.
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets
                                        .symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: statusColor
                                          .withValues(alpha: 0.15),
                                      borderRadius:
                                          BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      _statusLabel(
                                          record.pregnancyStatus),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                  if (record.artificialInsemination) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets
                                          .symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: Colors.purple
                                            .withValues(alpha: 0.15),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'AI',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                  const Spacer(),
                                  // Delete button.
                                  GestureDetector(
                                    onTap: () =>
                                        _deleteRecord(record),
                                    child: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.red,
                                        size: 18),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Dates grid.
                              _dateRow('Heat Date',
                                  _formatDate(record.heatDate)),
                              _dateRow('Service Date',
                                  _formatDate(record.serviceDate)),
                              _dateRow(
                                  'Expected Calving',
                                  _formatDate(
                                      record.expectedCalvingDate)),
                              _dateRow(
                                  'Actual Calving',
                                  _formatDate(
                                      record.actualCalvingDate)),

                              if (record.bullUsed != null)
                                _dateRow('Bull / Source',
                                    record.bullUsed!),
                              if (record.calvesBorn != null)
                                _dateRow('Calves Born',
                                    '${record.calvesBorn}'),
                              if (record.notes != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  record.notes!,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              ],
                            ],
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
              builder: (context) => AddBreedingRecordScreen(
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

  /// A simple label + value row for the breeding card.
  Widget _dateRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 12, color: Colors.grey),
            ),
          ),
          Text(value,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}