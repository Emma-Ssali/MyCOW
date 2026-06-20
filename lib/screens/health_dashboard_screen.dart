import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/health_record.dart';
import '../models/cow.dart';
import 'add_health_record_screen.dart';

/// Farm-wide health dashboard — shows all health records across all cows,
/// with a cost summary and filter by record type and cow.
class HealthDashboardScreen extends StatefulWidget {
  const HealthDashboardScreen({super.key});

  @override
  State<HealthDashboardScreen> createState() =>
      _HealthDashboardScreenState();
}

class _HealthDashboardScreenState extends State<HealthDashboardScreen> {
  List<HealthRecord> _allRecords = [];
  List<HealthRecord> _filteredRecords = [];
  Map<int, Cow> _cowMap = {};
  bool _loading = true;

  // Filter state.
  HealthRecordType? _typeFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Loads all health records and cows from Isar.
  Future<void> _loadData() async {
    setState(() => _loading = true);

    final records = await isar.healthRecords.where().findAll();
    final cows = await isar.cows.where().findAll();

    setState(() {
      _allRecords = records..sort((a, b) => b.date.compareTo(a.date));
      _cowMap = {for (final cow in cows) cow.id: cow};
      _loading = false;
    });

    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredRecords = _allRecords.where((r) {
        return _typeFilter == null || r.type == _typeFilter;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() => _typeFilter = null);
    _applyFilters();
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
      _loadData();
    }
  }

  // ── Computed totals ──────────────────────────────────────────────

  /// Total health costs across all records.
  double get _totalCost => _allRecords
      .where((r) => r.costUgx != null)
      .fold(0.0, (sum, r) => sum + (r.costUgx ?? 0));

  /// Count of records per type.
  Map<HealthRecordType, int> get _typeCounts {
    final counts = {for (var t in HealthRecordType.values) t: 0};
    for (final r in _allRecords) {
      counts[r.type] = (counts[r.type] ?? 0) + 1;
    }
    return counts;
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

  @override
  Widget build(BuildContext context) {
    final typeCounts = _typeCounts;
    final filtersActive = _typeFilter != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_allRecords.length} total',
                style:
                    const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Cost summary card ──
                          Card(
                            color: Colors.teal.withValues(alpha: 0.1),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Health Costs',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    _formatAmount(_totalCost),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // ── Type breakdown ──
                          const Text(
                            'By Type',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          GridView.count(
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            physics:
                                const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.3,
                            children: HealthRecordType.values
                                .map((type) {
                              final count = typeCounts[type] ?? 0;
                              final color = _typeColor(type);
                              return GestureDetector(
                                onTap: () {
                                  setState(() => _typeFilter =
                                      _typeFilter == type
                                          ? null
                                          : type);
                                  _applyFilters();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: _typeFilter == type
                                        ? color.withValues(alpha: 0.2)
                                        : color.withValues(alpha: 0.08),
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    border: Border.all(
                                      color: _typeFilter == type
                                          ? color
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(_typeIcon(type),
                                          color: color, size: 22),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$count',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                      ),
                                      Text(
                                        _typeLabel(type),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color:
                                              color.withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 16),

                          // ── Filter row ──
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                filtersActive
                                    ? '${_filteredRecords.length} result${_filteredRecords.length == 1 ? '' : 's'}'
                                    : 'All Records',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              if (filtersActive)
                                TextButton.icon(
                                  onPressed: _clearFilters,
                                  icon: const Icon(Icons.close,
                                      size: 14),
                                  label: const Text('Clear filter'),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    visualDensity:
                                        VisualDensity.compact,
                                  ),
                                ),
                            ],
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),

                  // ── Records list ──
                  _filteredRecords.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Text(
                              filtersActive
                                  ? 'No records match this filter.'
                                  : 'No health records yet.\nTap + to add one.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                              16, 0, 16, 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final record =
                                    _filteredRecords[index];
                                final cow =
                                    _cowMap[record.cowId];
                                final color =
                                    _typeColor(record.type);

                                return Card(
                                  margin: const EdgeInsets.only(
                                      bottom: 10),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: color
                                          .withValues(alpha: 0.15),
                                      child: Icon(
                                        _typeIcon(record.type),
                                        color: color,
                                        size: 20,
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          _typeLabel(record.type),
                                          style: const TextStyle(
                                              fontWeight:
                                                  FontWeight.bold),
                                        ),
                                        if (cow != null) ...[
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 6,
                                                vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green
                                                  .withValues(
                                                      alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      6),
                                            ),
                                            child: Text(
                                              cow.tagNumber,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.green,
                                                fontWeight:
                                                    FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (record.medication != null)
                                          Text(record.medication!,
                                              style: const TextStyle(
                                                  fontSize: 12)),
                                        if (record.veterinarian !=
                                            null)
                                          Text(
                                            'Vet: ${record.veterinarian}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        if (record.costUgx != null)
                                          Text(
                                            'Cost: ${_formatAmount(record.costUgx!)}',
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.teal),
                                          ),
                                        if (record.notes != null)
                                          Text(
                                            record.notes!,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        Text(
                                          _formatDate(record.date),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    isThreeLine: true,
                                    trailing: IconButton(
                                      icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _deleteRecord(record),
                                    ),
                                  ),
                                );
                              },
                              childCount: _filteredRecords.length,
                            ),
                          ),
                        ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // When adding from the dashboard, we need to pick a cow first.
          final cows = _cowMap.values.toList();
          if (cows.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Add a cow first before recording health data.')),
            );
            return;
          }

          // Show cow picker dialog.
          final selectedCow = await showDialog<Cow>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Select a cow'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cows.length,
                  itemBuilder: (context, index) {
                    final cow = cows[index];
                    return ListTile(
                      title: Text('Tag: ${cow.tagNumber}'),
                      subtitle: Text(cow.breed),
                      onTap: () => Navigator.pop(context, cow),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          );

          if (selectedCow != null && context.mounted) {
            final saved = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (context) => AddHealthRecordScreen(
                  cowId: selectedCow.id,
                  cowTag: selectedCow.tagNumber,
                ),
              ),
            );
            if (saved == true) _loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}