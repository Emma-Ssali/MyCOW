import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/milk_production.dart';
import 'add_milk_production_screen.dart';

/// Lists all milk production records for a specific cow,
/// with daily, weekly and monthly summaries.
class MilkProductionScreen extends StatefulWidget {
  final int cowId;
  final String cowTag;

  const MilkProductionScreen({
    super.key,
    required this.cowId,
    required this.cowTag,
  });

  @override
  State<MilkProductionScreen> createState() =>
      _MilkProductionScreenState();
}

class _MilkProductionScreenState extends State<MilkProductionScreen> {
  List<MilkProduction> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _loading = true);
    final all = await isar.milkProductions.where().findAll();
    setState(() {
      _records = all
          .where((r) => r.cowId == widget.cowId)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loading = false;
    });
  }

  Future<void> _deleteRecord(MilkProduction record) async {
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
        await isar.milkProductions.delete(record.id);
      });
      _loadRecords();
    }
  }

  // ── Computed summaries ───────────────────────────────────────────

  double get _totalLitres =>
      _records.fold(0.0, (sum, r) => sum + r.totalLitres);

  double get _averageDaily =>
      _records.isEmpty ? 0.0 : _totalLitres / _records.length;

  /// Last 7 days total.
  double get _last7Days {
    final cutoff =
        DateTime.now().subtract(const Duration(days: 7));
    return _records
        .where((r) => r.date.isAfter(cutoff))
        .fold(0.0, (sum, r) => sum + r.totalLitres);
  }

  /// Last 30 days total.
  double get _last30Days {
    final cutoff =
        DateTime.now().subtract(const Duration(days: 30));
    return _records
        .where((r) => r.date.isAfter(cutoff))
        .fold(0.0, (sum, r) => sum + r.totalLitres);
  }

  // ── Helpers ──────────────────────────────────────────────────────

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

  Widget _summaryCard(String label, String value,
      {Color color = Colors.blue}) {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Milk — ${widget.cowTag}'),
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
                              'Total\n(all time)',
                              '${_totalLitres.toStringAsFixed(1)} L',
                            ),
                            const SizedBox(width: 8),
                            _summaryCard(
                              'Daily\naverage',
                              '${_averageDaily.toStringAsFixed(1)} L',
                              color: Colors.teal,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _summaryCard(
                              'Last 7 days',
                              '${_last7Days.toStringAsFixed(1)} L',
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            _summaryCard(
                              'Last 30 days',
                              '${_last30Days.toStringAsFixed(1)} L',
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Records list.
                Expanded(
                  child: _records.isEmpty
                      ? const Center(
                          child: Text(
                            'No milk entries yet.\nTap + to record daily production.',
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
                              final revenue =
                                  record.pricePerLitreUgx != null
                                      ? record.totalLitres *
                                          record.pricePerLitreUgx!
                                      : null;

                              return Card(
                                margin: const EdgeInsets.only(
                                    bottom: 10),
                                child: ListTile(
                                  // Milk drop icon.
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue
                                        .withValues(alpha: 0.12),
                                    child: const Icon(
                                      Icons.water_drop,
                                      color: Colors.blue,
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
                                      Text(
                                        'Morning: ${record.morningLitres.toStringAsFixed(1)} L  '
                                        'Evening: ${record.eveningLitres.toStringAsFixed(1)} L',
                                        style: const TextStyle(
                                            fontSize: 12),
                                      ),
                                      if (revenue != null)
                                        Text(
                                          'Revenue: ${_formatAmount(revenue)}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
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
                                  isThreeLine: true,

                                  // Total + delete.
                                  trailing: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${record.totalLitres.toStringAsFixed(1)} L',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.blue,
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
              builder: (context) => AddMilkProductionScreen(
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