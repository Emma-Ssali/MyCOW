import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart';
import '../main.dart';
import '../models/cow.dart';
import '../models/transaction.dart';
import '../models/health_record.dart';
import '../models/milk_production.dart';
import 'farm_service.dart';

/// Generates PDF reports for the farm.
class PdfService {
  static final PdfService _instance = PdfService._internal();
  factory PdfService() => _instance;
  PdfService._internal();

  // ── Helpers ──────────────────────────────────────────────────

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatAmount(double amount) {
    final formatted = amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
    return 'UGX $formatted';
  }

  /// Builds a standard page header used on all reports.
  pw.Widget _buildHeader(
      String reportTitle, String farmName, pw.Font font) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              farmName,
              style: pw.TextStyle(
                font: font,
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('2E7D32'),
              ),
            ),
            pw.Text(
              'Generated: ${_formatDate(DateTime.now())}',
              style: pw.TextStyle(
                  font: font, fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          reportTitle,
          style: pw.TextStyle(
              font: font, fontSize: 14, color: PdfColors.grey700),
        ),
        pw.Divider(color: PdfColor.fromHex('2E7D32'), thickness: 1.5),
        pw.SizedBox(height: 8),
      ],
    );
  }

  /// Saves a PDF document to local storage and triggers
  /// the share/print dialog.
  Future<void> _savePdfAndShare(
      pw.Document pdf, String fileName) async {
    final bytes = await pdf.save();
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  // ══════════════════════════════════════════════════════════════
  // REPORT 1: Farm Summary
  // ══════════════════════════════════════════════════════════════

  Future<void> generateFarmSummary() async {
    final farmName =
        await FarmService().localFarmName ?? 'My Farm';
    final cows = await isar.cows.where().findAll();
    final transactions =
        await isar.farmTransactions.where().findAll();

    final totalIncome = transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amountUgx);
    final totalExpense = transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amountUgx);
    final activeCows =
        cows.where((c) => c.status == CowStatus.active).length;

    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader('Farm Summary Report', farmName, boldFont),

            // Stats grid.
            pw.Row(
              children: [
                _summaryBox('Total Cows', '${cows.length}',
                    boldFont, font),
                pw.SizedBox(width: 12),
                _summaryBox(
                    'Active', '$activeCows', boldFont, font),
                pw.SizedBox(width: 12),
                _summaryBox(
                    'Net Balance',
                    _formatAmount(totalIncome - totalExpense),
                    boldFont,
                    font),
              ],
            ),
            pw.SizedBox(height: 20),

            // Financial summary.
            pw.Text('Financial Overview',
                style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 13,
                    color: PdfColor.fromHex('2E7D32'))),
            pw.SizedBox(height: 8),
            pw.Table(
              border: pw.TableBorder.all(
                  color: PdfColors.grey300, width: 0.5),
              children: [
                _tableHeaderRow(
                    ['Item', 'Amount'], boldFont),
                _tableRow(
                    ['Total Income', _formatAmount(totalIncome)],
                    font),
                _tableRow(
                    ['Total Expenses', _formatAmount(totalExpense)],
                    font),
                _tableRow(
                    [
                      'Net Profit/Loss',
                      _formatAmount(totalIncome - totalExpense)
                    ],
                    boldFont,
                    isTotal: true),
              ],
            ),
            pw.SizedBox(height: 20),

            // Breed breakdown.
            pw.Text('Cattle by Breed',
                style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 13,
                    color: PdfColor.fromHex('2E7D32'))),
            pw.SizedBox(height: 8),
            _breedBreakdown(cows, boldFont, font),
          ],
        ),
      ),
    );

    await _savePdfAndShare(pdf, 'farm_summary.pdf');
  }

  // ══════════════════════════════════════════════════════════════
  // REPORT 2: Cow Inventory
  // ══════════════════════════════════════════════════════════════

  Future<void> generateCowInventory() async {
    final farmName =
        await FarmService().localFarmName ?? 'My Farm';
    final cows = await isar.cows.where().sortByTagNumber().findAll();
    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final pdf = pw.Document();

    // Split into pages of 20 cows.
    const pageSize = 20;
    final pages = (cows.length / pageSize).ceil();

    for (int p = 0; p < pages; p++) {
      final pageCows = cows.skip(p * pageSize).take(pageSize).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildHeader('Cow Inventory Report', farmName, boldFont),
              pw.Text(
                'Total: ${cows.length} cows',
                style: pw.TextStyle(
                    font: font,
                    fontSize: 11,
                    color: PdfColors.grey600),
              ),
              pw.SizedBox(height: 8),
              pw.Table(
                border: pw.TableBorder.all(
                    color: PdfColors.grey300, width: 0.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(2),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  _tableHeaderRow([
                    'Tag Number',
                    'Breed',
                    'Sex',
                    'Status',
                    'Acquired'
                  ], boldFont),
                  ...pageCows.map(
                    (cow) => _tableRow([
                      cow.tagNumber,
                      cow.breed,
                      cow.sex == CowSex.female ? 'Female' : 'Male',
                      cow.status.name[0].toUpperCase() +
                          cow.status.name.substring(1),
                      _formatDate(cow.acquisitionDate),
                    ], font),
                  ),
                ],
              ),
              if (p == pages - 1) ...[
                pw.SizedBox(height: 16),
                _statusBreakdown(cows, boldFont, font),
              ],
            ],
          ),
        ),
      );
    }

    await _savePdfAndShare(pdf, 'cow_inventory.pdf');
  }

  // ══════════════════════════════════════════════════════════════
  // REPORT 3: Income & Expense Report
  // ══════════════════════════════════════════════════════════════

  Future<void> generateFinancialReport() async {
    final farmName =
        await FarmService().localFarmName ?? 'My Farm';
    final transactions = await isar.farmTransactions
        .where()
        .sortByDateDesc()
        .findAll();

    final income = transactions
        .where((t) => t.type == TransactionType.income)
        .toList();
    final expenses = transactions
        .where((t) => t.type == TransactionType.expense)
        .toList();

    final totalIncome =
        income.fold(0.0, (sum, t) => sum + t.amountUgx);
    final totalExpense =
        expenses.fold(0.0, (sum, t) => sum + t.amountUgx);

    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader('Income & Expense Report', farmName, boldFont),
        build: (context) => [
          // Summary row.
          pw.Row(
            children: [
              _summaryBox('Total Income',
                  _formatAmount(totalIncome), boldFont, font,
                  color: PdfColor.fromHex('2E7D32')),
              pw.SizedBox(width: 12),
              _summaryBox('Total Expenses',
                  _formatAmount(totalExpense), boldFont, font,
                  color: PdfColor.fromHex('C62828')),
              pw.SizedBox(width: 12),
              _summaryBox(
                  'Net',
                  _formatAmount(totalIncome - totalExpense),
                  boldFont,
                  font,
                  color: totalIncome - totalExpense >= 0
                      ? PdfColor.fromHex('2E7D32')
                      : PdfColor.fromHex('C62828')),
            ],
          ),
          pw.SizedBox(height: 20),

          // Income table.
          pw.Text('Income',
              style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 13,
                  color: PdfColor.fromHex('2E7D32'))),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(
                color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              _tableHeaderRow(['Date', 'Category', 'Amount'],
                  boldFont),
              ...income.map((t) => _tableRow([
                    _formatDate(t.date),
                    t.category,
                    _formatAmount(t.amountUgx),
                  ], font)),
              _tableRow([
                'TOTAL',
                '',
                _formatAmount(totalIncome)
              ], boldFont, isTotal: true),
            ],
          ),
          pw.SizedBox(height: 20),

          // Expense table.
          pw.Text('Expenses',
              style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 13,
                  color: PdfColor.fromHex('C62828'))),
          pw.SizedBox(height: 6),
          pw.Table(
            border: pw.TableBorder.all(
                color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              _tableHeaderRow(['Date', 'Category', 'Amount'],
                  boldFont),
              ...expenses.map((t) => _tableRow([
                    _formatDate(t.date),
                    t.category,
                    _formatAmount(t.amountUgx),
                  ], font)),
              _tableRow([
                'TOTAL',
                '',
                _formatAmount(totalExpense)
              ], boldFont, isTotal: true),
            ],
          ),
        ],
      ),
    );

    await _savePdfAndShare(pdf, 'financial_report.pdf');
  }

  // ══════════════════════════════════════════════════════════════
  // REPORT 4: Health Report
  // ══════════════════════════════════════════════════════════════

  Future<void> generateHealthReport() async {
    final farmName =
        await FarmService().localFarmName ?? 'My Farm';
    final records = await isar.healthRecords
        .where()
        .sortByDateDesc()
        .findAll();
    final cows = await isar.cows.where().findAll();
    final cowMap = {for (final cow in cows) cow.id: cow};

    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();
    final pdf = pw.Document();

    final totalCost = records
        .where((r) => r.costUgx != null)
        .fold(0.0, (sum, r) => sum + (r.costUgx ?? 0));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _buildHeader('Health Records Report', farmName, boldFont),
        build: (context) => [
          pw.Text(
            'Total health costs: ${_formatAmount(totalCost)}',
            style: pw.TextStyle(font: boldFont, fontSize: 12),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(
                color: PdfColors.grey300, width: 0.5),
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
              4: const pw.FlexColumnWidth(1.5),
            },
            children: [
              _tableHeaderRow([
                'Date',
                'Cow Tag',
                'Type',
                'Medication',
                'Cost (UGX)'
              ], boldFont),
              ...records.map((r) {
                final cow = cowMap[r.cowId];
                return _tableRow([
                  _formatDate(r.date),
                  cow?.tagNumber ?? '—',
                  r.type.name[0].toUpperCase() +
                      r.type.name.substring(1),
                  r.medication ?? '—',
                  r.costUgx != null
                      ? _formatAmount(r.costUgx!)
                      : '—',
                ], font);
              }),
            ],
          ),
        ],
      ),
    );

    await _savePdfAndShare(pdf, 'health_report.pdf');
  }

  // ══════════════════════════════════════════════════════════════
  // SHARED WIDGET BUILDERS
  // ══════════════════════════════════════════════════════════════

  pw.Widget _summaryBox(
      String label, String value, pw.Font boldFont, pw.Font font,
      {PdfColor? color}) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: (color ?? PdfColor.fromHex('2E7D32'))
              .shade(0.9),
          borderRadius:
              const pw.BorderRadius.all(pw.Radius.circular(6)),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label,
                style: pw.TextStyle(
                    font: font,
                    fontSize: 9,
                    color: PdfColors.grey700)),
            pw.SizedBox(height: 4),
            pw.Text(value,
                style: pw.TextStyle(
                  font: boldFont,
                  fontSize: 12,
                  color: color ?? PdfColor.fromHex('2E7D32'),
                )),
          ],
        ),
      ),
    );
  }

  pw.TableRow _tableHeaderRow(List<String> cells, pw.Font boldFont) {
    return pw.TableRow(
      decoration: pw.BoxDecoration(
          color: PdfColor.fromHex('2E7D32').shade(0.85)),
      children: cells
          .map((cell) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6, vertical: 5),
                child: pw.Text(
                  cell,
                  style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 10,
                      color: PdfColors.white),
                ),
              ))
          .toList(),
    );
  }

  pw.TableRow _tableRow(List<String> cells, pw.Font font,
      {bool isTotal = false}) {
    return pw.TableRow(
      decoration: isTotal
          ? pw.BoxDecoration(color: PdfColors.grey200)
          : null,
      children: cells
          .map((cell) => pw.Padding(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 6, vertical: 4),
                child: pw.Text(
                  cell,
                  style: pw.TextStyle(
                      font: font,
                      fontSize: 9,
                      fontWeight: isTotal
                          ? pw.FontWeight.bold
                          : pw.FontWeight.normal),
                ),
              ))
          .toList(),
    );
  }

  pw.Widget _breedBreakdown(
      List<Cow> cows, pw.Font boldFont, pw.Font font) {
    final breedMap = <String, int>{};
    for (final cow in cows) {
      breedMap[cow.breed] = (breedMap[cow.breed] ?? 0) + 1;
    }
    final entries = breedMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return pw.Table(
      border:
          pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        _tableHeaderRow(['Breed', 'Count'], boldFont),
        ...entries.map(
            (e) => _tableRow([e.key, '${e.value}'], font)),
      ],
    );
  }

  pw.Widget _statusBreakdown(
      List<Cow> cows, pw.Font boldFont, pw.Font font) {
    final statusMap = <String, int>{};
    for (final cow in cows) {
      final s = cow.status.name[0].toUpperCase() +
          cow.status.name.substring(1);
      statusMap[s] = (statusMap[s] ?? 0) + 1;
    }

    return pw.Table(
      border:
          pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        _tableHeaderRow(['Status', 'Count'], boldFont),
        ...statusMap.entries
            .map((e) => _tableRow([e.key, '${e.value}'], font)),
      ],
    );
  }
}