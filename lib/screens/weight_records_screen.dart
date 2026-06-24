import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/weight_record.dart';
import 'add_weight_record_screen.dart';

/// Lists all weight records for a specific cow with trend analysis.
class WeightRecordsScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const WeightRecordsScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<WeightRecordsScreen> createState() =>
      _WeightRecordsScreenState();
}

class _WeightRecordsScreenState extends State<WeightRecordsScreen> {
  List<WeightRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final all = await isar.weightRecords.where().findAll();
    setState(() {
      _records = all
          .where((r) => r.cowId == widget.cowId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loading = false;
    });
  }

  Future<void> _deleteRecord(WeightRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
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
        await isar.weightRecords.delete(record.id);
      });
      _loadRecords();
    }
  }

  // ── Computed summaries ───────────────────────────────────────────

  /// Most recent weight.
  double? get _currentWeight =>
      _records.isEmpty ? null : _records.first.weightKg;

  /// First recorded weight.
  double? get _firstWeight =>
      _records.isEmpty ? null : _records.last.weightKg;

  /// Weight gained since first record.
  double? get _weightGain {
    if (_records.length < 2) return null;
    return _currentWeight! - _firstWeight!;
  }

  /// Heaviest recorded weight.
  double? get _maxWeight => _records.isEmpty
      ? null
      : _records
          .map((r) => r.weightKg)
          .reduce((a, b) => a > b ? a : b);

  // ── Helpers ──────────────────────────────────────────────────────

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  Widget _summaryCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gain = _weightGain;

    return Scaffold(
      appBar: AppBar(
        title: Text('Weight — ${widget.cowTag}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Summary cards.
                if (_records.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            _summaryCard(
                              'Current\nweight',
                              '${_currentWeight!.toStringAsFixed(1)} kg',
                              Colors.green,
                            ),
                            const SizedBox(width: 8),
                            _summaryCard(
                              'Heaviest\nrecorded',
                              '${_maxWeight!.toStringAsFixed(1)} kg',
                              Colors.blue,
                            ),
                          ],
                        ),
                        if (gain != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: gain >= 0
                                  ? Colors.green.withValues(alpha: 0.08)
                                  : Colors.red.withValues(alpha: 0.08),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total weight change',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      gain >= 0
                                          ? Icons.trending_up
                                          : Icons.trending_down,
                                      color: gain >= 0
                                          ? Colors.green
                                          : Colors.red,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${gain >= 0 ? '+' : ''}${gain.toStringAsFixed(1)} kg',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: gain >= 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                // Records list.
                Expanded(
                  child: _records.isEmpty
                      ? const Center(
                          child: Text(
                            'No weight entries yet.\nTap + to record the first weight.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadRecords,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(
                                12, 0, 12, 12),
                            itemCount: _records.length,
                            itemBuilder: (context, index) {
                              final record = _records[index];

                              // Calculate change from previous entry.
                              double? change;
                              if (index < _records.length - 1) {
                                change = record.weightKg -
                                    _records[index + 1].weightKg;
                              }

                              return Card(
                                margin: const EdgeInsets.only(
                                    bottom: 10),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.brown
                                        .withValues(alpha: 0.12),
                                    child: const Icon(
                                      Icons.monitor_weight,
                                      color: Colors.brown,
                                      size: 20,
                                    ),
                                  ),
                                  title: Text(
                                    _formatDate(record.date),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (change != null)
                                        Text(
                                          '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} kg from previous',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: change >= 0
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      if (record.notes != null)
                                        Text(
                                          record.notes!,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                    ],
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${record.weightKg.toStringAsFixed(1)} kg',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.brown,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _deleteRecord(record),
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => AddWeightRecordScreen(
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