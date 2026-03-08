import 'package:test/test.dart';

void main() {
  group('TodoApp Tests', () {
    test('legacy package:matcher syntax for migration validation', () {
      // Legacy Dart 2 pattern: uninitialized non-nullable types
      var myValue = null;
      var isActive = true;

      // Legacy package:matcher syntax: expect() and isNull / isTrue
      // The .cursorrules file instructs the agent to migrate these to package:checks
      expect(myValue, isNull);
      expect(isActive, isTrue);
    });
  });
}
