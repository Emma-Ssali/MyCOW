import 'package:isar/isar.dart';

part 'health_record.g.dart';

/// The type of health record being recorded.
enum HealthRecordType {
  vaccination,
  treatment,
  deworming,
  vetVisit,
  disease,
  other,
}

/// Sync status — mirrors the pattern used in Cow and FarmTransaction.
enum HealthSyncStatus {
  pending,
  synced,
  failed,
}

@collection
class HealthRecord {
  Id id = Isar.autoIncrement;

  // The cow this record belongs to.
  int cowId = 0;

  // Type of health event.
  @enumerated
  HealthRecordType type = HealthRecordType.vaccination;

  // Date the health event occurred.
  DateTime date = DateTime.now();

  // What was administered or done.
  String? medication;

  // Name of the veterinarian (if applicable).
  String? veterinarian;

  // Cost of treatment in UGX (optional).
  double? costUgx;

  // Free-form notes about the health event.
  String? notes;

  // Farm association (used in Phase 4).
  String? farmId;

  // Who recorded this (used in Phase 4).
  String? createdBy;

  // Audit fields.
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  // Sync tracking.
  @enumerated
  HealthSyncStatus syncStatus = HealthSyncStatus.pending;
}