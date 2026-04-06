import 'package:equatable/equatable.dart';

class GuessTableProgress extends Equatable {
  final int tableNumber;
  final double averagePoints;
  final int total;

  const GuessTableProgress({
    required this.tableNumber,
    required this.averagePoints,
    required this.total,
  });

  double get successRate => total == 0 ? 0 : averagePoints / 10.0;
  int get frequency => total;

  @override
  List<Object?> get props => [tableNumber, averagePoints, total];
}
