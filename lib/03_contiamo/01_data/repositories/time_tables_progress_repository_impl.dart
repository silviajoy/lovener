import 'dart:async';

import 'package:impariamo/03_contiamo/02_domain/domain.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';

class MockTimeTablesProgressRepositoryImpl implements TimeTablesProgressRepository {


  MockTimeTablesProgressRepositoryImpl();

  @override
  Future<TimeTablesProgress> getProgress() => Future.value(_mockProgress());

  @override
  Future<void> saveProgress(TimeTablesProgress progress) => Future.value();

  @override
  Future<void> updatePairProgress({
    required int tableNumber,
    required int multiplier,
    required bool isCorrect,
  }) => Future.value();
  
  @override
  Future<void> updatePairsProgress(List<Progress> pairs) => Future.value();

  @override
  Future<void> resetProgress() => Future.value();

  @override
  Future<Progress?> getPairProgress(int tableNumber, int multiplier) => Future.value(_mockPairProgress(tableNumber, multiplier ));

  FutureOr<TimeTablesProgress>? _mockProgress() {
    return [
      Progress(pair: TimeTablePair(number: 2, multiplier: 3, successRate: 0.8, frequency: 10), correct: 8, total: 10),
      Progress(pair: TimeTablePair(number: 5, multiplier: 4, successRate: 0.5, frequency: 20), correct: 10, total: 20),
      Progress(pair: TimeTablePair(number: 7, multiplier: 6, successRate: 0.3, frequency: 15), correct: 5, total: 15),
    ];
  }
  
  FutureOr<Progress?>? _mockPairProgress(int tableNumber, int multiplier) {
    return Progress(pair: TimeTablePair(number: tableNumber, multiplier: multiplier, successRate: 0.8, frequency: 10), correct: 8, total: 10);
  }
}