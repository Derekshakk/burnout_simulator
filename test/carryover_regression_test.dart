import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the most recent applicable carryover takes precedence', () {
    final alex = registeredCharacters.firstWhere(
      (registration) => registration.profile.id == 'alex',
    );
    final gameState = GameState();
    gameState.selectCharacter(alex.profile, alex.scenarios);

    _chooseAndContinue(gameState, 'try_everything');
    _chooseAndContinue(gameState, 'push_through_crowd');

    final classScenario =
        gameState.activeScenarios[gameState.currentScenarioIndex];
    expect(classScenario.id, 'class_restlessness');
    expect(
      gameState.carryoverNote(classScenario),
      contains('sensory pressure from the hallway'),
    );
  });

  test('Maya\'s adapted-connection lunch path carries into critique', () {
    final maya = registeredCharacters.firstWhere(
      (registration) => registration.profile.id == 'maya',
    );
    final gameState = GameState();
    gameState.selectCharacter(maya.profile, maya.scenarios);

    _chooseAndContinue(gameState, 'maya_make_next_steps');
    _chooseAndContinue(gameState, 'maya_silence_nonessential');
    _chooseAndContinue(gameState, 'maya_invite_one_friend');

    final critiqueScenario =
        gameState.activeScenarios[gameState.currentScenarioIndex];
    expect(critiqueScenario.id, 'maya_critique');
    expect(
      gameState.carryoverNote(critiqueScenario),
      contains('without giving up the relationship'),
    );
  });
}

void _chooseAndContinue(GameState gameState, String choiceId) {
  final scenario = gameState.activeScenarios[gameState.currentScenarioIndex];
  final choice = scenario.choices.firstWhere((choice) => choice.id == choiceId);
  gameState.applyChoice(choice);
  gameState.advanceScenario();
}
