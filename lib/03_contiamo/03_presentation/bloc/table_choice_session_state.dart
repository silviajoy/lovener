part of 'table_choice_session_bloc.dart';

enum TableChoiceStatus { initial, loading, success, failure, between, ended }

final class TableChoiceSessionState extends Equatable {
  final TableChoiceStatus status;
  final List<TimeTablePair> sessionTables;
  final int currentTableIndex;
  final int score;
  final bool success;
  final TimeTablesProgress initialProgress;
  final TimeTablesProgress sessionProgress;

  const TableChoiceSessionState({
    required this.currentTableIndex,
    required this.sessionTables,
    required this.score,
    required this.initialProgress,
    required this.sessionProgress,
    this.status = TableChoiceStatus.initial, 
    this.success = false,
  });

  @override
  List<Object?> get props => [currentTableIndex, sessionTables, score, initialProgress  , status  ];  

  TableChoiceSessionState copyWith({
    TableChoiceStatus? status,
    List<TimeTablePair>? sessionTables,
    int? currentTableIndex,
    int? score,
    TimeTablesProgress? initialProgress,
    bool? success,
    TimeTablesProgress? sessionProgress,
  }) {
    return TableChoiceSessionState(
      status: status ?? this.status,
      sessionTables: sessionTables ?? this.sessionTables,
      currentTableIndex: currentTableIndex ?? this.currentTableIndex,
      score: score ?? this.score,
      initialProgress: initialProgress ?? this.initialProgress,
      success: success ?? this.success,
      sessionProgress: sessionProgress ?? this.sessionProgress,
    );
  }
}
