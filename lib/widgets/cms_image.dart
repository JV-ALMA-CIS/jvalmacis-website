import 'package:flutter/material.dart';

/// Renders a CMS-supplied image source as either a network image (Firebase
/// Storage download URL) or a bundled asset — CMS content may reference
/// either, since seeded defaults point at the original `assets/` paths
/// while admin-uploaded replacements are Storage URLs.
class CmsImage extends StatelessWidget {
  const CmsImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.errorBuilder,
  });

  final String source;
  final BoxFit fit;

  /// Which part of the image stays in frame when [fit] crops it.
  final Alignment alignment;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (source.isEmpty) {
      return errorBuilder?.call(context, StateError('empty image source'), null) ??
          const SizedBox.shrink();
    }
    if (source.startsWith('http://') || source.startsWith('https://')) {
      return Image.network(source, fit: fit, alignment: alignment, errorBuilder: errorBuilder);
    }
    return Image.asset(source, fit: fit, alignment: alignment, errorBuilder: errorBuilder);
  }
}
