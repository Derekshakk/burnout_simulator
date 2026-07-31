import 'game_choice.dart';
import 'scene_artwork.dart';

class GameScenario {
  final String id;
  final String title;
  final String timeLabel;
  final String? endTimeLabel;
  final String description;
  final String narration;
  final List<GameChoice> choices;
  final String sceneTone;

  /// Location metadata used to choose a safe shared-background fallback.
  final String sceneType;

  /// The player this scenario belongs to. Shared scenarios set this at build
  /// time; null is reserved for intentionally character-neutral test data.
  final String? characterId;
  final Map<String, String>? carryoverNotes;
  final SceneArtwork? sceneArtwork;
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
    this.sceneType = 'neutral',
    this.characterId,
    this.carryoverNotes,
    this.sceneArtwork,
    this.sceneSemanticLabel,
  });

  /// Kept as a read-only convenience for semantic labels and legacy callers.
  String? get sceneImagePath => sceneArtwork?.assetPath;

  bool isValidForCharacter(String selectedCharacterId) {
    if (characterId != null && characterId != selectedCharacterId) return false;
    final artwork = sceneArtwork;
    return artwork == null ||
        (SceneArtworks.contains(artwork) &&
            artwork.sceneType == sceneType &&
            (artwork.isShared || artwork.characterId == selectedCharacterId));
  }
}
