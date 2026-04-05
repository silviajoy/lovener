part of 'table_classic_session_bloc.dart';

enum TableClassicSessionStatus { initial, loading, success, failure, between, ended }

final class TableClassicSessionState extends Equatable {
  final TableClassicSessionStatus   status;
  final List<TimeTablePair> sessionTables;
  final int currentTableIndex;
  final int score;
  final bool success;
  final TimeTablesProgress sessionProgress;

  const TableClassicSessionState({
    required this.currentTableIndex,
    required this.sessionTables,
    required this.score,
    required this.sessionProgress,
    this.status = TableClassicSessionStatus.initial, 
    this.success = false,
  });

  @override
  List<Object?> get props => [currentTableIndex, sessionTables, score,status  ];  

  TableClassicSessionState copyWith({
    TableClassicSessionStatus? status,
    List<TimeTablePair>? sessionTables,
    int? currentTableIndex,
    int? score,
    bool? success,
    TimeTablesProgress? sessionProgress,
  }) {
    return TableClassicSessionState(
      status: status ?? this.status,
      sessionTables: sessionTables ?? this.sessionTables,
      currentTableIndex: currentTableIndex ?? this.currentTableIndex,
      score: score ?? this.score,
      success: success ?? this.success,
      sessionProgress: sessionProgress ?? this.sessionProgress,
    );
  }
}
