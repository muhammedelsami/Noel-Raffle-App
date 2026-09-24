import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';
import 'brand_colors.dart';

/// Material 3 themes for light and dark mode.
///
/// Both [ThemeData]s are built once and reused, so switching screens or
/// locales never rebuilds them. All component styling lives here; widgets
/// read it from the theme instead of repeating inline styles.
abstract final class AppTheme {
  static final ThemeData light = _build(AppColors.light, BrandColors.light);
  static final ThemeData dark = _build(AppColors.dark, BrandColors.dark);

  /// Transparent, edge-to-edge system bars whose icons contrast with a
  /// background of the given brightness.
  static SystemUiOverlayStyle overlayStyle({required bool darkBackground}) {
    final Brightness icons =
        darkBackground ? Brightness.light : Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: icons,
      // iOS names the status bar after its background, not its icons.
      statusBarBrightness: darkBackground ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: icons,
      systemNavigationBarContrastEnforced: false,
    );
  }

  static ThemeData _build(ColorScheme scheme, BrandColors brand) {
    final TextTheme text = AppTypography.textTheme(scheme);
    final bool isDark = scheme.brightness == Brightness.dark;

    // Raised surfaces are white in light mode and one step lighter than the
    // background in dark mode.
    final Color raised =
        isDark ? scheme.surfaceContainer : scheme.surfaceContainerLowest;
    final Color overlay =
        isDark ? scheme.surfaceContainerHigh : scheme.surfaceContainerLowest;

    const OutlinedBorder buttonShape =
        RoundedRectangleBorder(borderRadius: AppRadius.medium);
    const Size buttonMinSize = Size(64, 52);
    const EdgeInsets buttonPadding =
        EdgeInsets.symmetric(horizontal: AppSpacing.xl);

    OutlineInputBorder fieldBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: AppRadius.medium,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: AppFonts.body,
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[brand],
      appBarTheme: AppBarTheme(
        // Tints the bar once content scrolls underneath it.
        backgroundColor: WidgetStateColor.resolveWith(
          (Set<WidgetState> states) =>
              states.contains(WidgetState.scrolledUnder)
                  ? scheme.surfaceContainer
                  : scheme.surface,
        ),
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
        systemOverlayStyle: overlayStyle(darkBackground: isDark),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          iconSize: 20,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: buttonShape,
          textStyle: text.labelLarge,
          iconSize: 20,
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          shape: buttonShape,
          textStyle: text.labelLarge,
          iconSize: 20,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          textStyle: text.labelMedium,
          side: BorderSide(color: scheme.outlineVariant),
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: raised,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        errorMaxLines: 2,
        border: fieldBorder(scheme.outlineVariant),
        enabledBorder: fieldBorder(scheme.outlineVariant),
        focusedBorder: fieldBorder(scheme.primary, 2),
        errorBorder: fieldBorder(scheme.error),
        focusedErrorBorder: fieldBorder(scheme.error, 2),
      ),
      cardTheme: CardThemeData(
        color: raised,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.large,
          side: BorderSide(color: brand.cardBorder),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsetsDirectional.only(
          start: AppSpacing.lg,
          end: AppSpacing.sm,
        ),
        minVerticalPadding: AppSpacing.md,
        horizontalTitleGap: AppSpacing.md,
        iconColor: scheme.onSurfaceVariant,
        titleTextStyle: text.titleMedium,
        subtitleTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.large),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: overlay,
        surfaceTintColor: Colors.transparent,
        insetPadding: AppConstants.dialogInset,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.extraLarge),
        titleTextStyle: text.headlineSmall,
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
        actionsPadding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          0,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: overlay,
        modalBackgroundColor: overlay,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: scheme.outline,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        actionTextColor: scheme.inversePrimary,
        contentTextStyle:
            text.bodyMedium?.copyWith(color: scheme.onInverseSurface),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: text.bodySmall?.copyWith(color: scheme.onInverseSurface),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: AppRadius.small,
        ),
      ),
    );
  }
}
