import 'package:flutter_test/flutter_test.dart';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';
import 'package:impariamo/03_contiamo/utilities/session_utilities.dart';

void main() {
  TimeTablesProgress buildProgressFixture() {
    final progress = <Progress>[];

    for (var number = 2; number <= 10; number++) {
      for (var multiplier = 2; multiplier <= 10; multiplier++) {
        progress.add(
          Progress(
            pair: TimeTablePair(number: number, multiplier: multiplier),
            correct: 10,
            total: 10,
          ),
        );
      }
    }

    void setProgress(int number, int multiplier, int correct, int total) {
      final index = progress.indexWhere(
        (item) => item.pair.number == number && item.pair.multiplier == multiplier,
      );
      progress[index] = Progress(
        pair: TimeTablePair(number: number, multiplier: multiplier),
        correct: correct,
        total: total,
      );
    }

    // Rarest tables: very low frequency, but still solved correctly.
    setProgress(2, 2, 1, 1);
    setProgress(2, 3, 1, 1);
    setProgress(2, 4, 1, 1);
    setProgress(2, 5, 1, 1);
    setProgress(2, 6, 1, 1);

    // Most difficult tables: higher frequency, but poor success rate.
    setProgress(3, 2, 0, 10);
    setProgress(3, 3, 0, 10);
    setProgress(3, 4, 0, 10);
    setProgress(3, 5, 0, 10);
    setProgress(3, 6, 0, 10);

    // One overlap: rare and difficult at the same time.
    setProgress(4, 2, 0, 1);

    return progress;
  }

  // The selector should pull from the rarest tables first and the most difficult
  // tables second, while avoiding duplicates even when the two groups overlap.
  test('getRarestOrMostDifficultTables returns at least five rare and five difficult tables for a session length of 10', () {
    final progress = buildProgressFixture();

    final tables = getRarestOrMostDifficultTables(progress, 10);
    final tableKeys = tables.map((pair) => (pair.number, pair.multiplier)).toSet();
    final rarestKeys = <(int, int)>{(2, 2), (2, 3), (2, 4), (2, 5), (2, 6)};
    final mostDifficultKeys = <(int, int)>{(4, 2), (3, 2), (3, 3), (3, 4), (3, 5)};

    expect(tables, hasLength(10));
    expect(tableKeys.length, equals(tables.length));
    expect(tableKeys, hasLength(10));
    expect(tableKeys.intersection(rarestKeys), hasLength(5));
    expect(tableKeys.intersection(mostDifficultKeys), hasLength(5));
    expect(tableKeys.contains((2, 2)), isTrue);
    expect(tableKeys.contains((3, 4)), isTrue);
  });

  // A full session should cover every multiplication pair exactly once.
  test('generateTablesForSession returns 81 unique pairs for a full session', () {
    final tables = generateTablesForSession(81, buildProgressFixture());
    final tableKeys = tables.map((pair) => (pair.number, pair.multiplier)).toSet();

    expect(tables, hasLength(81));
    expect(tableKeys.length, equals(tables.length));
    expect(tableKeys, hasLength(81));
  });
}