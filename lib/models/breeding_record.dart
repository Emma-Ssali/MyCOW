import 'package:isar/isar.dart';

part 'breeding_record.g.dart';

/// Pregnancy status of the cow.
enum PregnancyStatus {
  unknown,
  confirmed,
  notPregnant,
  delivered,
}

/// Sync status.
enum BreedingSyncStatus {
  pending,
  synced,
  failed,
}

@collection
class BreedingRecord {
  Id id = Isar.autoIncrement;

  // The cow this breeding record belongs to.
  int cowId = 0;

  // Date heat was detected.
  DateTime? heatDate;

  // Date of service (insemination or natural mating).
  DateTime? serviceDate;

  // Bull used or semen source.
  String? bullUsed;

  // Whether artificial insemination was used.
  bool artificialInsemination = false;

  // Pregnancy status.
  @enumerated
  PregnancyStatus pregnancyStatus = PregnancyStatus.unknown;

  // Expected calving date (calculated from service date).
  DateTime? expectedCalvingDate;

  // Actual calving date.
  DateTime? actualCalvingDate;

  // Number of calves born.
  int? calvesBorn;

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
  BreedingSyncStatus syncStatus = BreedingSyncStatus.pending;
}