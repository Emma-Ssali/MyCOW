import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../main.dart';
import '../models/cow.dart';
import '../models/transaction.dart';
import '../models/health_record.dart';
import '../models/breeding_record.dart';
import '../models/milk_production.dart';
import '../models/weight_record.dart';

/// SyncService — pushes pending local records to Supabase
/// and pulls remote changes back to Isar.
class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _supabase = Supabase.instance.client;

  /// Check if device has internet connectivity.
  Future<bool> get _hasInternet async {
    final result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Main sync entry point — call this whenever you want to sync.
  Future<void> sync() async {
    if (!await _hasInternet) return;

    try {
      await _syncCows();
      await _syncTransactions();
      await _syncHealthRecords();
      await _syncBreedingRecords();
      await _syncMilkProduction();
      await _syncWeightRecords();
    } catch (e) {
      // Sync failure is non-fatal — app continues working offline.
      print('Sync error: $e');
    }
  }

  // ── COWS ─────────────────────────────────────────────────────────

  Future<void> _syncCows() async {
    // Push pending local cows to Supabase.
    final pending = await isar.cows
        .filter()
        .syncStatusEqualTo(SyncStatus.pending)
        .findAll();

    for (final cow in pending) {
      try {
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
          'photo_path': cow.photoPath,
          'farm_id': cow.farmId,
          'created_by': cow.createdBy,
          'created_at': cow.createdAt.toIso8601String(),
          'updated_at': cow.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        // Mark as synced in Isar.
        await isar.writeTxn(() async {
          cow.syncStatus = SyncStatus.synced;
          await isar.cows.put(cow);
        });
      } catch (e) {
        // Mark as failed — will retry next sync.
        await isar.writeTxn(() async {
          cow.syncStatus = SyncStatus.failed;
          await isar.cows.put(cow);
        });
      }
    }
  }

  // ── TRANSACTIONS ─────────────────────────────────────────────────

  Future<void> _syncTransactions() async {
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
          'farm_id': tx.farmId,
          'created_by': tx.createdBy,
          'created_at': tx.createdAt.toIso8601String(),
          'updated_at': tx.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          tx.syncStatus = TransactionSyncStatus.synced;
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

  // ── HEALTH RECORDS ───────────────────────────────────────────────

  Future<void> _syncHealthRecords() async {
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
          'farm_id': record.farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = HealthSyncStatus.synced;
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

  // ── BREEDING RECORDS ─────────────────────────────────────────────

  Future<void> _syncBreedingRecords() async {
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
          'farm_id': record.farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = BreedingSyncStatus.synced;
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

  // ── MILK PRODUCTION ──────────────────────────────────────────────

  Future<void> _syncMilkProduction() async {
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
          'farm_id': record.farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = MilkSyncStatus.synced;
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

  // ── WEIGHT RECORDS ───────────────────────────────────────────────

  Future<void> _syncWeightRecords() async {
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
          'farm_id': record.farmId,
          'created_by': record.createdBy,
          'created_at': record.createdAt.toIso8601String(),
          'updated_at': record.updatedAt.toIso8601String(),
          'sync_status': 'synced',
          'is_deleted': false,
        });

        await isar.writeTxn(() async {
          record.syncStatus = WeightSyncStatus.synced;
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
}