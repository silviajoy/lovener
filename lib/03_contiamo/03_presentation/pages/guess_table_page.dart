import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impariamo/src/di/injection.dart';
import 'package:impariamo/03_contiamo/03_presentation/bloc/guess_table_session_bloc.dart';
import 'package:impariamo/03_contiamo/03_presentation/bloc/guess_table_session_event.dart';
import 'package:impariamo/03_contiamo/03_presentation/bloc/guess_table_session_state.dart';
import 'package:impariamo/03_contiamo/utilities/game_widgets.dart';

import 'widgets/guess_table_numpad.dart';
import 'widgets/table_number_shape.dart';

class GuessTablePage extends StatelessWidget {
  static const String route = '/guess_table';

  const GuessTablePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuessTableSessionBloc(
        repository: getIt(instanceName: 'GuessTableRepository'),
      )..add(GuessTableSessionStartEvent()),
      child: const GuessTableScreen(),
    );
  }
}

class GuessTableScreen extends StatefulWidget {
  const GuessTableScreen({Key? key}) : super(key: key);

  @override
  _GuessTableScreenState createState() => _GuessTableScreenState();
}

class _GuessTableScreenState extends State<GuessTableScreen> {
  final Map<int, Offset> _positions = {};
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indovina la Tabellina'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<GuessTableSessionBloc, GuessTableSessionState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == GuessTableSessionStatus.between) {
            _showFeedback(context, state.isLastCorrect ?? false);
          } else if (state.status == GuessTableSessionStatus.success) {
            _positions.clear();
          }
        },
        builder: (context, state) {
          if (state.status == GuessTableSessionStatus.loading || state.status == GuessTableSessionStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state.status == GuessTableSessionStatus.ended) {
            return _buildEndScreen(state);
          }

          final random = Random();
          for (var m in state.revealedMultiples) {
            if (!_positions.containsKey(m)) {
              _positions[m] = Offset(random.nextDouble(), random.nextDouble());
            }
          }

          return Column(
            children: [
              _buildHeader(state),
              Expanded(child: _buildPlayArea(state)),
              _buildNumpad(context, state),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(GuessTableSessionState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Domanda: ${state.currentTableIndex + 1}/${state.sessionTables.length}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('Score: ${state.score}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildPlayArea(GuessTableSessionState state) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade100, width: 2)
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          return Stack(
            children: state.revealedMultiples.map((multiple) {
              final pos = _positions[multiple]!;
              final x = pos.dx * (width - 70); 
              final y = pos.dy * (height - 70); 

              return Positioned(
                left: x,
                top: y,
                child: TableNumberShape(number: multiple),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildNumpad(BuildContext context, GuessTableSessionState state) {
     return IgnorePointer(
       ignoring: state.status != GuessTableSessionStatus.success,
       child: GuessTableNumpad(
          onNumberTapped: (number) {
            context.read<GuessTableSessionBloc>().add(GuessTableSessionAnswerEvent(number));
          },
       ),
     );
  }

  Widget _buildEndScreen(GuessTableSessionState state) {
    return SessionEndedView(
      score: state.score,
      total: state.sessionTables.length * 10,
      onRestart: () {
        context.read<GuessTableSessionBloc>().add(GuessTableSessionStartEvent());
      },
      onBackToGames: () {
        Navigator.of(context).pop();
      },
    );
  }

  void _showFeedback(BuildContext context, bool isSuccess) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
         return GameFeedbackPopup(
            isSuccess: isSuccess,
            onNext: () {
               Navigator.of(context).pop();
               context.read<GuessTableSessionBloc>().add(GuessTableSessionNextEvent());
            },
         );
      }
    );
  }
}
