import 'dart:math';

List<int> generateChoices(int correctAnswer) {
  final choices = <int>{correctAnswer};
  final random = Random();
  while (choices.length < 4) {
    int offset = random.nextInt(10) + 1;
    int wrongAnswer = random.nextBool() ? correctAnswer + offset : correctAnswer - offset;
    if (wrongAnswer > 0) choices.add(wrongAnswer);
  }
  final choiceList = choices.toList()..shuffle();
  return choiceList;
}
