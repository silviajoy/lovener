import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'table_choice.dart';

class MiniGames extends StatelessWidget {
  
  final gamesData = [
    {'title': 'Cosa scegli?', 'description': 'Tabelline a scelta multipla', 'route': TableChoice.route},
    {'title': 'Game 2', 'description': 'Description of Game 2', 'route': '/game2'},
    {'title': 'Game 3', 'description': 'Description of Game 3', 'route': '/game3'},
  ];
  
  NullableIndexedWidgetBuilder get itemBuilder => (context, index) {
    final game = gamesData[index];
    return ListTile(
      title: Text(game['title']!),
      subtitle: Text(game['description']!),
      onTap: () {
        // Navigate to the game route
        GoRouter.of(context).go(game['route']!);
      },
    );
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ContiAMO'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: gamesData.length,
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}