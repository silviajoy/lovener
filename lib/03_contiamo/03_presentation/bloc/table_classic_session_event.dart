part of 'table_classic_session_bloc.dart';

class TableClassicSessionEvent extends Equatable {
  const TableClassicSessionEvent();

  @override
  List<Object?> get props => [];
}

class TableClassicSessionStartEvent extends TableClassicSessionEvent {
  const TableClassicSessionStartEvent();

  @override
  List<Object?> get props => [];
}

class TableClassicSessionAnswerEvent extends TableClassicSessionEvent {
  final int tableIndex;
  final int answer;

  const TableClassicSessionAnswerEvent({required this.tableIndex, required this.answer});

  @override
  List<Object?> get props => [tableIndex, answer];
}

class TableClassicSessionNextEvent extends TableClassicSessionEvent {
  const TableClassicSessionNextEvent();

  @override
  List<Object?> get props => [];
}

class TableClassicSessionEndEvent extends TableClassicSessionEvent {
  const TableClassicSessionEndEvent();

  @override
  List<Object?> get props => [];
}