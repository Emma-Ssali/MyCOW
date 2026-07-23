import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../models/cow.dart';
import '../models/transaction.dart';
import '../models/health_record.dart';
import '../models/breeding_record.dart';
import '../models/milk_production.dart';
import '../models/weight_record.dart';
import 'farm_service.dart';
import 'dart:io';

/// SyncService — bidirectional sync between local Isar and Supabase.
/// Push: sends pending local records to Supabase.
/// Pull: fetches remote changes and saves them to local Isar.
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _supabase = Supabase.instance.client;
  static const _lastSyncKey = 'last_sync_at';

  /// Check if device has internet connectivity.
  Future<bool> get _hasInternet async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Get the last sync timestamp from local storage.
  Future<DateTime?> get _lastSyncAt async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_lastSyncKey);
    if (stored == null) return null;
    return DateTime.tryParse(stored);
  }

  /// Save the current time as last sync timestamp.
  Future<void> _updateLastSyncAt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastSyncKey, DateTime.now().toIso8601String());
  }

  /// Main sync entry point — push then pull.
  Future<void> sync() async {
    if (!await _hasInternet) return;

    final farmId = await FarmService().localFarmId;
    if (farmId == null) return; // No farm set up yet.

    try {
      // Push local pending records first.
      await _pushCows(farmId);
      await _pushTransactions(farmId);
      await _pushHealthRecords(farmId);
      await _pushBreedingRecords(farmId);
      await _pushMilkProduction(farmId);
      await _pushWeightRecords(farmId);

      // Then pull remote changes.
      await _pullCows(farmId);
      await _pullTransactions(farmId);
      await _pullHealthRecords(farmId);
      await _pullBreedingRecords(farmId);
      await _pullMilkProduction(farmId);
      await _pullWeightRecords(farmId);

      // Update last sync timestamp.
      await _updateLastSyncAt();
    } catch (e) {
      print('Sync error: $e');
    }
  }

  // ══════════════════════════════════════════════════════════════
  // PUSH — Local Isar → Supabase
  // ══════════════════════════════════════════════════════════════

  Future<void> _pushCows(String farmId) async {
    final pending = await isar.cows
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();

    for (final cow in pending) {
      try {
        // Upload photo to Supabase Storage if it exists locally.
        String? photoUrl;
        if (cow.photoPath != null && !cow.photoPath!.startsWith('http')) {
          // Only upload if it's a local path (not already a URL).
          photoUrl = await uploadPhoto(cow.photoPath!, cow.id);
        } else {
          photoUrl = cow.photoPath; // Already a cloud URL.
        }

        await _supabase.from('cows').upsert({
          'id': cow.id,
          'tag_number': cow.tagNumber,
          'breed': cow.breed,
          'sex': cow.sex.name,
          'status': cow.status.name,
          'date_of_birth': cow.dateOfBirth?.toIso8601String(),
          'acquisition_date': cow.acquisitionDate.toIso8601String(),
          'source': cow.source,
          'notes': cow.notes,
          'photo_path': photoUrl, // Use cloud URL instead of local path.
          'farm_id': farmId,
          'created_by': cow.createdBy,
          'created_at': cow.createdAt.toIso8601String(),
          'updated_at': cow.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          cow.syncStatus = SyncStatus.synced;
          cow.farmId = farmId;
          // Save the cloud URL locally so we don't re-upload next time.
          if (photoUrl != null) cow.photoPath = photoUrl;
          await isar.cows.put(cow);
        });

        await isar.writeTxn(() async {
          cow.syncStatus = SyncStatus.synced;
          cow.farmId = farmId;
          await isar.cows.put(cow);
        });
      } catch (e) {
        await isar.writeTxn(() async {
          cow.syncStatus = SyncStatus.failed;
          await isar.cows.put(cow);
        });
      }
    }
  }

  Future<void> _pushTransactions(String farmId) async {
    final pending = await isar.farmTransactions
        .filter()
        .syncStatusEqualTo(TransactionSyncStatus.pending)
        .findAll();

    for (final tx in pending) {
      try {
        await _supabase.from('farm_transactions').upsert({
          'id': tx.id,
          'type': tx.type.name,
          'amount_ugx': tx.amountUgx,
          'category': tx.category,
          'description': tx.description,
          'date': tx.date.toIso8601String(),
          'cow_id': tx.cowId,
          'farm_id': farmId,
          'created_by': tx.createdBy,
          'created_at': tx.createdAt.toIso8601String(),
          'updated_at': tx.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          tx.syncStatus = TransactionSyncStatus.synced;
          tx.farmId = farmId;
          await isar.farmTransactions.put(tx);
        });
      } catch (e) {
        await isar.writeTxn(() async {
          tx.syncStatus = TransactionSyncStatus.failed;
          await isar.farmTransactions.put(tx);
        });
      }
    }
  }

  Future<void> _pushHealthRecords(String farmId) async {
    final pending = await isar.healthRecords
        .filter()
        .syncStatusEqualTo(HealthSyncStatus.pending)
        .findAll();

    for (final record in pending) {
      try {
        await _supabase.from('health_records').upsert({
          'id': record.id,
          'cow_id': record.cowId,
          'type': record.type.name,
          'date': record.date.toIso8601String(),
          'medication': record.medication,
          'veterinarian': record.veterinarian,
          'cost_ugx': record.costUgx,
          'notes': record.notes,
          'farm_id': farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = HealthSyncStatus.synced;
          record.farmId = farmId;
          await isar.healthRecords.put(record);
        });
      } catch (e) {
        await isar.writeTxn(() async {
          record.syncStatus = HealthSyncStatus.failed;
          await isar.healthRecords.put(record);
        });
      }
    }
  }

  Future<void> _pushBreedingRecords(String farmId) async {
    final pending = await isar.breedingRecords
        .filter()
        .syncStatusEqualTo(BreedingSyncStatus.pending)
        .findAll();

    for (final record in pending) {
      try {
        await _supabase.from('breeding_records').upsert({
          'id': record.id,
          'cow_id': record.cowId,
          'heat_date': record.heatDate?.toIso8601String(),
          'service_date': record.serviceDate?.toIso8601String(),
          'bull_used': record.bullUsed,
          'artificial_insemination': record.artificialInsemination,
          'pregnancy_status': record.pregnancyStatus.name,
          'expected_calving_date':
              record.expectedCalvingDate?.toIso8601String(),
          'actual_calving_date':
              record.actualCalvingDate?.toIso8601String(),
          'calves_born': record.calvesBorn,
          'notes': record.notes,
          'farm_id': farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = BreedingSyncStatus.synced;
          record.farmId = farmId;
          await isar.breedingRecords.put(record);
        });
      } catch (e) {
        await isar.writeTxn(() async {
          record.syncStatus = BreedingSyncStatus.failed;
          await isar.breedingRecords.put(record);
        });
      }
    }
  }

  Future<void> _pushMilkProduction(String farmId) async {
    final pending = await isar.milkProductions
        .filter()
        .syncStatusEqualTo(MilkSyncStatus.pending)
        .findAll();

    for (final record in pending) {
      try {
        await _supabase.from('milk_production').upsert({
          'id': record.id,
          'cow_id': record.cowId,
          'date': record.date.toIso8601String(),
          'morning_litres': record.morningLitres,
          'evening_litres': record.eveningLitres,
          'total_litres': record.totalLitres,
          'price_per_litre_ugx': record.pricePerLitreUgx,
          'notes': record.notes,
          'farm_id': farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = MilkSyncStatus.synced;
          record.farmId = farmId;
          await isar.milkProductions.put(record);
        });
      } catch (e) {
        await isar.writeTxn(() async {
          record.syncStatus = MilkSyncStatus.failed;
          await isar.milkProductions.put(record);
        });
      }
    }
  }

  Future<void> _pushWeightRecords(String farmId) async {
    final pending = await isar.weightRecords
        .filter()
        .syncStatusEqualTo(WeightSyncStatus.pending)
        .findAll();

    for (final record in pending) {
      try {
        await _supabase.from('weight_records').upsert({
          'id': record.id,
          'cow_id': record.cowId,
          'date': record.date.toIso8601String(),
          'weight_kg': record.weightKg,
          'notes': record.notes,
          'farm_id': farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = WeightSyncStatus.synced;
          record.farmId = farmId;
          await isar.weightRecords.put(record);
        });
      } catch (e) {
        await isar.writeTxn(() async {
          record.syncStatus = WeightSyncStatus.failed;
          await isar.weightRecords.put(record);
        });
      }
    }
  }

  /// Uploads a local photo file to Supabase Storage
  /// and returns the public URL.
  Future<String?> uploadPhoto(String localPath, int cowId) async {
    try {
      final file = File(localPath);
      if (!await file.exists()) return null;

      final extension = localPath.split('.').last;
      final fileName = 'cow_$cowId\_${DateTime.now().millisecondsSinceEpoch}.$extension';

      await _supabase.storage
          .from('cow-photos')
          .upload(fileName, file);

      final publicUrl = _supabase.storage
          .from('cow-photos')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      print('Photo upload error: $e');
      return null;
    }
  }

  // ══════════════════════════════════════════════════════════════
  // PULL — Supabase → Local Isar
  // ══════════════════════════════════════════════════════════════

  Future<void> _pullCows(String farmId) async {
  // Temporarily ignore lastSync to force full pull for testing.
  // final lastSync = await _lastSyncAt;

  // Fetch ALL records for this farm (ignoring last sync timestamp for now).
  final data = await _supabase
      .from('cows')
      .select()
      .eq('farm_id', farmId)
      .eq('is_deleted', false);

  for (final row in data) {
    try {
      // Check if record already exists locally.
      final existing = await isar.cows.get(row['id'] as int);

      // Skip if local record is newer (last-write-wins).
      if (existing != null &&
          existing.updatedAt
              .isAfter(DateTime.parse(row['updated_at']))) {
        continue;
      }

      final cow = existing ?? Cow();
      cow.id = row['id'] as int;
      cow.tagNumber = row['tag_number'] ?? '';
      cow.breed = row['breed'] ?? 'Unknown';
      cow.sex = row['sex'] == 'male' ? CowSex.male : CowSex.female;
      cow.status = _parseCowStatus(row['status']);
      cow.dateOfBirth = row['date_of_birth'] != null
          ? DateTime.tryParse(row['date_of_birth'])
          : null;
      cow.acquisitionDate = DateTime.parse(row['acquisition_date']);
      cow.source = row['source'];
      cow.notes = row['notes'];
      cow.photoPath = row['photo_path'];
      cow.farmId = row['farm_id'];
      cow.createdBy = row['created_by'];
      cow.createdAt = DateTime.parse(row['created_at']);
      cow.updatedAt = DateTime.parse(row['updated_at']);
      cow.syncStatus = SyncStatus.synced;

      await isar.writeTxn(() async {
        await isar.cows.put(cow);
      });
    } catch (e) {
      print('Error pulling cow ${row['id']}: $e');
    }
  }
}

  Future<void> _pullTransactions(String farmId) async {
    final lastSync = await _lastSyncAt;

    var query = _supabase
        .from('farm_transactions')
        .select()
        .eq('farm_id', farmId)
        .eq('is_deleted', false);

    final data = lastSync != null
        ? await query.gt('updated_at', lastSync.toIso8601String())
        : await query;

    for (final row in data) {
      try {
        final existing =
            await isar.farmTransactions.get(row['id'] as int);

        if (existing != null &&
            existing.updatedAt
                .isAfter(DateTime.parse(row['updated_at']))) {
          continue;
        }

        final tx = existing ?? FarmTransaction();
        tx.id = row['id'] as int;
        tx.type = row['type'] == 'income'
            ? TransactionType.income
            : TransactionType.expense;
        tx.amountUgx = (row['amount_ugx'] as num).toDouble();
        tx.category = row['category'] ?? '';
        tx.description = row['description'];
        tx.date = DateTime.parse(row['date']);
        tx.cowId = row['cow_id'] as int?;
        tx.farmId = row['farm_id'];
        tx.createdBy = row['created_by'];
        tx.createdAt = DateTime.parse(row['created_at']);
        tx.updatedAt = DateTime.parse(row['updated_at']);
        tx.syncStatus = TransactionSyncStatus.synced;

        await isar.writeTxn(() async {
          await isar.farmTransactions.put(tx);
        });
      } catch (e) {
        print('Error pulling transaction ${row['id']}: $e');
      }
    }
  }

  Future<void> _pullHealthRecords(String farmId) async {
    final lastSync = await _lastSyncAt;

    var query = _supabase
        .from('health_records')
        .select()
        .eq('farm_id', farmId)
        .eq('is_deleted', false);

    final data = lastSync != null
        ? await query.gt('updated_at', lastSync.toIso8601String())
        : await query;

    for (final row in data) {
      try {
        final existing =
            await isar.healthRecords.get(row['id'] as int);

        if (existing != null &&
            existing.updatedAt
                .isAfter(DateTime.parse(row['updated_at']))) {
          continue;
        }

        final record = existing ?? HealthRecord();
        record.id = row['id'] as int;
        record.cowId = row['cow_id'] as int;
        record.type = _parseHealthType(row['type']);
        record.date = DateTime.parse(row['date']);
        record.medication = row['medication'];
        record.veterinarian = row['veterinarian'];
        record.costUgx = row['cost_ugx'] != null
            ? (row['cost_ugx'] as num).toDouble()
            : null;
        record.notes = row['notes'];
        record.farmId = row['farm_id'];
        record.createdBy = row['created_by'];
        record.createdAt = DateTime.parse(row['created_at']);
        record.updatedAt = DateTime.parse(row['updated_at']);
        record.syncStatus = HealthSyncStatus.synced;

        await isar.writeTxn(() async {
          await isar.healthRecords.put(record);
        });
      } catch (e) {
        print('Error pulling health record ${row['id']}: $e');
      }
    }
  }

  Future<void> _pullBreedingRecords(String farmId) async {
    final lastSync = await _lastSyncAt;

    var query = _supabase
        .from('breeding_records')
        .select()
        .eq('farm_id', farmId)
        .eq('is_deleted', false);

    final data = lastSync != null
        ? await query.gt('updated_at', lastSync.toIso8601String())
        : await query;

    for (final row in data) {
      try {
        final existing =
            await isar.breedingRecords.get(row['id'] as int);

        if (existing != null &&
            existing.updatedAt
                .isAfter(DateTime.parse(row['updated_at']))) {
          continue;
        }

        final record = existing ?? BreedingRecord();
        record.id = row['id'] as int;
        record.cowId = row['cow_id'] as int;
        record.heatDate = row['heat_date'] != null
            ? DateTime.tryParse(row['heat_date'])
            : null;
        record.serviceDate = row['service_date'] != null
            ? DateTime.tryParse(row['service_date'])
            : null;
        record.bullUsed = row['bull_used'];
        record.artificialInsemination =
            row['artificial_insemination'] ?? false;
        record.pregnancyStatus =
            _parsePregnancyStatus(row['pregnancy_status']);
        record.expectedCalvingDate =
            row['expected_calving_date'] != null
                ? DateTime.tryParse(row['expected_calving_date'])
                : null;
        record.actualCalvingDate = row['actual_calving_date'] != null
            ? DateTime.tryParse(row['actual_calving_date'])
            : null;
        record.calvesBorn = row['calves_born'] as int?;
        record.notes = row['notes'];
        record.farmId = row['farm_id'];
        record.createdBy = row['created_by'];
        record.createdAt = DateTime.parse(row['created_at']);
        record.updatedAt = DateTime.parse(row['updated_at']);
        record.syncStatus = BreedingSyncStatus.synced;

        await isar.writeTxn(() async {
          await isar.breedingRecords.put(record);
        });
      } catch (e) {
        print('Error pulling breeding record ${row['id']}: $e');
      }
    }
  }

  Future<void> _pullMilkProduction(String farmId) async {
    final lastSync = await _lastSyncAt;

    var query = _supabase
        .from('milk_production')
        .select()
        .eq('farm_id', farmId)
        .eq('is_deleted', false);

    final data = lastSync != null
        ? await query.gt('updated_at', lastSync.toIso8601String())
        : await query;

    for (final row in data) {
      try {
        final existing =
            await isar.milkProductions.get(row['id'] as int);

        if (existing != null &&
            existing.updatedAt
                .isAfter(DateTime.parse(row['updated_at']))) {
          continue;
        }

        final record = existing ?? MilkProduction();
        record.id = row['id'] as int;
        record.cowId = row['cow_id'] as int;
        record.date = DateTime.parse(row['date']);
        record.morningLitres =
            (row['morning_litres'] as num).toDouble();
        record.eveningLitres =
            (row['evening_litres'] as num).toDouble();
        record.totalLitres = (row['total_litres'] as num).toDouble();
        record.pricePerLitreUgx = row['price_per_litre_ugx'] != null
            ? (row['price_per_litre_ugx'] as num).toDouble()
            : null;
        record.notes = row['notes'];
        record.farmId = row['farm_id'];
        record.createdBy = row['created_by'];
        record.createdAt = DateTime.parse(row['created_at']);
        record.updatedAt = DateTime.parse(row['updated_at']);
        record.syncStatus = MilkSyncStatus.synced;

        await isar.writeTxn(() async {
          await isar.milkProductions.put(record);
        });
      } catch (e) {
        print('Error pulling milk record ${row['id']}: $e');
      }
    }
  }

  Future<void> _pullWeightRecords(String farmId) async {
    final lastSync = await _lastSyncAt;

    var query = _supabase
        .from('weight_records')
        .select()
        .eq('farm_id', farmId)
        .eq('is_deleted', false);

    final data = lastSync != null
        ? await query.gt('updated_at', lastSync.toIso8601String())
        : await query;

    for (final row in data) {
      try {
        final existing =
            await isar.weightRecords.get(row['id'] as int);

        if (existing != null &&
            existing.updatedAt
                .isAfter(DateTime.parse(row['updated_at']))) {
          continue;
        }

        final record = existing ?? WeightRecord();
        record.id = row['id'] as int;
        record.cowId = row['cow_id'] as int;
        record.date = DateTime.parse(row['date']);
        record.weightKg = (row['weight_kg'] as num).toDouble();
        record.notes = row['notes'];
        record.farmId = row['farm_id'];
        record.createdBy = row['created_by'];
        record.createdAt = DateTime.parse(row['created_at']);
        record.updatedAt = DateTime.parse(row['updated_at']);
        record.syncStatus = WeightSyncStatus.synced;

        await isar.writeTxn(() async {
          await isar.weightRecords.put(record);
        });
      } catch (e) {
        print('Error pulling weight record ${row['id']}: $e');
      }
    }
  }

  // ══════════════════════════════════════════════════════════════
  // ENUM PARSERS
  // ══════════════════════════════════════════════════════════════

  CowStatus _parseCowStatus(String? value) {
    switch (value) {
      case 'sold':
        return CowStatus.sold;
      case 'dead':
        return CowStatus.dead;
      case 'missing':
        return CowStatus.missing;
      default:
        return CowStatus.active;
    }
  }

  HealthRecordType _parseHealthType(String? value) {
    switch (value) {
      case 'treatment':
        return HealthRecordType.treatment;
      case 'deworming':
        return HealthRecordType.deworming;
      case 'vetVisit':
        return HealthRecordType.vetVisit;
      case 'disease':
        return HealthRecordType.disease;
      case 'other':
        return HealthRecordType.other;
      default:
        return HealthRecordType.vaccination;
    }
  }

  PregnancyStatus _parsePregnancyStatus(String? value) {
    switch (value) {
      case 'confirmed':
        return PregnancyStatus.confirmed;
      case 'notPregnant':
        return PregnancyStatus.notPregnant;
      case 'delivered':
        return PregnancyStatus.delivered;
      default:
        return PregnancyStatus.unknown;
    }
  }
}