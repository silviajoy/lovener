import 'package:equatable/equatable.dart';

/// Represents the user's progress for a specific base number in
/// the "Guess Table" game mode.
///
/// This entity tracks the average points scored across multiple attempts
/// for a given multiplication table. It uses [Equatable] for value-based
/// comparison, aiding in state management.
class GuessTableProgress extends Equatable {
  /// The base number of the multiplication table (e.g., 2 for the 2x table).
  final int tableNumber;

  /// The average points the user has scored for this table across all games.
  final double averagePoints;

  /// The total number of times the user has practiced this table.
  final int total;

  /// Constructs a [GuessTableProgress] instance with the given metrics.
  const GuessTableProgress({
    required this.tableNumber,
    required this.averagePoints,
    required this.total,
  });

  /// Calculates the success rate normalized between 0.0 and 1.0.
  ///
  /// Assumes a maximum possible score of 10.0 points per attempt.
  double get successRate => total == 0 ? 0 : averagePoints / 10.0;

  /// An alias for [total], indicating how frequently this table was practiced.
  int get frequency => total;

  @override
  List<Object?> get props => [tableNumber, averagePoints, total];
}
