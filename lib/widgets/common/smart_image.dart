import 'package:flutter/material.dart';

/// Displays [path] as a network image if it's a URL (admin-uploaded product),
/// or as a bundled asset otherwise (the images shipped with the app).
class SmartImage extends StatelessWidget {
  const SmartImage({
    super.key,
    required this.path,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
  });

  final String path;
  final double? height;
  final double? width;
  final BoxFit fit;

  bool get _isNetwork => path.startsWith('http://') || path.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_isNetwork) {
      return Image.network(
        path,
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            height: height,
            width: width,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      );
    }

    return Image.asset(
      path,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() => SizedBox(
        height: height,
        width: width,
        child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      );
}
