import 'package:connectivity_plus/connectivity_plus.dart';
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

    _syncTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      SyncService().sync();
    });

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((results) {
      final hasInternet =
          results.any((r) => r != ConnectivityResult.none);
      if (hasInternet) SyncService().sync();
    });
  }

  Future<void> _loadPermissions() async {
    final canViewFinance =
        await PermissionService().canViewFinance;
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
    // Clamp index in case Finance tab is hidden.
    final safeIndex =
        _currentIndex.clamp(0, _screens.length - 1);

    return Scaffold(
      body: _screens[safeIndex],
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
  bool? _isLinkedToFarm;

  @override
  void initState() {
    super.initState();
    _checkFarm();
  }

  Future<void> _checkFarm() async {
    // Try to restore farm data from Supabase if missing locally.
    await FarmService().restoreFarmFromSupabase();
    final linked = await FarmService().isLinkedToFarm;
    if (mounted) setState(() => _isLinkedToFarm = linked);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          // Not logged in — reset farm cache and show login.
          _isLinkedToFarm = null;
          return const LoginScreen();
        }

        // Logged in but still checking farm status.
        if (_isLinkedToFarm == null) {
          _checkFarm();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Logged in and farm check complete.
        if (_isLinkedToFarm == true) {
          return const MainNavigation();
        }

        return const FarmSetupScreen();
      },
    );
  }
}
