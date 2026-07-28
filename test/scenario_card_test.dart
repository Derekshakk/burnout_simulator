import 'package:burnout_simulator/data/alex_scenarios.dart';
import 'package:burnout_simulator/data/demo_character.dart';
import 'package:burnout_simulator/data/jordan_character.dart';
import 'package:burnout_simulator/data/jordan_scenarios.dart';
import 'package:burnout_simulator/models/character_profile.dart';
import 'package:burnout_simulator/models/game_scenario.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/widgets/scenario_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('scenario prompt uses the selected character name', (
    tester,
  ) async {
    await _expectScenarioPrompt(
      tester,
      character: demoCharacter,
      scenarios: alexScenarios,
    );
    await _expectScenarioPrompt(
      tester,
      character: jordanCharacter,
      scenarios: jordanScenarios,
    );
  });
}

Future<void> _expectScenarioPrompt(
  WidgetTester tester, {
  required CharacterProfile character,
  required List<GameScenario> scenarios,
}) async {
  final gameState = GameState();
  gameState.selectCharacter(character, scenarios);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: ScenarioCard(
          scenario: scenarios.first,
          scenarioNumber: 1,
          totalScenarios: scenarios.length,
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
