import 'dart:math';

import 'package:impariamo/03_contiamo/02_domain/domain.dart';

List<TimeTablePair> generateTablesForSession(int tablesCount, TimeTablesProgress progress) {
  final tables = getRarestOrMostDifficultTables(progress, tablesCount);
  return tables;

}

List<TimeTablePair> getRarestOrMostDifficultTables(TimeTablesProgress progress, int tablesCount) {
  // This function will analyze the progress data and return a list of tables that are either the rarest (least practiced) or the most difficult (lowest success rate).

  // all possible pairs of times tables pairs with numbers between 2 and 10 and multipliers between 2 and 10, where possible we will also calculate the success rate and frequency of practice for each pair based on the progress data.
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

  final sortedBySuccessRate = List<TimeTablePair>.from(allPairs)..sort((a, b) => a.successRate.compareTo(b.successRate));

  final sortedByFrequency = List<TimeTablePair>.from(allPairs)..sort((a, b) => a.frequency.compareTo(b.frequency));

  // Combine the two sorted lists to get a final list of tables that are either rare or difficult. For simplicity, we will just take the top tables from both lists and combine them, ensuring we don't have duplicates.
  final selectedTables = <TimeTablePair>{};

  for (var i = 0; i < tablesCount/2 && i < sortedByFrequency.length; i++) {
    selectedTables.add(sortedByFrequency[i]);
  }

  // We will add the tables from the success rate list, but only if they are not already in the selected tables from the frequency list, ensuring we reach the desired count of tables for the session.
  for (var i = 0; i < tablesCount/2 && selectedTables.length < tablesCount; i++) {
    if (!selectedTables.contains(sortedBySuccessRate[i])) {
      selectedTables.add(sortedBySuccessRate[i]);
    }
  }

  // Finally, we will shuffle the selected tables to ensure a random order for the session.

  final result = selectedTables.toList()..shuffle(Random());

  return result;

}

