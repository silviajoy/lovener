import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:impariamo/03_contiamo/02_domain/repositories/time_tables_progress_repository.dart';
import 'package:impariamo/03_contiamo/03_presentation/bloc/table_classic_session_bloc.dart';
import 'package:impariamo/src/router/app_router.dart';

import '../../02_domain/entities/time_table.dart';

/// Configuration for the Falling Bubbles mini game.
/// Using a static class to avoid magic numbers and duplicated configuration.
class GameConfig {
  static const Duration fallDuration = Duration(seconds: 5);
  static const Duration explosionDuration = Duration(milliseconds: 300);
  
  static const double bubbleSize = 70.0;
  static const double explosionScale = 1.5;

  static const Color bubbleColor = Colors.blueAccent;
  static const Color bubbleTextColor = Colors.white;
  static const Color correctColor = Colors.green;
  static const Color wrongColor = Colors.red;

  static const TextStyle bubbleTextStyle = TextStyle(
    color: bubbleTextColor,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle questionTextStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
  );
}

class TableChoice extends StatelessWidget {
  static final route = '/table-choice';

  final TimeTablesProgressRepository progressRepository;

  const TableChoice({
    super.key,
    required this.progressRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TableClassicSessionBloc(progressRepository)..add(TableClassicSessionStartEvent()),
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
        title: const Text('Scegli la Tabellina'),
      ),
      body: BlocBuilder<TableClassicSessionBloc, TableClassicSessionState>(
        builder: (context, state) {
          if (state.status == TableClassicSessionStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TableClassicSessionStatus.ended) {
            return _SessionEndedView(
              score: state.score,
              total: state.sessionTables.length,
              onBackToGames: () => context.go(AppRoutes.home),
              onRestart: () => context.read<TableClassicSessionBloc>().add(TableClassicSessionStartEvent()),
            );
          }

          if (state.sessionTables.isEmpty) {
            return const Center(child: Text('Nessun dato disponibile per la sessione'));
          }

          final currentIndex = state.currentTableIndex.clamp(0, state.sessionTables.length - 1);
          final currentTable = state.sessionTables[currentIndex];

          // Generate choices (one correct, 3 wrong)
          final correctAnswer = currentTable.result;
          final choices = <int>{correctAnswer};
          final random = Random();
          while (choices.length < 4) {
            int offset = random.nextInt(10) + 1;
            int wrongAnswer = random.nextBool() ? correctAnswer + offset : correctAnswer - offset;
            if (wrongAnswer > 0) choices.add(wrongAnswer);
          }
          final choiceList = choices.toList()..shuffle();

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: _QuestionDisplay(table: currentTable),
                  ),
                  Expanded(
                    child: (state.status == TableClassicSessionStatus.success)
                        ? FallingGameArea(
                            choices: choiceList,
                            onAnswerSelected: (answer) {
                              context.read<TableClassicSessionBloc>().add(
                                    TableClassicSessionAnswerEvent(answer: answer, tableIndex: currentIndex),
                                  );
                            },
                            onMissedAll: () {
                              context.read<TableClassicSessionBloc>().add(
                                    TableClassicSessionAnswerEvent(answer: -1, tableIndex: currentIndex),
                                  );
                            },
                            // Allow passing any FallingEntity builder
                            entityBuilder: (context, answer, onTap) {
                              return ExplodingBubble(
                                text: answer.toString(),
                                onTap: () => onTap(answer),
                              );
                            },
                          )
                        : const SizedBox.expand(), // Game is paused during feedback
                  ),
                ],
              ),
              if (state.status == TableClassicSessionStatus.between)
                GameFeedbackPopup(
                  isSuccess: state.success == true,
                  onNext: () {
                    context.read<TableClassicSessionBloc>().add(const TableClassicSessionNextEvent());
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _QuestionDisplay extends StatelessWidget {
  final TimeTablePair table;

  const _QuestionDisplay({required this.table});

  @override
  Widget build(BuildContext context) {
    return Text(
      '${table.number} x ${table.multiplier} = ?',
      textAlign: TextAlign.center,
      style: GameConfig.questionTextStyle,
    );
  }
}

/// Abstract builder for items that fall from the sky.
typedef FallingEntityBuilder = Widget Function(BuildContext context, int answer, void Function(int) onTap);

/// Manages the falling animation loop.
class FallingGameArea extends StatefulWidget {
  final List<int> choices;
  final ValueChanged<int> onAnswerSelected;
  final VoidCallback onMissedAll;
  final FallingEntityBuilder entityBuilder;

  const FallingGameArea({
    super.key,
    required this.choices,
    required this.onAnswerSelected,
    required this.onMissedAll,
    required this.entityBuilder,
  }) ;

  @override
  State<FallingGameArea> createState() => _FallingGameAreaState();
}

class _FallingGameAreaState extends State<FallingGameArea> with SingleTickerProviderStateMixin {
  late AnimationController _fallController;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _fallController = AnimationController(
      vsync: this,
      duration: GameConfig.fallDuration,
    );

    _fallController.forward().then((_) {
      if (mounted && !_answered) {
        _answered = true;
        widget.onMissedAll();
      }
    });
  }

  @override
  void didUpdateWidget(FallingGameArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If choices changed, restart animation (meaning next question)
    if (oldWidget.choices != widget.choices) {
      _answered = false;
      _fallController.reset();
      _fallController.forward().then((_) {
        if (mounted && !_answered) {
          _answered = true;
          widget.onMissedAll();
        }
      });
    }
  }

  @override
  void dispose() {
    _fallController.dispose();
    super.dispose();
  }

  void _handleTap(int answer) {
    if (_answered) return;
    _answered = true;
    _fallController.stop();
    // Allow explosion animation to play before selecting answer
    Future.delayed(GameConfig.explosionDuration, () {
      if (mounted) {
        widget.onAnswerSelected(answer);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth;
        final double containerHeight = constraints.maxHeight;
        
        // Calculate horizontal positions avoiding overlaps
        final double sectionWidth = containerWidth / widget.choices.length;

        return AnimatedBuilder(
          animation: _fallController,
          builder: (context, child) {
            return Stack(
              children: List.generate(widget.choices.length, (index) {
                // Determine horizontal offset for each bubble based on its section
                // To make it look staggered in height somewhat randomly, add a sin wave or simple offset.
                final randomOffset = (index % 2 == 0 ? 0.0 : -GameConfig.bubbleSize);
                
                final double startY = -GameConfig.bubbleSize * 2 + randomOffset;
                final double endY = containerHeight;
                
                // Calculate current Y
                final double currentY = startY + (endY - startY) * _fallController.value;
                
                final double xPos = (index * sectionWidth) + (sectionWidth / 2) - (GameConfig.bubbleSize / 2);

                return Positioned(
                  left: xPos,
                  top: currentY,
                  child: widget.entityBuilder(context, widget.choices[index], _handleTap),
                );
              }),
            );
          },
        );
      },
    );
  }
}

/// A fallback bubble entity that can be tapped and explodes.
class ExplodingBubble extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const ExplodingBubble({
    super.key,
    required this.text,
    required this.onTap,
  }) ;

  @override
  State<ExplodingBubble> createState() => _ExplodingBubbleState();
}

class _ExplodingBubbleState extends State<ExplodingBubble> with SingleTickerProviderStateMixin {
  late AnimationController _explosionController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _explosionController = AnimationController(
      vsync: this,
      duration: GameConfig.explosionDuration,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: GameConfig.explosionScale)
        .animate(CurvedAnimation(parent: _explosionController, curve: Curves.easeOut));
        
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _explosionController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _explosionController.dispose();
    super.dispose();
  }

  void _onTap() {
    if (_explosionController.isAnimating || _explosionController.isCompleted) return;
    _explosionController.forward();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _explosionController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: child,
            ),
          );
        },
        child: Container(
          width: GameConfig.bubbleSize,
          height: GameConfig.bubbleSize,
          decoration: const BoxDecoration(
            color: GameConfig.bubbleColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: GameConfig.bubbleTextStyle,
          ),
        ),
      ),
    );
  }
}

class GameFeedbackPopup extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback onNext;

  const GameFeedbackPopup({
    super.key,
    required this.isSuccess,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final title = isSuccess ? 'Perfetto!' : 'Dai riprova!';
    final color = isSuccess ? GameConfig.correctColor : GameConfig.wrongColor;
    final icon = isSuccess ? Icons.check_circle_outline : Icons.error_outline;

    return Container(
      color: Colors.black54,
      alignment: Alignment.center,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Continua', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
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
              'Sessione terminata\nPunteggio: $score / $total',
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
