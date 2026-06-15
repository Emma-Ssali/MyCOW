import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/cow.dart';

/// Dashboard — gives a quick overview of the farm's cattle.
/// Shows total cows, status breakdown, tagged/untagged counts,
/// and breed distribution.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Cow> _cows = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final cows = await isar.cows.where().findAll();
    setState(() {
      _cows = cows;
      _loading = false;
    });
  }

  /// Counts how many cows have each status.
  Map<CowStatus, int> _statusCounts() {
    final counts = {for (var s in CowStatus.values) s: 0};
    for (final cow in _cows) {
      counts[cow.status] = (counts[cow.status] ?? 0) + 1;
    }
    return counts;
  }

  /// Counts how many cows exist per breed, sorted by count descending.
  List<MapEntry<String, int>> _breedCounts() {
    final counts = <String, int>{};
    for (final cow in _cows) {
      counts[cow.breed] = (counts[cow.breed] ?? 0) + 1;
    }
    final entries = counts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

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

  /// A large stat card — used for the top summary row.
  Widget _statCard(String label, String value, {Color? color}) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color ?? Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A horizontal bar showing a status's count as a proportion of the total.
  Widget _statusBar(CowStatus status, int count, int total) {
    final percent = total == 0 ? 0.0 : count / total;
    final label = status.name[0].toUpperCase() + status.name.substring(1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 13)),
              Text('$count', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(_statusColor(status)),
            ),
          ),
        ],
      ),
    );
  }

  /// A row showing a breed name and its count, with a small bar.
  Widget _breedRow(String breed, int count, int total) {
    final percent = total == 0 ? 0.0 : count / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(breed, style: const TextStyle(fontSize: 13)),
              Text('$count', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = _cows.length;
    final tagged = _cows.where((c) => c.tagNumber.isNotEmpty).length;
    final untagged = total - tagged;
    final statusCounts = _statusCounts();
    final breedCounts = _breedCounts();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Top summary cards: total, tagged, untagged.
                  Row(
                    children: [
                      _statCard('Total Cows', '$total'),
                      const SizedBox(width: 10),
                      _statCard('Tagged', '$tagged', color: Colors.green),
                      const SizedBox(width: 10),
                      _statCard('Untagged', '$untagged', color: Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Status breakdown.
                  const Text(
                    'Status Breakdown',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  if (total == 0)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No cows recorded yet.', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...CowStatus.values.map(
                      (status) => _statusBar(status, statusCounts[status] ?? 0, total),
                    ),

                  const SizedBox(height: 24),

                  // Breed breakdown.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Breed Breakdown',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${breedCounts.length} breed${breedCounts.length == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (breedCounts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text('No cows recorded yet.', style: TextStyle(color: Colors.grey)),
                    )
                  else
                    ...breedCounts.map(
                      (entry) => _breedRow(entry.key, entry.value, total),
                    ),
                ],
              ),
            ),
    );
  }
}