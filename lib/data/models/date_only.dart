/// Stores a calendar day without a time as `yyyy-MM-dd`, so it reads back as
/// the same day in any time zone.
abstract final class DateOnly {
  static String encode(DateTime day) => '${day.year.toString().padLeft(4, '0')}'
      '-${day.month.toString().padLeft(2, '0')}'
      '-${day.day.toString().padLeft(2, '0')}';

  /// The day in [value] as a local date, or `null` when it is not one.
  static DateTime? decode(Object? value) {
    if (value is! String) return null;
    final DateTime? parsed = DateTime.tryParse(value);
    return parsed == null
        ? null
        : DateTime(parsed.year, parsed.month, parsed.day);
  }
}
