import 'package:flutter/material.dart';

// ignore: uri_does_not_exist
import 'product_image_stub.dart'
    if (dart.library.io) 'product_image_mobile.dart'
    if (dart.library.html) 'product_image_web.dart'
    if (dart.library.js_interop) 'product_image_web.dart';

class ProductImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) {
      return _buildPlaceholder("EMPTY URL");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return getPlatformProductImage(
          url: url,
          width: width ?? constraints.maxWidth,
          height: height ?? constraints.maxHeight,
          fit: fit,
        );
      },
    );
  }

  Widget _buildPlaceholder(String label) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.image_not_supported, color: Colors.grey),
            Text(
              label,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
