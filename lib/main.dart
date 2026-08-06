import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/cow.dart';
import 'models/transaction.dart';
import 'models/health_record.dart';
import 'screens/cow_list_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/finance_screen.dart';
import 'screens/health_dashboard_screen.dart';
import 'models/breeding_record.dart';
import 'models/milk_production.dart';
import 'models/weight_record.dart';
import 'services/sync_service.dart';
import 'screens/login_screen.dart';
import 'screens/farm_setup_screen.dart';
import 'services/farm_service.dart';
import 'dart:async';
import 'services/permission_service.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase.
  await Supabase.initialize(
    url: SupabaseConfig.projectUrl,
    anonKey: SupabaseConfig.publishableKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: false, // Don't auto-refresh — we handle this manually
    ),
  );

  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open([
    CowSchema,
    FarmTransactionSchema,
    HealthRecordSchema,
    BreedingRecordSchema,
    MilkProductionSchema,
    WeightRecordSchema,
  ], directory: dir.path);

  // Start background sync after app initializes.
  SyncService().sync();

  runApp(const FarmApp());
}

class FarmApp extends StatelessWidget {
  const FarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      //      home: const MainNavigation(),
      home: const AuthGate(),
    );
  }
}

/// Bottom navigation shell — switches between Dashboard, Cows and Finance.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  Timer? _syncTimer;
  StreamSubscription? _connectivitySubscription;
  bool _canViewFinance = false;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
    _tryRefreshToken();

    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      SyncService().sync();
    });

    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) {
      final hasInternet = results.any((r) => r != ConnectivityResult.none);
      if (hasInternet) {
        SyncService().sync();
        _tryRefreshToken();
      } // Refresh token when internet returns
    });
  }

  /// Refreshes the Supabase auth token only when online.
  Future<void> _tryRefreshToken() async {
    try {
      final result = await Connectivity().checkConnectivity();
      final hasInternet = result.any((r) => r != ConnectivityResult.none);
      if (hasInternet) {
        await Supabase.instance.client.auth.refreshSession();
      }
    } catch (e) {
      // Silently ignore — user can still use app offline
      print('Token refresh skipped (offline): $e');
    }
  }

  Future<void> _loadPermissions() async {
    final canViewFinance = await PermissionService().canViewFinance;
    if (mounted) setState(() => _canViewFinance = canViewFinance);
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  List<Widget> get _screens => [
    const DashboardScreen(),
    const CowListScreen(),
    if (_canViewFinance) const FinanceScreen(),
    const HealthDashboardScreen(),
  ];

  List<NavigationDestination> get _destinations => [
    const NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    const NavigationDestination(
      icon: Icon(Icons.pets_outlined),
      selectedIcon: Icon(Icons.pets),
      label: 'My Cows',
    ),
    if (_canViewFinance)
      const NavigationDestination(
        icon: Icon(Icons.account_balance_wallet_outlined),
        selectedIcon: Icon(Icons.account_balance_wallet),
        label: 'Finance',
      ),
    const NavigationDestination(
      icon: Icon(Icons.health_and_safety_outlined),
      selectedIcon: Icon(Icons.health_and_safety),
      label: 'Health',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final safeIndex = _currentIndex.clamp(0, _screens.length - 1);

    return Scaffold(
      body: Column(
        children: [
          // Offline banner.
          StreamBuilder<List<ConnectivityResult>>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              final results = snapshot.data ?? [];
              final isOffline =
                  results.isNotEmpty &&
                  results.every((r) => r == ConnectivityResult.none);

              if (!isOffline) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                color: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 12,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.wifi_off, size: 14, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      'Offline — changes will sync when connected',
                      style: TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(child: _screens[safeIndex]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: _destinations,
      ),
    );
  }
}

/// Decides whether to show the login screen or the main app,
/// based on current Supabase auth state. Also listens for
/// sign-in/sign-out events to react automatically.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Tracks what screen to show.
  // null = still loading, true = main app, false = farm setup
  bool? _isLinkedToFarm;
  bool _isCheckingFarm = false;

  @override
  void initState() {
    super.initState();
    // Listen to auth changes immediately.
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        _isLinkedToFarm = null;
        _checkFarm();
      }
      if (data.event == AuthChangeEvent.signedOut) {
        if (mounted) setState(() => _isLinkedToFarm = null);
      }
    });

    // Check on startup.
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      _checkFarm();
    }
  }

  Future<void> _checkFarm() async {
    if (_isCheckingFarm) return;
    _isCheckingFarm = true;

    // DEBUG — remove after fixing
    final prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    print('SharedPreferences keys: $allKeys');
    print('farm_id value: ${prefs.getString('farm_id')}');

    try {
      // First check local storage — works 100% offline.
      final linked = await FarmService().isLinkedToFarm;

      if (linked) {
        if (mounted) setState(() => _isLinkedToFarm = true);
        return;
      }

      // Not linked locally — try Supabase only if online.
      final hasInternet = await _hasInternet();
      if (hasInternet) {
        await FarmService().restoreFarmFromSupabase();
        final linkedAfterRestore = await FarmService().isLinkedToFarm;
        if (mounted) {
          setState(() => _isLinkedToFarm = linkedAfterRestore);
        }
      } else {
        // Offline and no local farm data.
        if (mounted) setState(() => _isLinkedToFarm = false);
      }
    } catch (e) {
      // On any error, check local data one more time.
      final linked = await FarmService().isLinkedToFarm;
      if (mounted) setState(() => _isLinkedToFarm = linked);
    } finally {
      _isCheckingFarm = false;
    }
  }

  /// Check internet connectivity.
  Future<bool> _hasInternet() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final event = snapshot.data?.event;

        // Ignore token refresh failures — keep user logged in.
        if (event == AuthChangeEvent.tokenRefreshed) {
          // Token refreshed successfully — good.
        }

        // Only sign out if explicitly triggered by user.
        if (event == AuthChangeEvent.signedOut) {
          // Check if this was intentional (user tapped sign out)
          // or caused by a failed token refresh.
          final session = Supabase.instance.client.auth.currentSession;
          if (session == null && _isLinkedToFarm == null) {
            // Genuinely signed out.
            return const LoginScreen();
          }
          // Otherwise ignore — keep showing current screen.
        }

        // User just signed in — trigger farm check.
        if (event == AuthChangeEvent.signedIn) {
          if (_isLinkedToFarm == null && !_isCheckingFarm) {
            _checkFarm();
          }
        }

        // Trust local session — works offline.
        final session = Supabase.instance.client.auth.currentSession;

        // Check local storage for session even if Supabase
        // session object is null (can happen offline).
        if (session == null) {
          // Double-check SharedPreferences for farm data.
          // If we have farm data, user was previously logged in.
          if (_isLinkedToFarm == true) {
            return const MainNavigation();
          }
          _isLinkedToFarm = null;
          return const LoginScreen();
        }

        // Has a session (online or offline cached) -
        // check farm status.
        if (_isLinkedToFarm == null) {
          if (!_isCheckingFarm) _checkFarm();
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading your farm...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Linked to a farm — show main app.
        if (_isLinkedToFarm == true) return const MainNavigation();
        
        return FarmSetupScreen(
          onFarmLinked: () {
            setState(() => _isLinkedToFarm = true);
          },
        );
      },
    );
  }
}
