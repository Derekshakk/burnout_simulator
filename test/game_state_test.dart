import 'package:burnout_simulator/app/routes.dart';
import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/data/jordan_character.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Jordan lists fidgets and sensory toys as a recovery strategy', () {
    expect(
      jordanCharacter.recoveryStrategies,
      contains('Fidgets and sensory toys'),
    );
  });

  test('every registered character provides gender and pronouns', () {
    for (final registration in registeredCharacters) {
      expect(registration.profile.gender, isNotEmpty);
      expect(registration.profile.pronouns, isNotEmpty);
    }
  });

  test('every registered character provides a pixel-figure appearance', () {
    for (final registration in registeredCharacters) {
      final appearance = registration.profile.appearance;
      expect(appearance, isNotNull);
      expect(appearance!.skinTone.a, greaterThan(0));
      expect(appearance.hairColor.a, greaterThan(0));
      expect(appearance.topColor.a, greaterThan(0));
      expect(appearance.bottomColor.a, greaterThan(0));
    }
  });

  for (final registration in registeredCharacters) {
    test('${registration.profile.name} completes a clean game lifecycle', () {
      final gameState = GameState();

      expect(gameState.sessionStatus, GameSessionStatus.unselected);
      expect(gameState.routeFor(AppRoutes.play), AppRoutes.select);
      expect(gameState.routeFor(AppRoutes.results), AppRoutes.select);

      gameState.selectCharacter(registration.profile, registration.scenarios);
      expect(gameState.sessionStatus, GameSessionStatus.playing);
      expect(gameState.routeFor(AppRoutes.play), AppRoutes.play);
      expect(gameState.routeFor(AppRoutes.results), AppRoutes.play);

      _completeGame(gameState);
      expect(gameState.hasCompletedGame, isTrue);
      expect(gameState.routeFor(AppRoutes.play), AppRoutes.results);
      expect(gameState.routeFor(AppRoutes.results), AppRoutes.results);
      expect(gameState.currentTimeLabel, '03:00 PM');

      gameState.toggleVisualEffects();
      gameState.endSession();
      _expectClearedSession(gameState, preserveReducedEffects: true);
    });
  }

  test('switching characters discards choices and character carryover', () {
    final gameState = GameState();
    final first = registeredCharacters.first;
    final second = registeredCharacters.skip(1).first;
    gameState.selectCharacter(first.profile, first.scenarios);
    gameState.applyChoice(first.scenarios.first.choices.first);

    gameState.selectCharacter(second.profile, second.scenarios);

    expect(gameState.selectedCharacter, second.profile);
    expect(gameState.currentScenarioIndex, 0);
    expect(gameState.pendingFeedback, isNull);
    expect(gameState.selectedChoiceHistory, isEmpty);
    expect(gameState.completedTasks, isEmpty);
    expect(gameState.appliedTags, isEmpty);
    expect(gameState.energy, second.profile.initialEnergy);
  });

  test(
    'choices and scenario transitions cannot run outside an active game',
    () {
      final gameState = GameState();
      final registration = registeredCharacters.first;
      final choice = registration.scenarios.first.choices.first;

      gameState.applyChoice(choice);
      gameState.advanceScenario();
      expect(gameState.selectedChoiceHistory, isEmpty);
      expect(gameState.currentScenarioIndex, 0);

      gameState.selectCharacter(registration.profile, registration.scenarios);
      gameState.applyChoice(choice);
      final energyAfterChoice = gameState.energy;
      gameState.applyChoice(choice);
      expect(gameState.energy, energyAfterChoice);
      gameState.advanceScenario();
      expect(gameState.currentScenarioIndex, 1);

      _completeGame(gameState);
      gameState.advanceScenario();
      expect(gameState.currentScenarioIndex, registration.scenarios.length - 1);
    },
  );
}

void _completeGame(GameState gameState) {
  while (!gameState.hasCompletedGame) {
    final scenario = gameState.activeScenarios[gameState.currentScenarioIndex];
    final choice = scenario.choices.firstWhere(gameState.isChoiceAvailable);
    gameState.applyChoice(choice);
    expect(gameState.pendingFeedback, isNotNull);
    gameState.advanceScenario();
  }
}

void _expectClearedSession(
  GameState gameState, {
  required bool preserveReducedEffects,
}) {
  expect(gameState.sessionStatus, GameSessionStatus.unselected);
  expect(gameState.selectedCharacter, isNull);
  expect(gameState.activeScenarios, isEmpty);
  expect(gameState.currentScenarioIndex, 0);
  expect(gameState.pendingFeedback, isNull);
  expect(gameState.lastChoiceLabel, isNull);
  expect(gameState.selectedChoiceHistory, isEmpty);
  expect(gameState.completedTasks, isEmpty);
  expect(gameState.appliedTags, isEmpty);
  expect(gameState.isFinished, isFalse);
  expect(gameState.timeMinutes, 480);
  expect(gameState.reduceVisualEffects, preserveReducedEffects);
}
