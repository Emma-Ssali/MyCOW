import 'package:isar/isar.dart';

part 'weight_record.g.dart';

/// Sync status — mirrors the pattern used in other models.
enum WeightSyncStatus {
  pending,
  synced,
  failed,
}

@collection
class WeightRecord {
  Id id = Isar.autoIncrement;

  // The cow this record belongs to.
  int cowId = 0;

  // Date the weight was recorded.
  DateTime date = DateTime.now();

  // Weight in kilograms.
  double weightKg = 0.0;

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
  WeightSyncStatus syncStatus = WeightSyncStatus.pending;
}