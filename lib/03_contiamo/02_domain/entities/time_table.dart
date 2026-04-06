import 'package:equatable/equatable.dart';

/// Represents a distinct mathematical operational pair for multiplication.
///
/// Under Clean Architecture, this domain entity is the source of truth for
/// generating pairs and resolving the correct answer uniformly.
class TimeTablePair extends Equatable {
  /// The base table number being practiced (e.g., the "5" in 5 x 4).
  final int number;

  /// The factor applied to the base number (e.g., the "4" in 5 x 4).
  final int multiplier;

  /// Constructs a [TimeTablePair] representing the equation `number * multiplier`.
  const TimeTablePair({required this.number, required this.multiplier});

  /// Computes the mathematical product of the configured pair.
  int get result => number * multiplier;

  @override
  List<Object?> get props => [number, multiplier];
}
