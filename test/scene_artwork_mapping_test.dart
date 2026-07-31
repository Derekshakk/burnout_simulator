import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/data/demo_character.dart';
import 'package:burnout_simulator/data/jordan_character.dart';
import 'package:burnout_simulator/data/shared_scenarios.dart';
import 'package:burnout_simulator/models/game_scenario.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/models/scene_artwork.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every registered character has five ownership-safe scene mappings', () {
    for (final registration in registeredCharacters) {
      final characterId = registration.profile.id;
      expect(registration.scenarios, hasLength(5));

      for (final scenario in registration.scenarios) {
        expect(
          scenario.characterId,
          characterId,
          reason: '${scenario.id} must belong to $characterId',
        );
        expect(
          scenario.isValidForCharacter(characterId),
          isTrue,
          reason: '${scenario.id} references artwork for another character',
        );

        final resolvedAssets = SceneArtworkResolver.assetCandidates(
          preferredArtwork: scenario.sceneArtwork,
          selectedCharacterId: characterId,
          sceneType: scenario.sceneType,
        );
        for (final assetPath in resolvedAssets) {
          expect(
            assetPath,
            isNot(matches(RegExp(_otherCharacterId(characterId)))),
          );
        }
      }
    }
  });

  test('the audited assignments use only matching or shared artwork', () {
    final assetsByCharacter = {
      for (final registration in registeredCharacters)
        registration.profile.id: registration.scenarios
            .map((scenario) => scenario.sceneArtwork?.assetPath)
            .toList(),
    };

    expect(assetsByCharacter['alex'], [
      'assets/stories/alex_productive.jpg',
      'assets/stories/hallway_background.jpg',
      null,
      'assets/stories/cafeteria_background.jpg',
      'assets/stories/time_Awareness.jpg',
    ]);
    expect(assetsByCharacter['jordan'], [
      'assets/stories/jordan_hallway.jpg',
      'assets/stories/jordan_classroom.jpg',
      'assets/stories/jordan_cafeteria_conversation.jpg',
      'assets/stories/jordan_classroom.jpg',
      'assets/stories/jordan_bedroom_recovery.jpg',
    ]);
    expect(assetsByCharacter['maya'], [
      'assets/stories/time_Awareness.jpg',
      'assets/stories/bedroom_background.jpg',
      'assets/stories/maya_cafe_group.jpg',
      'assets/stories/maya_disclosing_to_teacher.jpg',
      'assets/stories/bedroom_background.jpg',
    ]);
  });

  test(
    'a mismatched character image falls back to a shared matching scene',
    () {
      final assets = SceneArtworkResolver.assetCandidates(
        preferredArtwork: SceneArtworks.jordanHallway,
        selectedCharacterId: 'alex',
        sceneType: 'hallway',
      );

      expect(assets, ['assets/stories/hallway_background.jpg']);
    },
  );

  test('a missing image leaves shared and pixel-art fallbacks available', () {
    const missingAlexHallway = SceneArtwork(
      assetPath: 'assets/stories/missing_alex_hallway.jpg',
      sceneType: 'hallway',
      characterId: 'alex',
    );
    final assets = SceneArtworkResolver.assetCandidates(
      preferredArtwork: missingAlexHallway,
      selectedCharacterId: 'alex',
      sceneType: 'hallway',
    );

    expect(assets, [
      'assets/stories/missing_alex_hallway.jpg',
      'assets/stories/hallway_background.jpg',
    ]);
  });

  test('shared scenario factories never borrow another character artwork', () {
    expect(
      buildLunchBreakScenario(jordanCharacter).sceneArtwork,
      SceneArtworks.cafeteriaBackground,
    );
    expect(
      buildAccommodationsScenario(demoCharacter).sceneArtwork,
      SceneArtworks.bedroomBackground,
    );
  });

  test(
    'GameState rejects scenarios and artwork owned by another character',
    () {
      const invalidScenario = GameScenario(
        id: 'invalid_scene',
        characterId: 'alex',
        title: 'Invalid scene',
        timeLabel: '8:00 AM',
        description: 'Test scenario.',
        narration: 'Test narration.',
        choices: [],
        sceneType: 'classroom',
        sceneArtwork: SceneArtworks.jordanClassroom,
      );

      expect(
        () =>
            GameState().selectCharacter(demoCharacter, const [invalidScenario]),
        throwsArgumentError,
      );
    },
  );

  test('GameState rejects artwork that bypasses the ownership registry', () {
    const unregisteredArtwork = SceneArtwork(
      assetPath: 'assets/stories/future_alex_scene.jpg',
      sceneType: 'home',
      characterId: 'alex',
    );
    const invalidScenario = GameScenario(
      id: 'unregistered_scene',
      characterId: 'alex',
      title: 'Unregistered scene',
      timeLabel: '8:00 AM',
      description: 'Test scenario.',
      narration: 'Test narration.',
      choices: [],
      sceneType: 'home',
      sceneArtwork: unregisteredArtwork,
    );

    expect(
      () => GameState().selectCharacter(demoCharacter, const [invalidScenario]),
      throwsArgumentError,
    );
  });
}

String _otherCharacterId(String characterId) {
  switch (characterId) {
    case 'alex':
      return 'jordan|maya';
    case 'jordan':
      return 'alex|maya';
    case 'maya':
      return 'alex|jordan';
    default:
      return 'alex|jordan|maya';
  }
}
