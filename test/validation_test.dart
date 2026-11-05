import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_app/validation.dart';

void main() {
  test('valid email is accepted', () {
    expect(validateEmail('student@example.com'), isNull);
  });

  test('invalid email is rejected', () {
    expect(validateEmail('not-an-email'), isNotNull);
  });

  test('blank email is rejected', () {
    expect(validateEmail('  '), isNotNull);
  });

  test('short password is rejected', () {
    expect(validatePassword('123'), isNotNull);
  });

  test('six-character password is accepted', () {
    expect(validatePassword('abc123'), isNull);
  });
}
