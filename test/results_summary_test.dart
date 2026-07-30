import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/screens/results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Results classifies Maya and shared-accommodation strategies', (
    tester,
  ) async {
    final registration = registeredCharacters.singleWhere(
      (entry) => entry.profile.id == 'maya',
    );
    final gameState = GameState();
    gameState.selectCharacter(registration.profile, registration.scenarios);

    while (!gameState.hasCompletedGame) {
      final scenario =
          gameState.activeScenarios[gameState.currentScenarioIndex];
      gameState.applyChoice(scenario.choices.first);
      gameState.advanceScenario();
    }

    await tester.pumpWidget(
      MaterialApp(home: ResultsScreen(gameState: gameState)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Choices that preserved capacity'), findsOneWidget);
    expect(find.text('Choices that added to the daily load'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
