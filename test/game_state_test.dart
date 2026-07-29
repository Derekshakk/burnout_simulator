import 'package:burnout_simulator/data/alex_scenarios.dart';
import 'package:burnout_simulator/data/demo_character.dart';
import 'package:burnout_simulator/data/jordan_character.dart';
import 'package:burnout_simulator/data/jordan_scenarios.dart';
import 'package:burnout_simulator/data/maya_character.dart';
import 'package:burnout_simulator/data/maya_scenarios.dart';
import 'package:burnout_simulator/models/character_profile.dart';
import 'package:burnout_simulator/models/game_scenario.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Jordan lists fidgets and sensory toys as a recovery strategy', () {
    expect(
      jordanCharacter.recoveryStrategies,
      contains('Fidgets and sensory toys'),
    );
  });

  test('every character provides gender and pronouns for selection cards', () {
    for (final character in [demoCharacter, jordanCharacter, mayaCharacter]) {
      expect(character.gender, isNotEmpty);
      expect(character.pronouns, isNotEmpty);
    }
  });

  test('every character route ends at 3:00 PM', () {
    _expectEveryRouteEndsAtThree(
      character: demoCharacter,
      scenarios: alexScenarios,
    );
    _expectEveryRouteEndsAtThree(
      character: jordanCharacter,
      scenarios: jordanScenarios,
    );
    _expectEveryRouteEndsAtThree(
      character: mayaCharacter,
      scenarios: mayaScenarios,
    );
  });
}

void _expectEveryRouteEndsAtThree({
  required CharacterProfile character,
  required List<GameScenario> scenarios,
}) {
  void visit(List<int> choiceIndexes) {
    if (choiceIndexes.length == scenarios.length) {
      final gameState = GameState();
      gameState.selectCharacter(character, scenarios);

      for (var i = 0; i < scenarios.length; i++) {
        gameState.applyChoice(scenarios[i].choices[choiceIndexes[i]]);
        gameState.advanceScenario(scenarios);
      }

      expect(gameState.isFinished, isTrue);
      expect(gameState.timeMinutes, 900);
      expect(gameState.currentTimeLabel, '03:00 PM');
      return;
    }

    for (var i = 0; i < scenarios[choiceIndexes.length].choices.length; i++) {
      visit([...choiceIndexes, i]);
    }
  }

  visit(const []);
}
