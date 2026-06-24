import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/cow.dart';
import '../models/transaction.dart';
import '../main.dart';
import 'edit_cow_screen.dart';
import 'health_records_screen.dart';
import 'breeding_records_screen.dart';
import 'milk_production_screen.dart';

/// Displays the full details of a single cow, including
/// all financial transactions and health records linked to this cow.
class CowDetailScreen extends StatefulWidget {
  final Cow cow;

  const CowDetailScreen({super.key, required this.cow});

  @override
  State<CowDetailScreen> createState() => _CowDetailScreenState();
}

class _CowDetailScreenState extends State<CowDetailScreen> {
  List<FarmTransaction> _transactions = [];
  bool _loadingTx = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  /// Loads all transactions linked to this cow via cowId.
  Future<void> _loadTransactions() async {
    setState(() => _loadingTx = true);
    final all = await isar.farmTransactions.where().findAll();
    setState(() {
      _transactions = all
          .where((tx) => tx.cowId == widget.cow.id)
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _loadingTx = false;
    });
  }

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

  /// Formats UGX with thousands separator.
  String _formatAmount(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'UGX $formatted';
  }

  /// A single label + value row used throughout the detail view.
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

  /// A single transaction row shown in the cow's financial history.
  Widget _transactionRow(FarmTransaction tx) {
    final isIncome = tx.type == TransactionType.income;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Income/expense icon.
          CircleAvatar(
            radius: 16,
            backgroundColor: isIncome
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.red.withValues(alpha: 0.15),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              size: 14,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 10),

          // Category + date.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.category,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  _formatDate(tx.date),
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Amount.
          Text(
            '${isIncome ? '+' : '-'}${_formatAmount(tx.amountUgx)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cow = widget.cow;

    // Financial totals for this cow.
    final cowIncome = _transactions
        .where((tx) => tx.type == TransactionType.income)
        .fold(0.0, (sum, tx) => sum + tx.amountUgx);
    final cowExpense = _transactions
        .where((tx) => tx.type == TransactionType.expense)
        .fold(0.0, (sum, tx) => sum + tx.amountUgx);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cow ${cow.tagNumber}'),
        actions: [
          // Edit button.
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
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cow photo.
          Center(
            child: CircleAvatar(
              radius: 70,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: cow.photoPath != null
                  ? FileImage(File(cow.photoPath!))
                  : null,
              child: cow.photoPath == null
                  ? const Icon(Icons.photo_camera,
                      size: 40, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(height: 16),

          // Status badge.
          Center(
            child: Chip(
              label: Text(
                _capitalize(cow.status.name),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: _statusColor(cow.status),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
            ),
          ),
          const SizedBox(height: 20),

          // Identification section.
          const Text('Identification',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _detailRow('Tag Number', cow.tagNumber),
          _detailRow('Breed', cow.breed),
          _detailRow(
              'Sex', cow.sex == CowSex.female ? 'Female' : 'Male'),

          const SizedBox(height: 20),

          // Dates section.
          const Text('Dates',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _detailRow('Date of Birth', _formatDate(cow.dateOfBirth)),
          _detailRow(
              'Acquisition Date', _formatDate(cow.acquisitionDate)),

          const SizedBox(height: 20),

          // Additional info section.
          const Text('Additional Info',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _detailRow(
            'Source',
            cow.source?.isNotEmpty == true
                ? cow.source!
                : 'Not recorded',
          ),
          _detailRow(
            'Notes',
            cow.notes?.isNotEmpty == true ? cow.notes! : 'None',
          ),

          const SizedBox(height: 20),

          // Health records button.
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HealthRecordsScreen(
                    cowId: cow.id,
                    cowTag: cow.tagNumber,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.health_and_safety),
            label: const Text('View Health Records'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const SizedBox(height: 8),

          // Breeding records button.
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BreedingRecordsScreen(
                    cowId: cow.id,
                    cowTag: cow.tagNumber,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.favorite),
            label: const Text('View Breeding Records'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const SizedBox(height: 20),

          // Milk production records button.
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MilkProductionScreen(
                    cowId: cow.id,
                    cowTag: cow.tagNumber,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.water_drop),
            label: const Text('View Milk Production'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
          ),

          // Financial history section.
          const Text('Financial History',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),

          // Income/expense summary for this cow.
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Income',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      Text(
                        _formatAmount(cowIncome),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expenses',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey)),
                      Text(
                        _formatAmount(cowExpense),
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Transaction list for this cow.
          if (_loadingTx)
            const Center(child: CircularProgressIndicator())
          else if (_transactions.isEmpty)
            const Text(
              'No transactions linked to this cow yet.',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            )
          else
            ..._transactions.map(_transactionRow),

          const SizedBox(height: 20),

          // Record info section.
          const Text('Record Info',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _detailRow('Created', _formatDate(cow.createdAt)),
          _detailRow('Last Updated', _formatDate(cow.updatedAt)),
          _detailRow('Sync Status', _capitalize(cow.syncStatus.name)),
        ],
      ),
    );
  }
}