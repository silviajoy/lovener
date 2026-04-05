import 'package:impariamo/03_contiamo/01_data/datasources/hive_time_tables_progress_data_source.dart';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import '../models/hive_progress_model.dart';

class HiveTimeTablesProgressRepositoryImpl implements TimeTablesProgressRepository {
  final HiveTimeTablesProgressDataSource _dataSource;

  HiveTimeTablesProgressRepositoryImpl(this._dataSource);

  @override
  Future<TimeTablesProgress> getProgress() async {
    final rows = await _dataSource.loadStoredTimeTablesProgressRows();
    return rows.map((model) => model.toDomain()).toList();
  }

  @override
  Future<void> saveProgress(TimeTablesProgress progress) {
    return _dataSource.storeTimeTablesProgressRows(
      progress.map((domain) => HiveProgressModel.fromDomain(domain)).toList()
    );
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
}
