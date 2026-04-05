import 'package:flutter_test/flutter_test.dart';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';

void main() {
  // These tests stay at the domain layer and verify the small pieces of logic
  // that other features depend on, without involving widgets or bloc state.
  group('TimeTablePair', () {
    // The computed multiplication result is the core behavior used by the game UI.
    test('computes the multiplication result', () {
      const pair = TimeTablePair(number: 4, multiplier: 6);
      expect(pair.result, 24);
    });

    // Equatable behavior matters because the session logic stores and compares pairs in sets.
    test('supports value equality', () {
      const first = TimeTablePair(number: 4, multiplier: 6);
      const second = TimeTablePair(number: 4, multiplier: 6);
      const different = TimeTablePair(number: 4, multiplier: 7);

      expect(first, equals(second));
      expect(first, isNot(equals(different)));
    });
  });

  group('Progress', () {
    // Progress is also compared by value when building session history.
    test('supports value equality', () {
      const pair = TimeTablePair(number: 3, multiplier: 7);
      const first = Progress(pair: pair, correct: 2, total: 5);
      const second = Progress(pair: pair, correct: 2, total: 5);
      const different = Progress(pair: pair, correct: 3, total: 5);

      expect(first, equals(second));
      expect(first, isNot(equals(different)));
    });
  });
}