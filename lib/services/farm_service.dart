import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages farm creation, joining, and local farm ID storage.
class FarmService {
  static final FarmService _instance = FarmService._internal();
  factory FarmService() => _instance;
  FarmService._internal();

  final _supabase = Supabase.instance.client;
  static const _farmIdKey = 'farm_id';
  static const _farmNameKey = 'farm_name';
  static const _userRoleKey = 'user_role';
  static const _inviteCodeKey = 'invite_code';

  /// Returns the locally stored farm ID, or null if not joined yet.
  Future<String?> get localFarmId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_farmIdKey);
  }

  /// Returns the locally stored farm name.
  Future<String?> get localFarmName async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_farmNameKey);
  }

  Future<String?> get localInviteCode async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_inviteCodeKey);
}

  /// Returns the locally stored user role.
  Future<String> get localUserRole async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey) ?? 'owner';
  }

  /// Saves farm details locally after creating or joining.
 Future<void> _saveFarmLocally(
    String farmId, String farmName, String role, {String? inviteCode}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_farmIdKey, farmId);
  await prefs.setString(_farmNameKey, farmName);
  await prefs.setString(_userRoleKey, role);
  if (inviteCode != null) {
    await prefs.setString(_inviteCodeKey, inviteCode);
  }
}

  /// Clears local farm data on sign out.
  Future<void> clearLocalFarm() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_farmIdKey);
    await prefs.remove(_farmNameKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_inviteCodeKey);
  }

  /// Generates a random 6-character invite code.
  String _generateInviteCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (i) => chars[(random + i * 7) % chars.length])
        .join();
  }

  /// Creates a new farm and makes the current user the owner.
  Future<String> createFarm(String farmName, String? location) async {
    final user = _supabase.auth.currentUser!;
    final inviteCode = _generateInviteCode();

    // Insert farm.
    final farm = await _supabase.from('farms').insert({
      'name': farmName,
      'location': location,
      'owner_id': user.id,
      'invite_code': inviteCode,
    }).select().single();

    final farmId = farm['id'] as String;

    // Add owner as a member.
    await _supabase.from('farm_members').insert({
      'farm_id': farmId,
      'user_id': user.id,
      'user_name': user.userMetadata?['full_name'],
      'user_email': user.email,
      'role': 'owner',
    });

    await _saveFarmLocally(farmId, farmName, 'owner', inviteCode: inviteCode);
    return inviteCode;
  }

  /// Joins an existing farm using an invite code.
  Future<void> joinFarm(String inviteCode) async {
    final user = _supabase.auth.currentUser!;

    // Find the farm by invite code.
    final farms = await _supabase
        .from('farms')
        .select()
        .eq('invite_code', inviteCode.toUpperCase().trim());

    if (farms.isEmpty) {
      throw Exception('Invalid invite code. Please check and try again.');
    }

    final farm = farms.first;
    final farmId = farm['id'] as String;
    final farmName = farm['name'] as String;

    // Check if already a member.
    final existing = await _supabase
        .from('farm_members')
        .select()
        .eq('farm_id', farmId)
        .eq('user_id', user.id);

    if (existing.isNotEmpty) {
      // Already a member — just save locally.
      await _saveFarmLocally(farmId, farmName, existing.first['role']);
      return;
    }

    // Add as worker.
    await _supabase.from('farm_members').insert({
      'farm_id': farmId,
      'user_id': user.id,
      'user_name': user.userMetadata?['full_name'],
      'user_email': user.email,
      'role': 'worker',
    });

    await _saveFarmLocally(farmId, farmName, 'worker');
  }

  /// Checks if the current user is already linked to a farm.
  Future<bool> get isLinkedToFarm async {
    final farmId = await localFarmId;
    return farmId != null;
  }
}