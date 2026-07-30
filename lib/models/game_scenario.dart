import 'game_choice.dart';

class GameScenario {
  final String id;
  final String title;
  final String timeLabel;
  final String? endTimeLabel;
  final String description;
  final String narration;
  final List<GameChoice> choices;
  final String sceneTone;
  final Map<String, String>? carryoverNotes;
  final String? sceneImagePath;
  final String? sceneSemanticLabel;

  const GameScenario({
    required this.id,
    required this.title,
    required this.timeLabel,
    this.endTimeLabel,
    required this.description,
    required this.narration,
    required this.choices,
    this.sceneTone = 'neutral',
    this.carryoverNotes,
    this.sceneImagePath,
    this.sceneSemanticLabel,
  });
}
