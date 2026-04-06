import 'package:impariamo/03_contiamo/02_domain/domain.dart';

/// The central domain interface defining the required contract for tracking
/// learning progress throughout the math modules.
///
/// In Clean Architecture, the Presentation (BLoC) calls these methods to
/// manage domain states, oblivious to whether the implementing Data layer
/// uses Hive locally or an API remotely.
abstract class TimeTablesProgressRepository {
  /// Fetches the exhaustive list of all time table attempts.
  /// 
  /// Typically returns the history of individual [Progress] records.
  Future<TimeTablesProgress> getProgress();

  /// Persists a fully constructed [TimeTablesProgress] list to the data layer.
  Future<void> saveProgress(TimeTablesProgress progress);

  /// Fast-path update method when you just need to increment one attempt
  /// for a specific mathematical pair.
  Future<void> updatePairProgress({
    required int tableNumber,
    required int multiplier,
    required bool isCorrect,
  });

  /// Batch update multiple pairs efficiently.
  Future<void> updatePairsProgress(List<Progress> pairs);

  /// Wipes all historical data and resets user progress to factory defaults.
  Future<void> resetProgress();

  /// Looks up a precise specific progress history to check how often a user
  /// missed a specific problem previously.
  Future<Progress?> getPairProgress(int tableNumber, int multiplier);

  /// Specialized call used by the Guess Table game to retrieve overall 
  /// base number mastery.
  Future<List<GuessTableProgress>> getGuessTableProgress();

  /// Persists the full [GuessTableProgress] list to storage.
  Future<void> saveGuessTableProgress(List<GuessTableProgress> progress);

  /// Shortcut to update the user's score for a specific Guess Table base number.
  Future<void> updateGuessTableProgress({
    required int tableNumber,
    required int points,
  });

  /// Batch update of scores for multiple Guess Table base numbers.
  Future<void> updateGuessTablesProgress(List<GuessTableProgress> progress);
}
