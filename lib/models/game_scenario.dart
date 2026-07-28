import 'game_choice.dart';

class GameScenario {
  final String id;
  final String title;
  final String timeLabel;
  final String description;
  final String narration;
  final List<GameChoice> choices;
  final String sceneTone;

  const GameScenario({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.description,
    required this.narration,
    required this.choices,
    this.sceneTone = 'neutral',
  });
}
