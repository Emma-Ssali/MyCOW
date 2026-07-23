import 'dart:io';
import 'package:flutter/material.dart';

/// Displays a cow's photo — handles both local file paths
/// and remote Supabase Storage URLs.
class CowAvatar extends StatelessWidget {
  final String? photoPath;
  final double radius;
  final Color? backgroundColor;
  final Widget? fallback;

  const CowAvatar({
    super.key,
    required this.photoPath,
    this.radius = 24,
    this.backgroundColor,
    this.fallback,
  });

  bool get _isUrl =>
      photoPath != null &&
      (photoPath!.startsWith('http://') ||
          photoPath!.startsWith('https://'));

  bool get _isLocalFile =>
      photoPath != null && !_isUrl;

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (_isUrl) {
      imageProvider = NetworkImage(photoPath!);
    } else if (_isLocalFile) {
      final file = File(photoPath!);
      if (file.existsSync()) {
        imageProvider = FileImage(file);
      }
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor:
          backgroundColor ?? Colors.grey.shade200,
      backgroundImage: imageProvider,
      child: imageProvider == null ? fallback : null,
    );
  }
}