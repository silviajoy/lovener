import 'package:impariamo/03_contiamo/02_domain/domain.dart';

/// Data model representing the exact structure stored in Hive.
/// Hive saves these records natively as Map<dynamic, dynamic>, 
/// which we wrap into a strongly typed DTO (Data Transfer Object)
/// so the storage structure matches the business logic closely but separately.
class HiveProgressModel {
  /// The first operand of the multiplication table
  final int number;
  
  /// The second operand of the multiplication table
  final int multiplier;
  
  /// Total amount of times the user answered this pair correctly
  final int correct;
  
  /// Total amount of times the user encountered this pair
  final int total;

  const HiveProgressModel({
    required this.number,
    required this.multiplier,
    required this.correct,
    required this.total,
  });

  /// Constructs the Data Model from the raw Map retrieved from the Hive Box.
  factory HiveProgressModel.fromMap(Map<dynamic, dynamic> map) {
    return HiveProgressModel(
      number: map['number'] as int? ?? 0,
      multiplier: map['multiplier'] as int? ?? 0,
      correct: map['correct'] as int? ?? 0,
      total: map['total'] as int? ?? 0,
    );
  }

  /// Encodes the Data Model into the Map structure that Hive expects to save.
  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'multiplier': multiplier,
      'correct': correct,
      'total': total,
    };
  }

  /// Converts this Hive Data Model into the agnostic Domain Entity.
  Progress toDomain() {
    return Progress(
      pair: TimeTablePair(number: number, multiplier: multiplier),
      correct: correct,
      total: total,
    );
  }

  /// Creates a Hive Data Model starting from the Domain Entity.
  factory HiveProgressModel.fromDomain(Progress progress) {
    return HiveProgressModel(
      number: progress.pair.number,
      multiplier: progress.pair.multiplier,
      correct: progress.correct,
      total: progress.total,
    );
  }
}
