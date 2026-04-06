import 'package:equatable/equatable.dart';

abstract class GuessTableSessionEvent extends Equatable {
  const GuessTableSessionEvent();

  @override
  List<Object?> get props => [];
}

class GuessTableSessionStartEvent extends GuessTableSessionEvent {}

class GuessTableSessionTickEvent extends GuessTableSessionEvent {}

class GuessTableSessionAnswerEvent extends GuessTableSessionEvent {
  final int answer;

  const GuessTableSessionAnswerEvent(this.answer);

  @override
  List<Object?> get props => [answer];
}

class GuessTableSessionNextEvent extends GuessTableSessionEvent {}

class GuessTableSessionEndEvent extends GuessTableSessionEvent {}
