import 'package:flutter/material.dart';
import '../services/permission_service.dart';

/// Wraps a widget and only shows it if the user
/// has the required permission.
/// Shows nothing (or a disabled version) if not permitted.
class PermissionGuard extends StatefulWidget {
  final Future<bool> permission;
  final Widget child;
  final Widget? fallback;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    this.fallback,
  });

  @override
  State<PermissionGuard> createState() => _PermissionGuardState();
}

class _PermissionGuardState extends State<PermissionGuard> {
  bool? _hasPermission;

  @override
  void initState() {
    super.initState();
    widget.permission.then((value) {
      if (mounted) setState(() => _hasPermission = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasPermission == null) return const SizedBox.shrink();
    if (_hasPermission == true) return widget.child;
    return widget.fallback ?? const SizedBox.shrink();
  }
}