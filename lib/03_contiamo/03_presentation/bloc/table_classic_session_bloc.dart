import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impariamo/03_contiamo/02_domain/domain.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/03_contiamo/utilities/constants.dart';
import 'package:impariamo/03_contiamo/utilities/session_utilities.dart';

part 'table_classic_session_state.dart';
part 'table_classic_session_event.dart';

class TableClassicSessionBloc extends Bloc<TableClassicSessionEvent, TableClassicSessionState> {
  final TimeTablesProgressRepository _progressRepository;

  TableClassicSessionBloc(this._progressRepository)
      : super(const TableClassicSessionState(
          currentTableIndex: 0,
          sessionTables: [],
          score: 0,
          sessionProgress: [],
        )) {
    on<TableClassicSessionStartEvent>(_onStart);
    on<TableClassicSessionAnswerEvent>(_onAnswer);
    on<TableClassicSessionNextEvent>(_onNext);
    on<TableClassicSessionEndEvent>(_onEnd);
  }

  Future<void> _onStart(TableClassicSessionStartEvent event, Emitter<TableClassicSessionState> emit) async {
    emit(state.copyWith(status: TableClassicSessionStatus.loading, score: 0, currentTableIndex: 0, sessionProgress: []));

    try {
      final progress = await _progressRepository.getProgress();
      final tables = generateTablesForSession(tableGameSessionLength, progress);

      emit(state.copyWith(
        status: TableClassicSessionStatus.success,
        sessionTables: tables,
        currentTableIndex: 0,
      ));
    } catch (_) {
      emit(state.copyWith(status: TableClassicSessionStatus.failure));
    }
  }

  void _onAnswer(TableClassicSessionAnswerEvent event, Emitter<TableClassicSessionState> emit) {
    final currentTable = state.sessionTables[state.currentTableIndex];
    final correctAnswer = currentTable.result;

    final isCorrect = event.answer == correctAnswer;
    final updatedScore = isCorrect ? state.score + 1 : state.score;

    final updatedProgress = [...state.sessionProgress];
    updatedProgress.add(Progress(pair: currentTable, correct: isCorrect ? 1 : 0, total: 1));

    emit(state.copyWith(
      score: updatedScore,
      success: isCorrect,
      status: TableClassicSessionStatus.between,
      sessionProgress: updatedProgress,
    ));
  }

  Future<void> _onNext(TableClassicSessionNextEvent event, Emitter<TableClassicSessionState> emit) async {
    final nextIndex = state.currentTableIndex + 1;
    if (nextIndex < state.sessionTables.length) {
      emit(state.copyWith(
        currentTableIndex: nextIndex,
        status: TableClassicSessionStatus.success,
        success: null,
      ));
    } else {
      emit(state.copyWith(status: TableClassicSessionStatus.loading));
      await _onEnd(TableClassicSessionEndEvent(), emit);
    }
  }

  Future<void> _onEnd(TableClassicSessionEndEvent event, Emitter<TableClassicSessionState> emit) async {
    emit(state.copyWith(status: TableClassicSessionStatus.loading));
    try {
      await _progressRepository.updatePairsProgress(state.sessionProgress);
      emit(state.copyWith(status: TableClassicSessionStatus.ended));
    } catch (_) {
      emit(state.copyWith(status: TableClassicSessionStatus.failure));
    }
  }
}
