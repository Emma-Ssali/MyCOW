import 'package:isar/isar.dart';

part 'transaction.g.dart';

/// Whether this transaction represents money coming in or going out.
enum TransactionType {
  income,
  expense,
}

/// Sync status — mirrors the same pattern used in the Cow model.
enum TransactionSyncStatus {
  pending,
  synced,
  failed,
}

/// Income categories — what the farm earns from.
enum IncomeCategory {
  milkSales,
  cowSales,
  calfSales,
  breedingServices,
  manureSales,
  otherIncome,
}

/// Expense categories — what the farm spends on.
enum ExpenseCategory {
  feed,
  veterinary,
  labour,
  fuel,
  transportation,
  tagging,
  equipment,
  animalPurchases,
  otherExpenses,
}

@collection
class FarmTransaction {
  Id id = Isar.autoIncrement;

  // Type: income or expense.
  @enumerated
  TransactionType type = TransactionType.income;

  // Amount in Ugandan Shillings.
  double amountUgx = 0.0;

  // Category — stored as strings so we can handle both
  // income and expense categories in one field cleanly.
  String category = '';

  // Optional description / notes.
  String? description;

  // The date this transaction occurred (not when it was recorded).
  DateTime date = DateTime.now();

  // Optional link to a specific cow — stored as the cow's Isar id.
  // Null means this transaction is not tied to a specific animal.
  int? cowId;

  // Who recorded this transaction (used in Phase 4 multi-user).
  String? createdBy;

  // Farm association (used in Phase 4 multi-farm).
  String? farmId;

  // Audit fields.
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Sync tracking.
  @enumerated
  TransactionSyncStatus syncStatus = TransactionSyncStatus.pending;
}