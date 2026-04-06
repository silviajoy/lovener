import 'dart:math';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';

List<int> generateGuessTablesForSession(
  List<GuessTableProgress> guessProgress,
  List<Progress> pairProgress,
  int count,
) {
  // Aggregate pair progress per base table
  final Map<int, _AggregatedProgress> aggregated = {};
  for (int i = 2; i <= 10; i++) {
    aggregated[i] = _AggregatedProgress(tableNumber: i);
  }

  for (final p in pairProgress) {
    if (p.pair.number >= 2 && p.pair.number <= 10) {
      aggregated[p.pair.number]!.addPairProgress(p);
    }
  }

  for (final g in guessProgress) {
    if (g.tableNumber >= 2 && g.tableNumber <= 10) {
      aggregated[g.tableNumber]!.addGuessProgress(g);
    }
  }

  // Calculate scores
  List<_AggregatedProgress> sortedList = aggregated.values.toList();
  
  // Sort by combined metrics: least frequent and most difficult
  // Taking rarest
  sortedList.sort((a, b) {
    if (a.totalAttempts != b.totalAttempts) {
      return a.totalAttempts.compareTo(b.totalAttempts);
    }
    return a.successRate.compareTo(b.successRate);
  });

  final int rarestCount = count ~/ 2;
  final rarest = sortedList.take(rarestCount).toList();

  final remaining = sortedList.skip(rarestCount).toList();
  remaining.sort((a, b) => a.successRate.compareTo(b.successRate));

  final int difficultCount = count - rarestCount;
  final difficult = remaining.take(difficultCount).toList();

  final selected = [...rarest, ...difficult];
  selected.shuffle(Random());
  return selected.map((e) => e.tableNumber).toList();
}

class _AggregatedProgress {
  final int tableNumber;
  int correct = 0;
  int totalAttempts = 0;

  _AggregatedProgress({required this.tableNumber});

  void addPairProgress(Progress p) {
    correct += p.correct;
    totalAttempts += p.total;
  }

  void addGuessProgress(GuessTableProgress g) {
    // Calculate fractional equivalent of success based on max 10 points. 
    correct += (g.averagePoints * g.total / 10).round();
    totalAttempts += g.total;
  }

  double get successRate => totalAttempts == 0 ? 0.0 : correct / totalAttempts;
}
