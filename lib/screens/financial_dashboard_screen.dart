import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/transaction.dart';

/// Financial Dashboard — shows income, expenses, net profit/loss,
/// monthly summary, and category breakdown.
class FinancialDashboardScreen extends StatefulWidget {
  const FinancialDashboardScreen({super.key});

  @override
  State<FinancialDashboardScreen> createState() =>
      _FinancialDashboardScreenState();
}

class _FinancialDashboardScreenState
    extends State<FinancialDashboardScreen> {
  List<FarmTransaction> _transactions = [];
  bool _loading = true;

  // Selected year for monthly summary — defaults to current year.
  late int _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = DateTime.now().year;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final transactions =
        await isar.farmTransactions.where().findAll();
    setState(() {
      _transactions = transactions;
      _loading = false;
    });
  }

  // ── Computed totals ──────────────────────────────────────────────

  double get _totalIncome => _transactions
      .where((tx) => tx.type == TransactionType.income)
      .fold(0, (sum, tx) => sum + tx.amountUgx);

  double get _totalExpense => _transactions
      .where((tx) => tx.type == TransactionType.expense)
      .fold(0, (sum, tx) => sum + tx.amountUgx);

  double get _netBalance => _totalIncome - _totalExpense;

  /// Monthly totals for the selected year.
  List<Map<String, double>> get _monthlyData {
    final months = List.generate(
      12,
      (_) => {'income': 0.0, 'expense': 0.0},
    );
    for (final tx in _transactions) {
      if (tx.date.year == _selectedYear) {
        final month = tx.date.month - 1;
        if (tx.type == TransactionType.income) {
          months[month]['income'] =
              (months[month]['income'] ?? 0) + tx.amountUgx;
        } else {
          months[month]['expense'] =
              (months[month]['expense'] ?? 0) + tx.amountUgx;
        }
      }
    }
    return months;
  }

  /// Income grouped by category, sorted by amount descending.
  List<MapEntry<String, double>> get _incomeByCategory {
    final map = <String, double>{};
    for (final tx
        in _transactions.where((tx) => tx.type == TransactionType.income)) {
      map[tx.category] = (map[tx.category] ?? 0) + tx.amountUgx;
    }
    final entries = map.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  /// Expenses grouped by category, sorted by amount descending.
  List<MapEntry<String, double>> get _expenseByCategory {
    final map = <String, double>{};
    for (final tx in _transactions
        .where((tx) => tx.type == TransactionType.expense)) {
      map[tx.category] = (map[tx.category] ?? 0) + tx.amountUgx;
    }
    final entries = map.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries;
  }

  // ── Formatters ───────────────────────────────────────────────────

  String _formatAmount(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'UGX $formatted';
  }

  // ── Widgets ──────────────────────────────────────────────────────

  /// Top summary card — label + formatted amount.
  Widget _summaryCard(String label, double amount, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Text(
                _formatAmount(amount),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Horizontal progress bar showing a category's share of the total.
  Widget _categoryBar(
      String label, double amount, double total, Color color) {
    final percent = total == 0 ? 0.0 : amount / total;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                _formatAmount(amount),
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  /// Monthly summary row for a given month index (0 = Jan).
  Widget _monthRow(int monthIndex, Map<String, double> data) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final income = data['income'] ?? 0;
    final expense = data['expense'] ?? 0;
    final net = income - expense;

    // Skip months with no data.
    if (income == 0 && expense == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Month label.
          SizedBox(
            width: 36,
            child: Text(
              monthNames[monthIndex],
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),

          // Income + expense + net columns.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '+${_formatAmount(income)}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.green),
                    ),
                    Text(
                      '-${_formatAmount(expense)}',
                      style: const TextStyle(
                          fontSize: 12, color: Colors.red),
                    ),
                    Text(
                      _formatAmount(net),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: net >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Visual bar: green = income share, red = expense share.
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: income + expense == 0
                        ? 0
                        : income / (income + expense),
                    minHeight: 6,
                    backgroundColor: Colors.red.shade100,
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monthly = _monthlyData;
    final hasTransactions = _transactions.isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Financial Dashboard')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Top summary row ──
                  Row(
                    children: [
                      _summaryCard(
                          'Total Income', _totalIncome, Colors.green),
                      const SizedBox(width: 8),
                      _summaryCard(
                          'Total Expenses', _totalExpense, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Net balance — full width card.
                  Card(
                    color: _netBalance >= 0
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Net Profit / Loss',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            _formatAmount(_netBalance.abs()),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _netBalance >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (!hasTransactions)
                    const Center(
                      child: Text(
                        'No transactions recorded yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else ...[
                    // ── Monthly summary ──
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Monthly Summary',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        // Year picker.
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.chevron_left),
                              iconSize: 20,
                              onPressed: () =>
                                  setState(() => _selectedYear--),
                            ),
                            Text(
                              '$_selectedYear',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                                icon: const Icon(Icons.chevron_right),
                                iconSize: 20,
                                onPressed: _selectedYear < DateTime.now().year
                                    ? () => setState(() => _selectedYear++)
                                    : null,
                              ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),

                    // Column headers.
                    const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          SizedBox(width: 44),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Income',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.green)),
                                Text('Expense',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.red)),
                                Text('Net',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Monthly rows — only months with data are shown.
                    ...List.generate(
                      12,
                      (i) => _monthRow(i, monthly[i]),
                    ),

                    const SizedBox(height: 24),

                    // ── Income by category ──
                    const Text(
                      'Income by Category',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    if (_incomeByCategory.isEmpty)
                      const Text('No income recorded.',
                          style: TextStyle(color: Colors.grey))
                    else
                      ..._incomeByCategory.map(
                        (e) => _categoryBar(
                            e.key, e.value, _totalIncome, Colors.green),
                      ),

                    const SizedBox(height: 24),

                    // ── Expenses by category ──
                    const Text(
                      'Expenses by Category',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    if (_expenseByCategory.isEmpty)
                      const Text('No expenses recorded.',
                          style: TextStyle(color: Colors.grey))
                    else
                      ..._expenseByCategory.map(
                        (e) => _categoryBar(
                            e.key, e.value, _totalExpense, Colors.red),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}