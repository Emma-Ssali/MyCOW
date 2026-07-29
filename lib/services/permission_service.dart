import 'farm_service.dart';

/// Defines what each role can do in the app.
class PermissionService {
  static final PermissionService _instance =
      PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  String? _cachedRole;

  /// Load and cache the user's role.
  Future<String> get _role async {
    _cachedRole ??= await FarmService().localUserRole;
    return _cachedRole ?? 'viewer';
  }

  /// Call this on sign out to clear cached role.
  void clearCache() => _cachedRole = null;

  // ── Permission checks ─────────────────────────────────────────

  /// Can add, edit or delete cows.
  Future<bool> get canManageCows async {
    final role = await _role;
    return role == 'owner' || role == 'manager' || role == 'worker';
  }

  /// Can delete cows.
  Future<bool> get canDeleteCows async {
    final role = await _role;
    return role == 'owner' || role == 'manager';
  }

  /// Can add/edit/delete financial transactions.
  Future<bool> get canManageFinance async {
    final role = await _role;
    return role == 'owner' || role == 'manager';
  }

  /// Can view financial data (Finance tab).
  Future<bool> get canViewFinance async {
    final role = await _role;
    return role == 'owner' || role == 'manager';
  }

  /// Can add operational records
  /// (health, breeding, milk, weight).
  Future<bool> get canAddOperationalRecords async {
    final role = await _role;
    return role == 'owner' || role == 'manager' || role == 'worker';
  }

  /// Can delete any record.
  Future<bool> get canDelete async {
    final role = await _role;
    return role == 'owner' || role == 'manager';
  }

  /// Can access farm settings and invite code.
  Future<bool> get canViewInviteCode async {
    final role = await _role;
    return role == 'owner';
  }
}