import 'package:impariamo/03_contiamo/02_domain/domain.dart';

/// Repository for managing TimeTablesProgress data.
/// Handles persistence and retrieval of user progress in time tables exercises.
abstract class TimeTablesProgressRepository {
  /// Retrieves the current progress data for the user.
  /// Returns [TimeTablesProgress] with all recorded attempts and statistics.
  Future<TimeTablesProgress> getProgress();

  /// Saves the progress data to storage.
  /// Updates existing progress or creates new record if none exists.
  Future<void> saveProgress(TimeTablesProgress progress);

  /// Updates progress for a specific table pair (number, multiplier).
  /// Records a new attempt with its result.
  Future<void> updatePairProgress({
    required int tableNumber,
    required int multiplier,
    required bool isCorrect,
  });

  Future<void> updatePairsProgress(List<Progress> pairs);

  /// Resets all progress data to initial state.
  Future<void> resetProgress();

  /// Retrieves progress for a specific pair.
  Future<Progress?> getPairProgress(int tableNumber, int multiplier);
}