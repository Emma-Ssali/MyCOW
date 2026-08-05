import 'package:flutter/material.dart';
import '../services/pdf_service.dart';

/// Reports screen — lets the user generate and export PDF reports.
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  bool _generating = false;
  String? _currentReport;

  Future<void> _generate(
      String reportName, Future<void> Function() generator) async {
    setState(() {
      _generating = true;
      _currentReport = reportName;
    });

    try {
      await generator();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error generating report: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _generating = false;
          _currentReport = null;
        });
      }
    }
  }

  Widget _reportCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isLoading = _generating && _currentReport == title;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description,
            style: const TextStyle(fontSize: 12)),
        trailing: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.picture_as_pdf,
                color: _generating ? Colors.grey : Colors.red),
        onTap: _generating ? null : onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_generating)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child:
                        CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 12),
                  Text('Generating $_currentReport...',
                      style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),

          _reportCard(
            title: 'Farm Summary',
            description:
                'Overview of all cows, financial totals and breed breakdown',
            icon: Icons.summarize,
            color: Colors.green,
            onTap: () => _generate(
              'Farm Summary',
              PdfService().generateFarmSummary,
            ),
          ),

          _reportCard(
            title: 'Cow Inventory',
            description:
                'Full list of all cows with breed, sex, status and acquisition date',
            icon: Icons.pets,
            color: Colors.brown,
            onTap: () => _generate(
              'Cow Inventory',
              PdfService().generateCowInventory,
            ),
          ),

          _reportCard(
            title: 'Income & Expense Report',
            description:
                'All financial transactions with totals and net profit/loss',
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
            onTap: () => _generate(
              'Income & Expense Report',
              PdfService().generateFinancialReport,
            ),
          ),

          _reportCard(
            title: 'Health Report',
            description:
                'All health records across all cows with costs',
            icon: Icons.health_and_safety,
            color: Colors.teal,
            onTap: () => _generate(
              'Health Report',
              PdfService().generateHealthReport,
            ),
          ),
        ],
      ),
    );
  }
}