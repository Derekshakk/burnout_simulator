import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/screens/results_screen.dart';
import 'package:burnout_simulator/screens/simulation_screen.dart';
import 'package:burnout_simulator/widgets/choice_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final registration in registeredCharacters) {
    testWidgets(
      '${registration.profile.name} simulation and results fit a narrow, enlarged-text layout',
      (tester) async {
        final gameState = GameState();
        gameState.selectCharacter(registration.profile, registration.scenarios);

        await tester.pumpWidget(
          _responsiveApp(SimulationScreen(gameState: gameState)),
        );
        await tester.pumpAndSettle();
        expect(find.byType(ChoiceButton), findsWidgets);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump();
        _completeGame(gameState);
        await tester.pumpWidget(
          _responsiveApp(ResultsScreen(gameState: gameState)),
        );
        await tester.pumpAndSettle();
        expect(find.text('END OF DAY — RESULTS'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Widget _responsiveApp(Widget home) {
  return MaterialApp(
    home: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: 360,
        height: 800,
        child: MediaQuery(
          data: const MediaQueryData(
            size: Size(360, 800),
            textScaler: TextScaler.linear(1.5),
          ),
          child: home,
        ),
      ),
    ),
  );
}

void _completeGame(GameState gameState) {
  while (!gameState.hasCompletedGame) {
    final scenario = gameState.activeScenarios[gameState.currentScenarioIndex];
    gameState.applyChoice(
      scenario.choices.firstWhere(gameState.isChoiceAvailable),
    );
    gameState.advanceScenario();
  }
}
