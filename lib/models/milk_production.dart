import 'package:isar/isar.dart';

part 'milk_production.g.dart';

/// Sync status — mirrors the pattern used in other models.
enum MilkSyncStatus {
  pending,
  synced,
  failed,
}

@collection
class MilkProduction {
  Id id = Isar.autoIncrement;

  // The cow this record belongs to.
  int cowId = 0;

  // Date of this milk record.
  DateTime date = DateTime.now();

  // Morning yield in litres.
  double morningLitres = 0.0;

  // Evening yield in litres.
  double eveningLitres = 0.0;

  // Total daily yield — computed on save.
  double totalLitres = 0.0;

  // Price per litre in UGX (optional — for revenue calculation).
  double? pricePerLitreUgx;

  // Notes.
  String? notes;

  // Farm association (Phase 4).
  String? farmId;

  // Who recorded this (Phase 4).
  String? createdBy;

  // Audit fields.
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Sync tracking.
  @enumerated
  MilkSyncStatus syncStatus = MilkSyncStatus.pending;
}