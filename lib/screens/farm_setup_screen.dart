import 'package:flutter/material.dart';
import '../services/farm_service.dart';
import '../main.dart';

/// Shown after first login — lets the user create or join a farm.
class FarmSetupScreen extends StatefulWidget {
  // Callback fired when a farm is successfully created or joined.
  final VoidCallback? onFarmLinked;

  const FarmSetupScreen({super.key, this.onFarmLinked});

  @override
  State<FarmSetupScreen> createState() => _FarmSetupScreenState();
}

class _FarmSetupScreenState extends State<FarmSetupScreen> {
  final _createFormKey = GlobalKey<FormState>();
  final _joinFormKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _inviteCodeController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  // Tab: 0 = Create, 1 = Join
  int _tab = 0;

  @override
  void dispose() {
    _farmNameController.dispose();
    _locationController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _createFarm() async {
    if (!_createFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final farmName = _farmNameController.text.trim();
      final inviteCode = await FarmService().createFarm(
        farmName,
        _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      );

      if (mounted) {
        // Show success dialog with farm name and invite code.
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Farm Created! 🎉'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your invite code:',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Text(
                    inviteCode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 6,
                      color: Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Share this code with workers so they can join your farm.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continue to App'),
              ),
            ],
          ),
        );

        // Notify AuthGate that farm is now linked.
        if (mounted) widget.onFarmLinked?.call();
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _joinFarm() async {
    if (!_joinFormKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      await FarmService().joinFarm(_inviteCodeController.text.trim());
      if (mounted) widget.onFarmLinked?.call();
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.agriculture,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              const Text(
                'Set Up Your Farm',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Create a new farm or join an existing one',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Tab selector.
              SegmentedButton<int>(
                segments: const [
                  ButtonSegment(
                    value: 0,
                    label: Text('Create Farm'),
                    icon: Icon(Icons.add),
                  ),
                  ButtonSegment(
                    value: 1,
                    label: Text('Join Farm'),
                    icon: Icon(Icons.group_add),
                  ),
                ],
                selected: {_tab},
                onSelectionChanged: (set) => setState(() => _tab = set.first),
              ),
              const SizedBox(height: 24),

              // Error message.
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Create farm form.
              if (_tab == 0)
                Expanded(
                  child: Form(
                    key: _createFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _farmNameController,
                          decoration: const InputDecoration(
                            labelText: 'Farm Name *',
                            hintText: 'e.g. Ssali Family Farm',
                            prefixIcon: Icon(Icons.home_work_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a farm name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location (optional)',
                            hintText: 'e.g. Mbarara, Uganda',
                            prefixIcon: Icon(Icons.location_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _loading ? null : _createFarm,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Farm',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Join farm form.
              if (_tab == 1)
                Expanded(
                  child: Form(
                    key: _joinFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Ask your farm owner for the 6-character invite code.',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _inviteCodeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            labelText: 'Invite Code *',
                            hintText: 'e.g. ABC123',
                            prefixIcon: Icon(Icons.vpn_key_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the invite code';
                            }
                            if (value.trim().length != 6) {
                              return 'Invite code must be 6 characters';
                            }
                            return null;
                          },
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: _loading ? null : _joinFarm,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Join Farm',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
