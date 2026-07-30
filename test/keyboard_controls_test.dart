import 'package:burnout_simulator/app/routes.dart';
import 'package:burnout_simulator/app/app.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/models/game_choice.dart';
import 'package:burnout_simulator/app/theme.dart';
import 'package:burnout_simulator/accessibility/a11y_widgets.dart';
import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/widgets/choice_button.dart';
import 'package:burnout_simulator/widgets/site_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const choice = GameChoice(
    id: 'keyboard_choice',
    label: 'Choose the accessible option',
    description: 'A choice used to verify keyboard activation.',
    educationalFeedback: 'Feedback',
  );

  testWidgets('choice buttons activate with Enter and Space', (tester) async {
    var activationCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChoiceButton(
            choice: choice,
            choiceLetter: 'A',
            onPressed: () => activationCount++,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(activationCount, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(activationCount, 2);
  });

  testWidgets('disabled choice buttons cannot be keyboard activated', (
    tester,
  ) async {
    var activationCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChoiceButton(
            choice: choice,
            choiceLetter: 'A',
            isDisabled: true,
            onPressed: () => activationCount++,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(activationCount, 0);
  });

  testWidgets('disabled choice copy uses the dedicated readable token', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ChoiceButton(
            choice: choice,
            choiceLetter: 'A',
            isDisabled: true,
            disabledReason: 'This option needs more available energy.',
          ),
        ),
      ),
    );

    final reason = tester.widget<Text>(
      find.text('This option needs more available energy.'),
    );
    expect(reason.style?.color, AppColors.disabledText);
  });

  testWidgets('focused Play Game control keeps readable text contrast', (
    tester,
  ) async {
    addTearDown(() => AppColors.highContrast = false);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SiteNavigation(
            activeSection: AppRoutes.home,
            gameState: GameState(),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();

    // When the Play button is focused its bg becomes coral. The text must be
    // dark (textPrimary = charcoal) for 7.6:1 contrast — not background (cream).
    final playLabel = tester.widget<Text>(find.text('Play Game'));
    expect(playLabel.style?.color, AppColors.textPrimary);
  });

  testWidgets('accessible links activate with Enter and Space', (tester) async {
    var activationCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: A11yLink(label: 'Read more', onTap: () => activationCount++),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);

    expect(activationCount, 2);
  });

  testWidgets('accessibility preference toggles remain keyboard operable', (
    tester,
  ) async {
    addTearDown(() => AppColors.highContrast = false);
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const BurnoutSimulatorApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.accessibility_new));
    await tester.pumpAndSettle();

    final highContrast = find.text('High Contrast');
    await tester.ensureVisible(highContrast);
    await tester.tap(highContrast);
    await tester.pumpAndSettle();
    expect(AppColors.highContrast, isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(AppColors.highContrast, isFalse);
  });

  testWidgets('desktop navigation links activate with Enter', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final gameState = GameState();
    final registration = registeredCharacters.first;
    gameState.selectCharacter(registration.profile, registration.scenarios);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SiteNavigation(
            activeSection: AppRoutes.about,
            gameState: gameState,
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(gameState.sessionStatus, GameSessionStatus.unselected);
  });
}
