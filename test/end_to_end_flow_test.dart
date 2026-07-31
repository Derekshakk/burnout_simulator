import 'package:burnout_simulator/app/app.dart';
import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/widgets/choice_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final registration in registeredCharacters) {
    testWidgets(
      '${registration.profile.name} completes the website flow and can replay',
      (tester) async {
        await tester.pumpWidget(const BurnoutSimulatorApp());
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Play Game'));
        await tester.pumpAndSettle();

        final characterButton = find.widgetWithText(
          ElevatedButton,
          'Play as ${registration.profile.name}',
        );
        await tester.ensureVisible(characterButton);
        await tester.tap(characterButton);
        await tester.pumpAndSettle();

        for (
          var scenario = 0;
          scenario < registration.scenarios.length;
          scenario++
        ) {
          final availableChoice = find.byWidgetPredicate(
            (widget) => widget is ChoiceButton && !widget.isDisabled,
          );
          expect(availableChoice, findsWidgets);
          await tester.ensureVisible(availableChoice.first);
          await tester.tap(availableChoice.first);
          await tester.pumpAndSettle();

          expect(find.text('WHAT HAPPENED'), findsOneWidget);
          final continueButton = find.widgetWithText(
            ElevatedButton,
            scenario + 1 == registration.scenarios.length
                ? 'See Results'
                : 'Continue',
          );
          await tester.ensureVisible(continueButton);
          await tester.tap(continueButton);
          await tester.pumpAndSettle();
        }

        expect(find.text('END OF DAY — RESULTS'), findsOneWidget);
        expect(
          find.text('${registration.profile.name}\'s Day is Complete'),
          findsOneWidget,
        );
        expect(find.text('Share Feedback or Suggestions'), findsOneWidget);

        final replayButton = find.widgetWithText(
          ElevatedButton,
          'Choose a Character',
        );
        await tester.ensureVisible(replayButton);
        await tester.tap(replayButton);
        await tester.pumpAndSettle();
        expect(find.text('Who will you guide today?'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
