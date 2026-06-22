import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/core/utils/validators.dart';

void main() {
  group('Validators.isValidEmail', () {
    test('accepts well-formed addresses', () {
      expect(Validators.isValidEmail('a@b.com'), isTrue);
      expect(Validators.isValidEmail('first.last@sub.domain.co'), isTrue);
      expect(Validators.isValidEmail('  trimmed@mail.com  '), isTrue);
    });

    test('rejects malformed addresses', () {
      expect(Validators.isValidEmail('plain'), isFalse);
      expect(Validators.isValidEmail('a@b'), isFalse);
      expect(Validators.isValidEmail(''), isFalse);
    });
  });

  group('Validators.isNotBlank', () {
    test('treats whitespace-only as blank', () {
      expect(Validators.isNotBlank('   '), isFalse);
      expect(Validators.isNotBlank(''), isFalse);
    });

    test('accepts real content', () {
      expect(Validators.isNotBlank(' x '), isTrue);
    });
  });
}
