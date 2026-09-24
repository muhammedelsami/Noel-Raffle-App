import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:noel_raffle/domain/services/share_code.dart';

void main() {
  test('generates codes from the unambiguous alphabet', () {
    final Random random = Random(1);
    for (int i = 0; i < 100; i++) {
      final String code = ShareCode.generate(random);
      expect(code, hasLength(ShareCode.length));
      expect(ShareCode.normalize(code), code);
      expect(code, isNot(matches(RegExp('[01IO]'))));
    }
  });

  test('formats codes in two halves', () {
    expect(ShareCode.format('ABCDEFGH'), 'ABCD-EFGH');
  });

  test('normalizes user input', () {
    expect(ShareCode.normalize(' abcd-efgh '), 'ABCDEFGH');
    expect(ShareCode.normalize('ABCD EFGH'), 'ABCDEFGH');
  });

  test('rejects impossible codes', () {
    expect(ShareCode.normalize('ABC'), isNull);
    expect(ShareCode.normalize('ABCD-EFG0'), isNull, reason: '0 is excluded');
    expect(ShareCode.normalize('ABCDEFGHJ'), isNull);
  });
}
