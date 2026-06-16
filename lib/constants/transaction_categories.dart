import '../models/transaction.dart';

/// Human-readable labels for income categories.
const Map<IncomeCategory, String> kIncomeCategoryLabels = {
  IncomeCategory.milkSales: 'Milk Sales',
  IncomeCategory.cowSales: 'Cow Sales',
  IncomeCategory.calfSales: 'Calf Sales',
  IncomeCategory.breedingServices: 'Breeding Services',
  IncomeCategory.manureSales: 'Manure Sales',
  IncomeCategory.otherIncome: 'Other Income',
};

/// Human-readable labels for expense categories.
const Map<ExpenseCategory, String> kExpenseCategoryLabels = {
  ExpenseCategory.feed: 'Feed & Fodder',
  ExpenseCategory.veterinary: 'Veterinary',
  ExpenseCategory.labour: 'Labour',
  ExpenseCategory.fuel: 'Fuel',
  ExpenseCategory.transportation: 'Transportation',
  ExpenseCategory.tagging: 'Tagging & ID',
  ExpenseCategory.equipment: 'Equipment',
  ExpenseCategory.animalPurchases: 'Animal Purchases',
  ExpenseCategory.otherExpenses: 'Other Expenses',
};

/// Returns the full list of income category label strings.
List<String> get kIncomeCategoryStrings =>
    kIncomeCategoryLabels.values.toList();

/// Returns the full list of expense category label strings.
List<String> get kExpenseCategoryStrings =>
    kExpenseCategoryLabels.values.toList();