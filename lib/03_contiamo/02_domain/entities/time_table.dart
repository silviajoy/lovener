import 'package:equatable/equatable.dart';

class TimeTablePair extends Equatable {
  final int number;
  final int multiplier;
  final double successRate;
  final int frequency;

  const TimeTablePair({required this.number, required this.multiplier, required this.successRate, required this.frequency});

  int get result => number * multiplier;

  @override
  List<Object?> get props => [number, multiplier, successRate, frequency];

}