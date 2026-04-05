import 'package:equatable/equatable.dart';

class TimeTablePair extends Equatable {
  final int number;
  final int multiplier;

  const TimeTablePair({required this.number, required this.multiplier});

  int get result => number * multiplier;

  @override
  List<Object?> get props => [number, multiplier];

}