import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/03_contiamo/utilities/constants.dart';
import 'package:impariamo/03_contiamo/utilities/session_utilities.dart';

part 'table_choice_session_state.dart';
part 'table_choice_session_event.dart';

class TableChoiceSessionBloc extends Bloc<TableChoiceSessionEvent, TableChoiceSessionState> {
  final TimeTablesProgressRepository _progressRepository;

  TableChoiceSessionBloc(this._progressRepository)
      : super(const TableChoiceSessionState(
          currentTableIndex: 0,
          sessionTables: [],
          score: 0,
          initialProgress: [],
          sessionProgress: [],
        )) {
    on<TableChoiceSessionStartEvent>(_onStart);
    on<TableChoiceSessionAnswerEvent>(_onAnswer);
    on<TableChoiceSessionNextEvent>(_onNext);
    on<TableChoiceSessionEndEvent>(_onEnd);
  }

  void _onStart(TableChoiceSessionStartEvent event, Emitter<TableChoiceSessionState> emit) {
    emit(state.copyWith(status: TableChoiceStatus.loading, score: 0, currentTableIndex: 0, sessionProgress: []));

    _progressRepository.getProgress().then((progress) {
      final tables = generateTablesForSession(TableChoiceSessionLength, progress);

      emit(state.copyWith(
        status: TableChoiceStatus.success,
        sessionTables: tables,
        currentTableIndex: 0,
      ));
    }).catchError((error) {
      emit(state.copyWith(status: TableChoiceStatus.failure));
    });
  }

  void _onAnswer(TableChoiceSessionAnswerEvent event, Emitter<TableChoiceSessionState> emit) {
    final currentTable = state.sessionTables[state.currentTableIndex];
    final correctAnswer = currentTable.result;

    final isCorrect = event.answer == correctAnswer;
    final updatedScore = isCorrect ? state.score + 1 : state.score;

    final updatedProgress = [...state.sessionProgress];
    updatedProgress.add(Progress(pair: currentTable, correct: isCorrect ? 1 : 0, total: 1));

    emit(state.copyWith(
      score: updatedScore,
      success: isCorrect,
      status: TableChoiceStatus.between,
      sessionProgress: updatedProgress,
    ));
  }

  void _onNext(TableChoiceSessionNextEvent event, Emitter<TableChoiceSessionState> emit) {
    final nextIndex = state.currentTableIndex + 1;
    if (nextIndex < state.sessionTables.length) {
      emit(state.copyWith(
        currentTableIndex: nextIndex,
        status: TableChoiceStatus.success,
        success: null,
      ));
    } else {
      _onEnd(TableChoiceSessionEndEvent(), emit);
    }
  }

  void _onEnd(TableChoiceSessionEndEvent event, Emitter<TableChoiceSessionState> emit) {
    emit(state.copyWith(status: TableChoiceStatus.loading));
    _progressRepository.updatePairsProgress(state.sessionProgress).then((_) {
      emit(state.copyWith(status: TableChoiceStatus.ended));
    }).catchError((error) {
      emit(state.copyWith(status: TableChoiceStatus.failure));
    });
  }
}
