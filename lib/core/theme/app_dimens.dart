import 'package:flutter/animation.dart';
import 'package:flutter/painting.dart';

/// Spacing scale (4 pt grid). Use these instead of literal paddings.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;

  /// Horizontal padding of every page.
  static const double page = 20;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: page);
}

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;

  static const BorderRadius small = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius medium = BorderRadius.all(Radius.circular(md));
  static const BorderRadius large = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius extraLarge = BorderRadius.all(Radius.circular(xl));
}

/// Animation timings. Short and decelerating, so the UI feels responsive.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 450);

  static const Curve emphasized = Curves.easeOutCubic;
}
