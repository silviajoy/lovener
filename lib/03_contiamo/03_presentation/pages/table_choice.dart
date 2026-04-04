import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/03_contiamo/03_presentation/bloc/table_choice_session_bloc.dart';
import 'package:impariamo/src/router/app_router.dart';

class TableChoice extends StatelessWidget {
  static final route = '/contiamo/table-choice';

  final TimeTablesProgressRepository progressRepository;

  const TableChoice({
    super.key,
    required this.progressRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TableChoiceSessionBloc(progressRepository)..add(TableChoiceSessionStartEvent()),
      child: const _TableChoiceView(),
    );
  }
}

class _TableChoiceView extends StatelessWidget {
  const _TableChoiceView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Table'),
      ),
      body: BlocBuilder<TableChoiceSessionBloc, TableChoiceSessionState>(
        builder: (context, state) {
          if (state.status == TableChoiceStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TableChoiceStatus.ended) {
            return _SessionEndedView(
              score: state.score,
              total: state.sessionTables.length,
              onBackToGames: () => context.go(AppRoutes.home),
              onRestart: () => context.read<TableChoiceSessionBloc>().add(TableChoiceSessionStartEvent()),
            );
          }

          if (state.sessionTables.isEmpty) {
            return const Center(child: Text('No session data available'));
          }

          final currentIndex = state.currentTableIndex.clamp(0, state.sessionTables.length - 1);
          final currentTable = state.sessionTables[currentIndex];

          final correctAnswer = currentTable.result;
          final choices = <int>{correctAnswer};

          while (choices.length < 4) {
            choices.add(correctAnswer + (choices.length + 1) * 2);
          }

          final choiceList = choices.toList()..shuffle();

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Score: ${state.score}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                Text(
                  '${currentTable.number} × ${currentTable.multiplier} = ?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 32),
                ...choiceList.map(
                  (answer) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: state.status == TableChoiceStatus.between
                          ? null
                          : () {
                              context.read<TableChoiceSessionBloc>().add(
                                    TableChoiceSessionAnswerEvent(answer: answer, tableIndex: currentIndex),
                                  );
                            },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          answer.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (state.status == TableChoiceStatus.between)
                  ElevatedButton(
                    onPressed: () {
                      context.read<TableChoiceSessionBloc>().add(const TableChoiceSessionNextEvent());
                    },
                    child: const Text('Next'),
                  ),
                if (state.success != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      state.success == true ? 'Correct!' : 'Wrong answer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: state.success == true ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SessionEndedView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onBackToGames;
  final VoidCallback onRestart;

  const _SessionEndedView({
    required this.score,
    required this.total,
    required this.onBackToGames,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Session ended\nScore: $score / $total',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onBackToGames,
              child: const Text('Cambia gioco'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRestart,
              child: const Text('Ricomincia'),
            ),
          ],
        ),
      ),
    );
  }
}