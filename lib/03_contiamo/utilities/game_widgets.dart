import 'package:flutter/material.dart';

class GameFeedbackPopup extends StatelessWidget {
  final bool isSuccess;
  final VoidCallback onNext;
  final Color correctColor;
  final Color wrongColor;

  const GameFeedbackPopup({
    super.key,
    required this.isSuccess,
    required this.onNext,
    this.correctColor = Colors.green,
    this.wrongColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    final title = isSuccess ? 'Perfetto!' : 'Dai riprova!';
    final color = isSuccess ? correctColor : wrongColor;
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

class SessionEndedView extends StatelessWidget {
  final int score;
  final int total;
  final VoidCallback onBackToGames;
  final VoidCallback onRestart;

  const SessionEndedView({
    super.key,
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
