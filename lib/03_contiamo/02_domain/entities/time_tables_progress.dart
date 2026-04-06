import 'package:equatable/equatable.dart';
import 'package:impariamo/03_contiamo/02_domain/entities/time_table.dart';

/// A type definition representing the comprehensive state of all
/// tracked time tables progress.
typedef TimeTablesProgress = List<Progress>;

/// Represents a single tracked progress node for a specific mathematical pair.
///
/// This domain entity is essential in the Clean Architecture layers to evaluate
/// a user's mastery of specific multiplication facts without relying on
/// data-layer implementation details.
class Progress extends Equatable {
  /// The multiplication pair (e.g., 3 x 4) this progress object tracks.
  final TimeTablePair pair;

  /// The number of times the user has correctly answered this specific [pair].
  final int correct;

  /// The total number of attempts the user has made for this [pair].
  final int total;

  /// Constructs a tracked [Progress] instance for a [pair].
  const Progress({
    required this.pair,
    required this.correct,
    required this.total,
  });

  /// Computes the success rate as a ratio between 0.0 and 1.0.
  /// If the [pair] has never been attempted, gracefully returns 0.0.
  double get successRate => total > 0 ? correct / total : 0.0;

  /// The frequency or total number of attempts made for this [pair].
  int get frequency => total;

  @override
  List<Object?> get props => [pair, correct, total];
}
