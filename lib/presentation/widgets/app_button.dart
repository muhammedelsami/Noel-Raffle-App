import 'package:flutter/material.dart';

/// Visual weight of an [AppButton], from most to least prominent.
enum AppButtonVariant { primary, tonal, outlined, text }

/// The app's button. Styling comes from the theme; [variant] picks the
/// emphasis, and [loading] swaps the icon for a spinner and blocks taps.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.expand = true,
  });

  const AppButton.tonal({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  }) : variant = AppButtonVariant.tonal;

  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.expand = true,
  }) : variant = AppButtonVariant.outlined;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool loading;

  /// Fills the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = loading ? null : this.onPressed;
    final Widget label = Text(this.label, textAlign: TextAlign.center);
    final Widget? leading = loading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2.4),
          )
        : icon == null
            ? null
            : Icon(icon);

    final Widget button = switch (variant) {
      AppButtonVariant.primary => leading == null
          ? FilledButton(onPressed: onPressed, child: label)
          : FilledButton.icon(
              onPressed: onPressed,
              icon: leading,
              label: label,
            ),
      AppButtonVariant.tonal => leading == null
          ? FilledButton.tonal(onPressed: onPressed, child: label)
          : FilledButton.tonalIcon(
              onPressed: onPressed,
              icon: leading,
              label: label,
            ),
      AppButtonVariant.outlined => leading == null
          ? OutlinedButton(onPressed: onPressed, child: label)
          : OutlinedButton.icon(
              onPressed: onPressed,
              icon: leading,
              label: label,
            ),
      AppButtonVariant.text => leading == null
          ? TextButton(onPressed: onPressed, child: label)
          : TextButton.icon(
              onPressed: onPressed,
              icon: leading,
              label: label,
            ),
    };
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
