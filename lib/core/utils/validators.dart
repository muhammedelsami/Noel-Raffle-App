/// Pure validation helpers, free of UI concerns so they can be unit-tested.
abstract final class Validators {
  static final RegExp _emailRegExp =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  static bool isValidEmail(String value) => _emailRegExp.hasMatch(value.trim());

  /// Empty input is allowed; anything else must be a valid email.
  static bool isValidOptionalEmail(String value) =>
      value.trim().isEmpty || isValidEmail(value);

  static bool isNotBlank(String value) => value.trim().isNotEmpty;
}
