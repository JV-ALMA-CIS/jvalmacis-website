import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../design/palette.dart';
import '../../design/tokens.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/cms_image.dart';

/// Picks an image (web-safe byte read via `file_picker`), uploads it to
/// Firebase Storage under a caller-supplied path, and reports the resulting
/// download URL. Shows the current image (asset or network) as a preview.
class ImageUploadField extends StatefulWidget {
  const ImageUploadField({
    super.key,
    required this.storagePathBuilder,
    required this.onUploaded,
    this.currentImageUrl,
    this.label = 'Image',
  });

  final String Function(String filename) storagePathBuilder;
  final ValueChanged<String> onUploaded;
  final String? currentImageUrl;
  final String label;

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  bool _uploading = false;
  double? _progress;
  String? _error;

  Future<void> _pickAndUpload() async {
    setState(() => _error = null);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) {
      setState(() => _error = 'Could not read the selected file.');
      return;
    }

    setState(() {
      _uploading = true;
      _progress = null;
    });

    try {
      final path = widget.storagePathBuilder(file.name);
      final ref = FirebaseStorage.instance.ref(path);
      final task = ref.putData(
        bytes,
        SettableMetadata(contentType: _contentTypeFor(file.extension)),
      );
      task.snapshotEvents.listen((snapshot) {
        if (!mounted || snapshot.totalBytes <= 0) return;
        setState(() => _progress = snapshot.bytesTransferred / snapshot.totalBytes);
      });
      await task;
      final url = await ref.getDownloadURL();
      widget.onUploaded(url);
    } catch (e) {
      setState(() => _error = 'Upload failed: $e');
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  String? _contentTypeFor(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.currentImageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: Space.xs),
        if (current != null && current.isNotEmpty)
          ClipRRect(
            borderRadius: Radii.card,
            child: SizedBox(
              height: 120,
              width: double.infinity,
              child: CmsImage(
                source: current,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Palette.n100,
                  alignment: Alignment.center,
                  child: const Text('Image failed to load'),
                ),
              ),
            ),
          ),
        const SizedBox(height: Space.sm),
        Row(
          children: [
            SecondaryButton(
              text: _uploading ? 'Uploading...' : 'Upload image',
              onPressed: _uploading ? null : _pickAndUpload,
            ),
            if (_uploading) ...[
              const SizedBox(width: Space.md),
              SizedBox(
                width: 120,
                child: LinearProgressIndicator(value: _progress),
              ),
            ],
          ],
        ),
        if (_error != null) ...[
          const SizedBox(height: Space.xs),
          Text(_error!, style: const TextStyle(color: Palette.danger, fontSize: 12)),
        ],
      ],
    );
  }
}
