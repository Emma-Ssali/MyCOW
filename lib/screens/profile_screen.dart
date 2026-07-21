import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/farm_service.dart';
import 'login_screen.dart';

/// Full profile screen — shows user info, farm details,
/// invite code, and sign out button.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _farmName;
  String? _inviteCode;
  String? _userRole;
  String? _userName;
  String? _userEmail;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() => _loading = true);

    // Restore farm from Supabase if missing locally.
    await FarmService().restoreFarmFromSupabase();

    // Load farm info from local storage.
    final farmName = await FarmService().localFarmName;
    final inviteCode = await FarmService().localInviteCode;
    final userRole = await FarmService().localUserRole;

    // Refresh user session to get latest metadata.
    try {
      await Supabase.instance.client.auth.refreshSession();
    } catch (_) {}

    final user = Supabase.instance.client.auth.currentUser;
    final userName = user?.userMetadata?['full_name'] ??
        user?.email?.split('@').first ??
        'Unknown';
    final userEmail = user?.email ?? 'Unknown';

    setState(() {
      _farmName = farmName;
      _inviteCode = inviteCode;
      _userRole = userRole;
      _userName = userName;
      _userEmail = userEmail;
      _loading = false;
    });
  }

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await FarmService().clearLocalFarm();
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfileData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── User info card ──
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar circle with first letter of name.
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            child: Text(
                              (_userName ?? 'U')[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _userName ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _userEmail ?? '',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey),
                                ),
                                const SizedBox(height: 6),
                                // Role badge.
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _userRole == 'owner'
                                        ? Colors.green
                                            .withValues(alpha: 0.15)
                                        : Colors.blue
                                            .withValues(alpha: 0.15),
                                    borderRadius:
                                        BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    _userRole == 'owner'
                                        ? 'Farm Owner'
                                        : 'Farm Worker',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _userRole == 'owner'
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Farm info card ──
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.agriculture,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary),
                              const SizedBox(width: 8),
                              const Text(
                                'Farm Details',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const Divider(height: 20),

                          // Farm name.
                          _infoRow(
                            icon: Icons.home_work_outlined,
                            label: 'Farm Name',
                            value: _farmName ?? 'Not set',
                          ),
                          const SizedBox(height: 12),

                          // Invite code — only for owners.
                          if (_userRole == 'owner' &&
                              _inviteCode != null) ...[
                            const Text(
                              'Invite Code',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.green
                                    .withValues(alpha: 0.08),
                                borderRadius:
                                    BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.green.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _inviteCode!,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 6,
                                      color: Colors.green,
                                    ),
                                  ),
                                  // Copy button.
                                  IconButton(
                                    icon: const Icon(Icons.copy,
                                        color: Colors.green),
                                    tooltip: 'Copy invite code',
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(
                                          text: _inviteCode!));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Invite code copied!'),
                                          duration:
                                              Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Share this code with workers so they can join your farm.',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],

                          // Workers just see their farm name, no invite code.
                          if (_userRole != 'owner') ...[
                            _infoRow(
                              icon: Icons.badge_outlined,
                              label: 'Your Role',
                              value: 'Worker',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Sign out button ──
                  OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                          color: Colors.red, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.red),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// A label + value row for the farm details section.
  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey)),
            Text(value,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}