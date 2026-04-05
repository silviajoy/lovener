import 'package:impariamo/03_contiamo/01_data/datasources/hive_time_tables_progress_data_source.dart';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';

class HiveTimeTablesProgressRepositoryImpl implements TimeTablesProgressRepository {
  final HiveTimeTablesProgressDataSource _dataSource;

  HiveTimeTablesProgressRepositoryImpl(this._dataSource);

  @override
  Future<TimeTablesProgress> getProgress() async {
    final rows = await _dataSource.loadStoredTimeTablesProgressRows();
    return rows.map(_deserializeProgress).toList();
  }

  @override
  Future<void> saveProgress(TimeTablesProgress progress) {
    return _dataSource.storeTimeTablesProgressRows(progress.map(_serializeProgress).toList());
  }

  @override
  Future<void> updatePairProgress({
    required int tableNumber,
    required int multiplier,
    required bool isCorrect,
  }) async {
    final progress = await getProgress();
    final index = progress.indexWhere(
      (item) => item.pair.number == tableNumber && item.pair.multiplier == multiplier,
    );

    if (index == -1) {
      progress.add(
        Progress(
          pair: TimeTablePair(number: tableNumber, multiplier: multiplier),
          correct: isCorrect ? 1 : 0,
          total: 1,
        ),
      );
    } else {
      final current = progress[index];
      progress[index] = Progress(
        pair: current.pair,
        correct: current.correct + (isCorrect ? 1 : 0),
        total: current.total + 1,
      );
    }

    await saveProgress(progress);
  }

  @override
  Future<void> updatePairsProgress(List<Progress> pairs) => saveProgress(pairs);

  @override
  Future<void> resetProgress() => _dataSource.clearStoredTimeTablesProgressRows();

  @override
  Future<Progress?> getPairProgress(int tableNumber, int multiplier) async {
    final progress = await getProgress();
    return progress.cast<Progress?>().firstWhere(
          (item) => item!.pair.number == tableNumber && item.pair.multiplier == multiplier,
          orElse: () => null,
        );
  }

  Map<String, Object> _serializeProgress(Progress progress) {
    return {
      'number': progress.pair.number,
      'multiplier': progress.pair.multiplier,
      'correct': progress.correct,
      'total': progress.total,
    };
  }

  Progress _deserializeProgress(Map row) {
    return Progress(
      pair: TimeTablePair(number: row['number'] as int, multiplier: row['multiplier'] as int),
      correct: row['correct'] as int,
      total: row['total'] as int,
    );
  }
}