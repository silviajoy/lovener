import 'package:equatable/equatable.dart';
import 'package:impariamo/03_contiamo/02_domain/entities/time_table.dart';

// TimeTablesProgress is a list of Progress objects, each representing the progress for a specific table and multiplier.
typedef TimeTablesProgress = List<Progress>;

// Progress is a simple class to keep track of the number of correct answers and total attempts for a specific table and multiplier.
class Progress extends Equatable {
  final TimeTablePair pair;
  final int correct;
  final int total;
  const Progress({required this.pair, required this.correct, required this.total});

  @override
  List<Object?> get props => [pair, correct, total];
}