import 'package:isar/isar.dart';

part 'cow.g.dart';

enum CowStatus {
  active,
  sold,
  dead,
  missing,
}

enum CowSex {
  female,
  male,
}

enum SyncStatus {
  pending,
  synced,
  failed,
}

@collection
class Cow {
  Id id = Isar.autoIncrement;

  // Identification
  String? tagNumber;
  String name = '';

  // Breed — simple string for now, dropdown-driven
  String breed = 'Unknown';

  // Basic details
  @enumerated
  CowSex sex = CowSex.female;

  DateTime? dateOfBirth;
  DateTime acquisitionDate = DateTime.now();
  String? source;

  // Status
  @enumerated
  CowStatus status = CowStatus.active;

  // Additional
  String? notes;
  String? photoPath;

  // Farm association (used later)
  String? farmId;

  // Audit fields
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  String? createdBy;

  // Sync tracking (used later)
  @enumerated
  SyncStatus syncStatus = SyncStatus.pending;

  // Convenience getter
  @ignore
  bool get isTagged => tagNumber != null && tagNumber!.isNotEmpty;
}