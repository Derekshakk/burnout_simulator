import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/widgets/scenario_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final registration in registeredCharacters) {
    testWidgets('scenario prompt uses ${registration.profile.name}\'s name', (
      tester,
    ) async {
      await _expectScenarioPrompt(tester, registration: registration);
    });
  }
}

Future<void> _expectScenarioPrompt(
  WidgetTester tester, {
  required RegisteredCharacter registration,
}) async {
  final gameState = GameState();
  gameState.selectCharacter(registration.profile, registration.scenarios);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ScenarioCard(
          scenario: registration.scenarios.first,
          scenarioNumber: 1,
          totalScenarios: registration.scenarios.length,
          characterName: gameState.selectedCharacter!.name,
        ),
      ),
    ),
  );

  expect(
    find.text('What should ${gameState.selectedCharacter!.name} do?'),
    findsOneWidget,
  );
}
