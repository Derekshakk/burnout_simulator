import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:burnout_simulator/app/app.dart';
import 'package:burnout_simulator/app/theme.dart';
import 'package:burnout_simulator/accessibility/accessibility_panel.dart';
import 'package:burnout_simulator/accessibility/accessibility_scope.dart';
import 'package:burnout_simulator/accessibility/accessibility_state.dart';
import 'package:burnout_simulator/accessibility/a11y_widgets.dart';
import 'package:burnout_simulator/accessibility/selective_bold_text.dart';
import 'package:burnout_simulator/accessibility/tts_controller.dart';

void main() {
  setUp(() {
    // AccessibilityState.initialize() reads SharedPreferences; provide a mock
    // store so the app leaves its loading state during tests.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const BurnoutSimulatorApp());
    await tester.pumpAndSettle();
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets(
    'Accessibility panel opens without an Overlay error and shows its Tooltips',
    (WidgetTester tester) async {
      await tester.pumpWidget(const BurnoutSimulatorApp());
      await tester.pumpAndSettle();

      // Open the panel via the floating accessibility button.
      expect(find.byIcon(Icons.accessibility_new), findsOneWidget);
      await tester.tap(find.byIcon(Icons.accessibility_new));
      await tester.pumpAndSettle();

      // Panel is now beneath the Navigator's Overlay — title is visible and
      // the close-button Tooltip built without throwing "No Overlay widget".
      expect(find.text('Accessibility Preferences'), findsOneWidget);
      expect(find.byType(Tooltip), findsWidgets);
      expect(tester.takeException(), isNull);

      // Close with Escape and reopen to confirm it is repeatable.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Accessibility Preferences'), findsNothing);

      await tester.tap(find.byIcon(Icons.accessibility_new));
      await tester.pumpAndSettle();
      expect(find.text('Accessibility Preferences'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Accessibility panel lays out without overflow when narrow', (
    WidgetTester tester,
  ) async {
    final a11y = AccessibilityState();
    final tts = TtsController();
    addTearDown(tts.dispose);

    // Mount the panel in isolation at a very narrow width (single-column mode).
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomRight,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: AccessibilityPanel(
                a11y: a11y,
                tts: tts,
                onClose: () {},
                getPageText: () => 'sample',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Accessibility Preferences'), findsOneWidget);
    // Any RenderFlex overflow would surface here as a caught exception.
    expect(tester.takeException(), isNull);
  });

  // Helper: mount a widget under a real AccessibilityScope so leaf widgets can
  // read/apply preferences.
  Future<AccessibilityState> pumpScoped(
    WidgetTester tester,
    Widget child,
  ) async {
    final a11y = AccessibilityState();
    await tester.pumpWidget(
      AccessibilityScope(
        state: a11y,
        child: MaterialApp(home: Scaffold(body: child)),
      ),
    );
    return a11y;
  }

  testWidgets('Text alignment: ReadingText applies the chosen alignment', (
    WidgetTester tester,
  ) async {
    final a11y = await pumpScoped(
      tester,
      const ReadingText('some reading content here'),
    );
    // Default is TextAlign.start (equivalent to the untouched left layout).
    expect(
      (tester.widget(find.byType(Text)) as Text).textAlign,
      TextAlign.start,
    );

    a11y.setTextAlign(TextAlign.center);
    await tester.pump();
    expect(
      (tester.widget(find.byType(Text)) as Text).textAlign,
      TextAlign.center,
    );

    a11y.setTextAlign(TextAlign.right);
    await tester.pump();
    expect(
      (tester.widget(find.byType(Text)) as Text).textAlign,
      TextAlign.right,
    );
  });

  testWidgets('Selective Bolding: ReadingText switches renderer on toggle', (
    WidgetTester tester,
  ) async {
    final a11y = await pumpScoped(
      tester,
      const ReadingText('understand something important today'),
    );
    expect(find.byType(SelectiveBoldText), findsNothing);

    a11y.toggleSelectiveBolding();
    await tester.pump();
    expect(find.byType(SelectiveBoldText), findsOneWidget);
    // Original text is preserved for screen readers.
    expect(
      find.bySemanticsLabel('understand something important today'),
      findsOneWidget,
    );
  });

  testWidgets('Highlight Titles: A11yHeading gains emphasis on toggle', (
    WidgetTester tester,
  ) async {
    final a11y = await pumpScoped(
      tester,
      const A11yHeading(
        'Section Heading',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
    expect(find.byType(DecoratedBox), findsNothing);

    a11y.toggleHighlightTitles();
    await tester.pump();
    expect(find.byType(DecoratedBox), findsWidgets);
  });

  testWidgets('Readable Font: theme uses the readable family when enabled', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'a11y_readableFont': true});
    await tester.pumpWidget(const BurnoutSimulatorApp());
    await tester.pumpAndSettle();

    final ctx = tester.element(find.byType(Scaffold).first);
    expect(Theme.of(ctx).textTheme.bodyMedium?.fontFamily, 'Verdana');
    expect(
      Theme.of(ctx).textTheme.bodyMedium?.fontFamilyFallback,
      contains('sans-serif'),
    );
  });

  testWidgets('High Contrast recolors the app when toggled from the panel', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    addTearDown(() => AppColors.highContrast = false);

    await tester.pumpWidget(const BurnoutSimulatorApp());
    await tester.pumpAndSettle();

    expect(AppColors.highContrast, isFalse);
    final bgBefore = tester
        .widget<Scaffold>(find.byType(Scaffold).first)
        .backgroundColor;

    await tester.tap(find.byIcon(Icons.accessibility_new));
    await tester.pumpAndSettle();
    final highContrastControl = find.text('High Contrast');
    await tester.ensureVisible(highContrastControl);
    await tester.tap(highContrastControl);
    await tester.pumpAndSettle();

    // Palette swapped and the underlying screen rebuilt with the new color.
    expect(AppColors.highContrast, isTrue);
    final bgAfter = tester
        .widget<Scaffold>(find.byType(Scaffold).first)
        .backgroundColor;
    expect(bgAfter, isNot(bgBefore));
    expect(bgAfter, const Color(0xFF000000));
    expect(tester.takeException(), isNull);
  });

  testWidgets('High Contrast persists across navigation to Play', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({'a11y_highContrast': true});
    addTearDown(() => AppColors.highContrast = false);

    await tester.pumpWidget(const BurnoutSimulatorApp());
    await tester.pumpAndSettle();
    expect(AppColors.highContrast, isTrue);

    // Start the simulation; the setting must remain active on the new route.
    await tester.tap(find.text('Play Game').first);
    await tester.pumpAndSettle();
    expect(AppColors.highContrast, isTrue);
    expect(tester.takeException(), isNull);
  });
}
