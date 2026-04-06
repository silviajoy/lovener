import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/03_contiamo/utilities/constants.dart';
import 'package:impariamo/03_contiamo/utilities/guess_table_utilities.dart';

import 'guess_table_session_event.dart';
import 'guess_table_session_state.dart';

class GuessTableSessionBloc extends Bloc<GuessTableSessionEvent, GuessTableSessionState> {
  final TimeTablesProgressRepository repository;
  Timer? _timer;
  List<int> _currentTableMultiples = [];

  GuessTableSessionBloc({required this.repository}) : super(const GuessTableSessionState()) {
    on<GuessTableSessionStartEvent>(_onStart);
    on<GuessTableSessionTickEvent>(_onTick);
    on<GuessTableSessionAnswerEvent>(_onAnswer);
    on<GuessTableSessionNextEvent>(_onNext);
    on<GuessTableSessionEndEvent>(_onEnd);
  }

  Future<void> _onStart(GuessTableSessionStartEvent event, Emitter<GuessTableSessionState> emit) async {
    emit(state.copyWith(status: GuessTableSessionStatus.loading));

    final guessProgress = await repository.getGuessTableProgress();
    final pairProgress = await repository.getProgress();

    final sessionTables = generateGuessTablesForSession(
        guessProgress, pairProgress, guessTableSessionLength);

    if (sessionTables.isEmpty) {
      emit(state.copyWith(status: GuessTableSessionStatus.failure));
      return;
    }

    _prepareTable(sessionTables.first);

    emit(state.copyWith(
      status: GuessTableSessionStatus.success,
      sessionTables: sessionTables,
      currentTableIndex: 0,
      targetTable: sessionTables.first,
      revealedMultiples: [_currentTableMultiples.first],
      score: 0,
    ));

    _startTimer();
  }

  void _prepareTable(int tableNumber) {
    _currentTableMultiples = List.generate(9, (index) => tableNumber * (index + 2))..shuffle(Random());
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      add(GuessTableSessionTickEvent());
    });
  }

  void _onTick(GuessTableSessionTickEvent event, Emitter<GuessTableSessionState> emit) {
    if (state.revealedMultiples.length < _currentTableMultiples.length) {
      final nextMultiple = _currentTableMultiples[state.revealedMultiples.length];
      emit(state.copyWith(
        revealedMultiples: List.from(state.revealedMultiples)..add(nextMultiple),
      ));
    } else {
      _timer?.cancel();
    }
  }

  Future<void> _onAnswer(GuessTableSessionAnswerEvent event, Emitter<GuessTableSessionState> emit) async {
    _timer?.cancel();

    final isCorrect = event.answer == state.targetTable;

    // Calculate score: Points awarded starting from 2nd revealed. max 9 multiples.
    int points = 0;
    if (isCorrect && state.revealedMultiples.length >= 2) {
      points = 12 - state.revealedMultiples.length; // max 10 points when length is 2
    }

    // Save progress
    await repository.updateGuessTableProgress(
      tableNumber: state.targetTable,
      points: points,
    );

    emit(state.copyWith(
      status: GuessTableSessionStatus.between,
      score: state.score + points,
      isLastCorrect: isCorrect,
    ));
  }

  void _onNext(GuessTableSessionNextEvent event, Emitter<GuessTableSessionState> emit) {
    final nextIndex = state.currentTableIndex + 1;
    if (nextIndex < state.sessionTables.length) {
      final nextTable = state.sessionTables[nextIndex];
      _prepareTable(nextTable);

      emit(state.copyWith(
        status: GuessTableSessionStatus.success,
        currentTableIndex: nextIndex,
        targetTable: nextTable,
        revealedMultiples: [_currentTableMultiples.first],
        isLastCorrect: null,
      ));

      _startTimer();
    } else {
      add(GuessTableSessionEndEvent());
    }
  }

  void _onEnd(GuessTableSessionEndEvent event, Emitter<GuessTableSessionState> emit) {
    _timer?.cancel();
    emit(state.copyWith(status: GuessTableSessionStatus.ended));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
