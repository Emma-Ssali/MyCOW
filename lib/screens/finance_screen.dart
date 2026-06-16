import 'package:flutter/material.dart';
import 'transaction_list_screen.dart';

/// Finance screen — entry point for the Finance tab.
/// Delegates entirely to the TransactionListScreen.
class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen();
  }
}