import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/screens/simulation_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('scenario progress remains visible while feedback is shown', (
    tester,
  ) async {
    final registration = registeredCharacters.first;
    final gameState = GameState();
    gameState.selectCharacter(registration.profile, registration.scenarios);

    await tester.pumpWidget(
      MaterialApp(home: SimulationScreen(gameState: gameState)),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Scenario 1 of ${registration.scenarios.length}'),
      findsOneWidget,
    );

    gameState.applyChoice(registration.scenarios.first.choices.first);
    await tester.pumpAndSettle();

    expect(find.text('WHAT HAPPENED'), findsOneWidget);
    expect(
      find.text('Scenario 1 of ${registration.scenarios.length}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
