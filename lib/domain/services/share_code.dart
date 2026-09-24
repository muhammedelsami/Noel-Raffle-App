import 'dart:math';

/// Personal codes that let a participant fetch only their own result online.
///
/// Codes use an alphabet without look-alike characters (no 0/O, 1/I) and are
/// long enough that they cannot practically be guessed.
abstract final class ShareCode {
  static const String alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int length = 8;

  static final RegExp _valid = RegExp('^[$alphabet]{$length}\$');

  static String generate(Random random) {
    return String.fromCharCodes(
      List<int>.generate(
        length,
        (_) => alphabet.codeUnitAt(random.nextInt(alphabet.length)),
      ),
    );
  }

  /// Human-friendly form, e.g. `ABCD-EFGH`.
  static String format(String code) {
    if (code.length != length) return code;
    return '${code.substring(0, length ~/ 2)}-${code.substring(length ~/ 2)}';
  }

  /// Turns user input (any case, with spaces or dashes) into a stored code, or
  /// returns `null` when it cannot be a valid code.
  static String? normalize(String input) {
    final String code =
        input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    return _valid.hasMatch(code) ? code : null;
  }
}
