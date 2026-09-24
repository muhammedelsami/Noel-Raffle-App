import 'package:flutter/material.dart';

/// A decorative square artwork from the assets. Illustrations are precached
/// on the splash screen, so they appear without a pop-in.
class Illustration extends StatelessWidget {
  const Illustration(this.asset, {super.key, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      excludeFromSemantics: true,
    );
  }
}
