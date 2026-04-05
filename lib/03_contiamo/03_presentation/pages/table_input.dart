import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/src/router/app_router.dart';
import 'package:impariamo/03_contiamo/utilities/game_widgets.dart';

import '../../02_domain/entities/time_table.dart';
import '../bloc/table_classic_session_bloc.dart';
import 'widgets/numpad.dart';

class TableInput extends StatelessWidget {
  static final route = '/contiamo/table-input';

  final TimeTablesProgressRepository progressRepository;

  const TableInput({
    super.key,
    required this.progressRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TableClassicSessionBloc(progressRepository)..add(TableClassicSessionStartEvent()),
      child: const _TableInputView(),
    );
  }
}

class _TableInputView extends StatefulWidget {
  const _TableInputView();

  @override
  State<_TableInputView> createState() => _TableInputViewState();
}

class _TableInputViewState extends State<_TableInputView> with SingleTickerProviderStateMixin {
  String _currentInput = '';
  late AnimationController _timerController;
  final Duration _timeLimit = const Duration(seconds: 10);
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: _timeLimit,
    );
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _onNumberTapped(int num) {
    if (_currentInput.length < 3) {
      setState(() {
        _currentInput += num.toString();
      });
    }
  }

  void _onBackspace() {
    if (_currentInput.isNotEmpty) {
      setState(() {
        _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      });
    }
  }

  void _onSubmit(BuildContext context, int tableIndex) {
    if (_answered) return;
    if (_currentInput.isEmpty) return;

    _timerController.stop();
    _answered = true;
    final int answer = int.tryParse(_currentInput) ?? -1;

    context.read<TableClassicSessionBloc>().add(
          TableClassicSessionAnswerEvent(answer: answer, tableIndex: tableIndex),
        );
  }

  void _onTimeout(BuildContext context, int tableIndex) {
    if (_answered) return;
    _answered = true;
    
    // Animate the explosion effect of the question target
    context.read<TableClassicSessionBloc>().add(
          TableClassicSessionAnswerEvent(answer: -1, tableIndex: tableIndex),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scrivi la Tabellina'),
      ),
      body: BlocConsumer<TableClassicSessionBloc, TableClassicSessionState>(
        listener: (context, state) {
          if (state.status == TableClassicSessionStatus.success && !_timerController.isAnimating) {
             _currentInput = '';
             _answered = false;
             _timerController.reset();
             _timerController.forward();
          }
          if (state.status == TableClassicSessionStatus.between) {
            _timerController.stop();
          }
        },
        builder: (context, state) {
          if (state.status == TableClassicSessionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TableClassicSessionStatus.ended) {
            return SessionEndedView(
              score: state.score,
              total: state.sessionTables.length,
              onBackToGames: () => context.go(AppRoutes.home),
              onRestart: () => context.read<TableClassicSessionBloc>().add(TableClassicSessionStartEvent()),
            );
          }

          if (state.sessionTables.isEmpty) {
            return const Center(child: Text('Nessun dato disponibile'));
          }

          final currentIndex = state.currentTableIndex.clamp(0, state.sessionTables.length - 1);
          final currentTable = state.sessionTables[currentIndex];

          return Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    if (state.status == TableClassicSessionStatus.success)
                      _CountdownBar(
                        controller: _timerController,
                        onTimeout: () => _onTimeout(context, currentIndex),
                      ),
                    const Spacer(),
                    _TargetDisplay(
                      table: currentTable, 
                      isExploding: state.status == TableClassicSessionStatus.between && state.success == false,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        _currentInput,
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 8),
                      ),
                    ),
                    const Spacer(),
                    AbsorbPointer(
                      absorbing: state.status != TableClassicSessionStatus.success,
                      child: Opacity(
                        opacity: state.status == TableClassicSessionStatus.success ? 1.0 : 0.5,
                        child: NumericKeypad(
                          onNumberTapped: _onNumberTapped,
                          onBackspace: _onBackspace,
                          onSubmit: () => _onSubmit(context, currentIndex),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),

              if (state.status == TableClassicSessionStatus.between)
                Positioned.fill(
                  child: GameFeedbackPopup(
                    isSuccess: state.success == true,
                    onNext: () {
                      context.read<TableClassicSessionBloc>().add(const TableClassicSessionNextEvent());
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CountdownBar extends AnimatedWidget {
  final VoidCallback onTimeout;

  const _CountdownBar({
    required AnimationController controller,
    required this.onTimeout,
  }) : super(listenable: controller);

  AnimationController get _controller => listenable as AnimationController;

  @override
  Widget build(BuildContext context) {
    if (_controller.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onTimeout());
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final remainingWidth = constraints.maxWidth * (1.0 - _controller.value);
        return Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          height: 12,
          color: Colors.grey[300],
          child: Container(
            width: remainingWidth,
            color: Color.lerp(Colors.green, Colors.red, _controller.value),
          ),
        );
      }
    );
  }
}

class _TargetDisplay extends StatefulWidget {
  final TimeTablePair table;
  final bool isExploding;

  const _TargetDisplay({required this.table, required this.isExploding});

  @override
  State<_TargetDisplay> createState() => _TargetDisplayState();
}

class _TargetDisplayState extends State<_TargetDisplay> {
  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.isExploding ? 2.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: AnimatedOpacity(
        opacity: widget.isExploding ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Text(
          '${widget.table.number} x ${widget.table.multiplier} = ?',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
