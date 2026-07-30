import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/character_profile.dart';
import 'package:burnout_simulator/models/game_choice.dart';
import 'package:burnout_simulator/models/game_scenario.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/screens/results_screen.dart';
import 'package:burnout_simulator/widgets/character_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final registration in registeredCharacters) {
    testWidgets(
      '${registration.profile.name} uses the shared results portrait at each breakpoint',
      (tester) async {
        final gameState = _completedState(registration);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        for (final layout in const [
          (width: 1440.0, portrait: Size(120, 156), showsStateVisual: true),
          (width: 900.0, portrait: Size(104, 136), showsStateVisual: false),
          (width: 360.0, portrait: Size(96, 128), showsStateVisual: false),
        ]) {
          tester.view.physicalSize = Size(layout.width, 1000);
          await tester.pumpWidget(_resultsApp(gameState: gameState));
          await tester.pumpAndSettle();

          final portrait = tester.widget<CharacterPortrait>(
            find.byType(CharacterPortrait),
          );
          expect(portrait.width, layout.portrait.width);
          expect(portrait.height, layout.portrait.height);
          expect(portrait.fit, BoxFit.contain);
          expect(
            find.bySemanticsLabel('Portrait of ${registration.profile.name}'),
            findsOneWidget,
          );
          expect(
            find.text('END-OF-DAY STATE'),
            layout.showsStateVisual ? findsOneWidget : findsNothing,
          );
          if (layout.showsStateVisual) {
            final appearance = registration.profile.appearance!;
            expect(
              _figureColor(tester, 'condition-figure-hair'),
              appearance.hairColor,
            );
            expect(
              _figureColor(tester, 'condition-figure-head'),
              appearance.skinTone,
            );
            expect(
              _figureColor(tester, 'condition-figure-top'),
              appearance.topColor.withValues(
                alpha: _topOpacity(gameState.burnoutLevel),
              ),
            );
          }
          expect(tester.takeException(), isNull);
        }
      },
    );
  }

  for (final condition in const [
    (name: 'manageable', energy: 100.0, stress: 0.0, label: 'Manageable'),
    (name: 'running low', energy: 50.0, stress: 50.0, label: 'Running low'),
    (name: 'depleted', energy: 0.0, stress: 100.0, label: 'Depleted'),
  ]) {
    testWidgets(
      'the $condition.name condition remains distinct from the portrait',
      (tester) async {
        final gameState = _conditionState(
          energy: condition.energy,
          stress: condition.stress,
        );
        tester.view.physicalSize = const Size(1440, 1000);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(_resultsApp(gameState: gameState));
        await tester.pumpAndSettle();

        expect(
          find.bySemanticsLabel('Portrait of Test Character'),
          findsOneWidget,
        );
        expect(find.text('END-OF-DAY STATE'), findsOneWidget);
        expect(find.text(condition.label), findsOneWidget);
        expect(
          _figureColor(tester, 'condition-figure-hair'),
          CharacterAppearance.neutral.hairColor,
        );
        expect(
          _figureColor(tester, 'condition-figure-head'),
          CharacterAppearance.neutral.skinTone,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}

GameState _completedState(RegisteredCharacter registration) {
  final gameState = GameState();
  gameState.selectCharacter(registration.profile, registration.scenarios);
  while (!gameState.hasCompletedGame) {
    final scenario = gameState.activeScenarios[gameState.currentScenarioIndex];
    gameState.applyChoice(
      scenario.choices.firstWhere(gameState.isChoiceAvailable),
    );
    gameState.advanceScenario();
  }
  return gameState;
}

GameState _conditionState({required double energy, required double stress}) {
  final character = CharacterProfile(
    id: 'test',
    name: 'Test Character',
    age: 16,
    context: 'High school student',
    gender: 'Not specified',
    pronouns: 'they/them',
    shortDescription: 'Test profile.',
    neurodivergenceType: 'Test',
    strengths: const [],
    burnoutTriggers: const [],
    recoveryStrategies: const [],
    supportiveStrategies: const [],
    lowEnergyActivity: 'Rest',
    highEnergyActivity: 'Activity',
    disclaimer: 'Test disclaimer.',
    initialEnergy: energy,
    initialStress: stress,
    initialMotivation: energy,
    initialSelfAdvocacy: energy,
    portraitImagePath: 'assets/characters/alex.jpg',
  );
  const scenario = GameScenario(
    id: 'test',
    title: 'Test',
    timeLabel: '8:00 AM',
    description: 'Test.',
    narration: 'Test.',
    choices: [
      GameChoice(
        id: 'test',
        label: 'Test',
        description: 'Test.',
        educationalFeedback: 'Test.',
      ),
    ],
  );
  return GameState()..selectCharacter(character, const [scenario]);
}

Widget _resultsApp({required GameState gameState}) =>
    MaterialApp(home: ResultsScreen(gameState: gameState));

Color _figureColor(WidgetTester tester, String key) =>
    tester.widget<Container>(find.byKey(ValueKey(key))).color!;

double _topOpacity(double burnoutLevel) {
  if (burnoutLevel >= 70) return 0.45;
  if (burnoutLevel >= 40) return 0.6;
  return 0.75;
}
