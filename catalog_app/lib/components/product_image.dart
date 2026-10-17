import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.fallback,
  });

  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          fallback ??
          SizedBox(
            width: width,
            height: height,
            child: const Center(child: Icon(Icons.broken_image)),
          ),
    );
  }
}
