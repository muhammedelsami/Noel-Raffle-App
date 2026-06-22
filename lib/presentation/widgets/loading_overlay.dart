import 'package:flutter/material.dart';

/// Dims the screen and shows a spinner over [child] while [isLoading] is true.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading)
          const ModalBarrier(dismissible: false, color: Colors.black54),
        if (isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
