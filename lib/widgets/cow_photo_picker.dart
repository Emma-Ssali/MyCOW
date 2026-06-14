import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// A reusable widget that displays a cow's photo (or a placeholder),
/// and lets the user pick a new one from the camera or gallery.
///
/// The selected image is copied into the app's local documents
/// directory, and the resulting file path is returned via [onPhotoChanged].
class CowPhotoPicker extends StatefulWidget {
  final String? initialPhotoPath;
  final ValueChanged<String?> onPhotoChanged;

  const CowPhotoPicker({
    super.key,
    required this.initialPhotoPath,
    required this.onPhotoChanged,
  });

  @override
  State<CowPhotoPicker> createState() => _CowPhotoPickerState();
}

class _CowPhotoPickerState extends State<CowPhotoPicker> {
  String? _photoPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _photoPath = widget.initialPhotoPath;
  }

  /// Opens the camera or gallery, then copies the picked image into
  /// the app's permanent local storage directory.
  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024, // Resize to keep file sizes reasonable.
      imageQuality: 80,
    );

    if (picked == null) return;

    // Copy the picked file into the app's documents directory so it
    // persists even if the original (e.g. camera temp file) is cleared.
    final appDir = await getApplicationDocumentsDirectory();
    final cowPhotosDir = Directory('${appDir.path}/cow_photos');
    if (!await cowPhotosDir.exists()) {
      await cowPhotosDir.create(recursive: true);
    }

    final extension = path.extension(picked.path);
    final fileName = 'cow_${DateTime.now().millisecondsSinceEpoch}$extension';
    final savedPath = '${cowPhotosDir.path}/$fileName';

    await File(picked.path).copy(savedPath);

    setState(() => _photoPath = savedPath);
    widget.onPhotoChanged(savedPath);
  }

  /// Removes the current photo (sets it to null).
  void _removePhoto() {
    setState(() => _photoPath = null);
    widget.onPhotoChanged(null);
  }

  /// Shows a bottom sheet letting the user choose camera, gallery, or remove.
  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_photoPath != null)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Photo', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showPickerOptions,
        child: Stack(
          children: [
            // The photo itself, or a placeholder icon if none is set.
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade200,
                image: _photoPath != null
                    ? DecorationImage(
                        image: FileImage(File(_photoPath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _photoPath == null
                  ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                  : null,
            ),

            // Small edit badge in the bottom-right corner.
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.edit, size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}