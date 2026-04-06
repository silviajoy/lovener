import 'package:equatable/equatable.dart';

enum GuessTableSessionStatus { initial, loading, success, failure, between, ended }

class GuessTableSessionState extends Equatable {
  final GuessTableSessionStatus status;
  final int currentTableIndex;
  final List<int> sessionTables;
  final int score;
  final bool? isLastCorrect;
  final int targetTable;
  final List<int> revealedMultiples;

  const GuessTableSessionState({
    this.status = GuessTableSessionStatus.initial,
    this.currentTableIndex = 0,
    this.sessionTables = const [],
    this.score = 0,
    this.isLastCorrect,
    this.targetTable = 0,
    this.revealedMultiples = const [],
  });

  GuessTableSessionState copyWith({
    GuessTableSessionStatus? status,
    int? currentTableIndex,
    List<int>? sessionTables,
    int? score,
    bool? isLastCorrect,
    int? targetTable,
    List<int>? revealedMultiples,
  }) {
    return GuessTableSessionState(
      status: status ?? this.status,
      currentTableIndex: currentTableIndex ?? this.currentTableIndex,
      sessionTables: sessionTables ?? this.sessionTables,
      score: score ?? this.score,
      isLastCorrect: isLastCorrect, // explicit nullability
      targetTable: targetTable ?? this.targetTable,
      revealedMultiples: revealedMultiples ?? this.revealedMultiples,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentTableIndex,
        sessionTables,
        score,
        isLastCorrect,
        targetTable,
        revealedMultiples,
      ];
}
