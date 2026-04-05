import 'dart:math';

import 'package:impariamo/03_contiamo/02_domain/domain.dart';

List<TimeTablePair> generateTablesForSession(int tablesCount, TimeTablesProgress progress) {
  final tables = getRarestOrMostDifficultTables(progress, tablesCount);
  return tables;

}

List<TimeTablePair> getRarestOrMostDifficultTables(TimeTablesProgress progress, int tablesCount) {
  final allPairs = <TimeTablePair>[];

  for (var tableNumber = 2; tableNumber <= 10; tableNumber++) {
    for (var multiplier = 2; multiplier <= 10; multiplier++) {
      final progressForPair = progress.firstWhere(
        (p) => p.pair.number == tableNumber && p.pair.multiplier == multiplier,
        orElse: () => Progress(pair: TimeTablePair(number: tableNumber, multiplier: multiplier, successRate: 0.0, frequency: 0), correct: 0, total: 0),
      );
      final successRate = progressForPair.total > 0 ? progressForPair.correct / progressForPair.total : 0.0;
      final frequency = progressForPair.total;
      allPairs.add(TimeTablePair(number: tableNumber, multiplier: multiplier, successRate: successRate, frequency: frequency));
    }
  }

  final sortedBySuccessRate = List<TimeTablePair>.from(allPairs)
    ..sort((a, b) {
      final successComparison = a.successRate.compareTo(b.successRate);
      if (successComparison != 0) {
        return successComparison;
      }

      return a.result.compareTo(b.result);
    });

  final sortedByFrequency = List<TimeTablePair>.from(allPairs)
    ..sort((a, b) {
      final frequencyComparison = a.frequency.compareTo(b.frequency);
      if (frequencyComparison != 0) {
        return frequencyComparison;
      }

      return a.result.compareTo(b.result);
    });

  final selectedTables = <TimeTablePair>[];
  final selectedKeys = <(int, int)>{};

  void addTable(TimeTablePair table) {
    final key = (table.number, table.multiplier);
    if (selectedKeys.add(key)) {
      selectedTables.add(table);
    }
  }

  final halfCount = tablesCount ~/ 2;

  for (var i = 0; i < halfCount && i < sortedByFrequency.length; i++) {
    addTable(sortedByFrequency[i]);
  }

  for (var i = 0; i < halfCount && selectedTables.length < tablesCount; i++) {
    addTable(sortedBySuccessRate[i]);
  }

  if (selectedTables.length < tablesCount) {
    for (final table in allPairs) {
      if (selectedTables.length == tablesCount) {
        break;
      }

      addTable(table);
    }
  }

  final result = selectedTables..shuffle(Random());
  return result;
}

