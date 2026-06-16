import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/transaction.dart';
import '../models/cow.dart';
import 'add_transaction_screen.dart';
import 'edit_transaction_screen.dart';

/// Displays all recorded transactions with filtering by type and category.
class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  List<FarmTransaction> _allTransactions = [];
  List<FarmTransaction> _filteredTransactions = [];
  Map<int, Cow> _cowMap = {}; // cowId → Cow, for displaying linked cow tags.
  bool _loading = true;

  // Filter state — null means show all types.
  TransactionType? _typeFilter;
  String? _categoryFilter;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Loads all transactions and all cows (for tag lookups) from Isar.
  Future<void> _loadData() async {
    setState(() => _loading = true);

    final transactions = await isar.farmTransactions
        .where()
        .sortByDateDesc()
        .findAll();

    final cows = await isar.cows.where().findAll();

    setState(() {
      _allTransactions = transactions;
      _cowMap = {for (final cow in cows) cow.id: cow};
      _loading = false;
    });

    _applyFilters();
  }

  /// Applies type and category filters to the full transaction list.
  void _applyFilters() {
    setState(() {
      _filteredTransactions = _allTransactions.where((tx) {
        final matchesType =
            _typeFilter == null || tx.type == _typeFilter;
        final matchesCategory =
            _categoryFilter == null || tx.category == _categoryFilter;
        return matchesType && matchesCategory;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _typeFilter = null;
      _categoryFilter = null;
    });
    _applyFilters();
  }

  /// Deletes a transaction after confirmation.
  Future<void> _deleteTransaction(FarmTransaction tx) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete transaction?'),
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
        await isar.farmTransactions.delete(tx.id);
      });
      _loadData();
    }
  }

  /// Formats UGX amounts with thousands separator.
  String _formatAmount(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'UGX $formatted';
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  /// Returns the unique categories currently present in all transactions.
  List<String> get _availableCategories {
    final cats = _allTransactions.map((tx) => tx.category).toSet().toList();
    cats.sort();
    return cats;
  }

  /// Totals for the currently filtered transactions.
  double get _filteredIncome => _filteredTransactions
      .where((tx) => tx.type == TransactionType.income)
      .fold(0, (sum, tx) => sum + tx.amountUgx);

  double get _filteredExpense => _filteredTransactions
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0, (sum, tx) => sum + tx.amountUgx);

  @override
  Widget build(BuildContext context) {
    final filtersActive = _typeFilter != null || _categoryFilter != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_allTransactions.length} total',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter chips row.
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Row(
                    children: [
                      // Type filter chips.
                      FilterChip(
                        label: const Text('Income'),
                        selected: _typeFilter == TransactionType.income,
                        selectedColor: Colors.green.withValues(alpha: 0.2),
                        checkmarkColor: Colors.green,
                        onSelected: (selected) {
                          setState(() => _typeFilter =
                              selected ? TransactionType.income : null);
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 6),
                      FilterChip(
                        label: const Text('Expense'),
                        selected: _typeFilter == TransactionType.expense,
                        selectedColor: Colors.red.withValues(alpha: 0.2),
                        checkmarkColor: Colors.red,
                        onSelected: (selected) {
                          setState(() => _typeFilter =
                              selected ? TransactionType.expense : null);
                          _applyFilters();
                        },
                      ),
                      const SizedBox(width: 12),

                      // Divider.
                      Container(
                          width: 1, height: 24, color: Colors.grey.shade300),
                      const SizedBox(width: 12),

                      // Category filter chips — only for categories that exist.
                      ..._availableCategories.map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: FilterChip(
                              label: Text(cat),
                              selected: _categoryFilter == cat,
                              onSelected: (selected) {
                                setState(() =>
                                    _categoryFilter = selected ? cat : null);
                                _applyFilters();
                              },
                            ),
                          )),

                      // Clear filters button.
                      if (filtersActive) ...[
                        const SizedBox(width: 6),
                        ActionChip(
                          label: const Text('Clear'),
                          avatar: const Icon(Icons.close, size: 16),
                          onPressed: _clearFilters,
                        ),
                      ],
                    ],
                  ),
                ),

                // Summary bar — totals for filtered transactions.
                if (_filteredTransactions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Income total.
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Income',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            Text(
                              _formatAmount(_filteredIncome),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        // Expense total.
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Expenses',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            Text(
                              _formatAmount(_filteredExpense),
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        // Net total.
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Net',
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey)),
                            Text(
                              _formatAmount(
                                  _filteredIncome - _filteredExpense),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _filteredIncome - _filteredExpense >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                // Transaction list or empty state.
                Expanded(
                  child: _filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            filtersActive
                                ? 'No transactions match your filter.'
                                : 'No transactions yet.\nTap + to record one.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(12, 0, 12, 12),
                            itemCount: _filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final tx = _filteredTransactions[index];
                              final linkedCow = tx.cowId != null
                                  ? _cowMap[tx.cowId]
                                  : null;
                              final isIncome =
                                  tx.type == TransactionType.income;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: ListTile(
                                  // Tap to edit.
                                  onTap: () async {
                                    final updated =
                                        await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditTransactionScreen(
                                                transaction: tx),
                                      ),
                                    );
                                    if (updated == true) _loadData();
                                  },

                                  // Icon indicating income or expense.
                                  leading: CircleAvatar(
                                    backgroundColor: isIncome
                                        ? Colors.green.withValues(alpha: 0.15)
                                        : Colors.red.withValues(alpha: 0.15),
                                    child: Icon(
                                      isIncome
                                          ? Icons.arrow_downward
                                          : Icons.arrow_upward,
                                      color: isIncome
                                          ? Colors.green
                                          : Colors.red,
                                      size: 20,
                                    ),
                                  ),

                                  title: Text(
                                    tx.category,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),

                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (tx.description != null)
                                        Text(tx.description!,
                                            style: const TextStyle(
                                                fontSize: 12)),
                                      if (linkedCow != null)
                                        Text(
                                          'Cow: ${linkedCow.tagNumber}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey),
                                        ),
                                      Text(
                                        _formatDate(tx.date),
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  isThreeLine: true,

                                  // Amount + delete button.
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${isIncome ? '+' : '-'}${_formatAmount(tx.amountUgx)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: isIncome
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _deleteTransaction(tx),
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
              builder: (context) => const AddTransactionScreen(),
            ),
          );
          if (saved == true) _loadData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}