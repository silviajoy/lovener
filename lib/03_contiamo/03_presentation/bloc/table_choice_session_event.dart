part of 'table_choice_session_bloc.dart';

class TableChoiceSessionEvent extends Equatable {
  const TableChoiceSessionEvent();

  @override
  List<Object?> get props => [];
}

class TableChoiceSessionStartEvent extends TableChoiceSessionEvent {
  const TableChoiceSessionStartEvent();

  @override
  List<Object?> get props => [];
}

class TableChoiceSessionAnswerEvent extends TableChoiceSessionEvent {
  final int tableIndex;
  final int answer;

  const TableChoiceSessionAnswerEvent({required this.tableIndex, required this.answer});

  @override
  List<Object?> get props => [tableIndex, answer];
}

class TableChoiceSessionNextEvent extends TableChoiceSessionEvent {
  const TableChoiceSessionNextEvent();

  @override
  List<Object?> get props => [];
}

class TableChoiceSessionEndEvent extends TableChoiceSessionEvent {
  const TableChoiceSessionEndEvent();

  @override
  List<Object?> get props => [];
}