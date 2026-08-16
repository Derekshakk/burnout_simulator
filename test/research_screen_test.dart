import 'package:burnout_simulator/models/game_state.dart';
import 'package:burnout_simulator/screens/research_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('research tabs switch content', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: ResearchScreen(gameState: GameState())),
    );

    expect(find.text('Universal Design for Learning'), findsOneWidget);

    final autisticBurnoutTab = find.text('Autistic Burnout');
    expect(autisticBurnoutTab, findsOneWidget);
    await tester.ensureVisible(autisticBurnoutTab);
    await tester.tap(autisticBurnoutTab);
    await tester.pumpAndSettle();

    expect(find.text('What Is Autistic Burnout?'), findsOneWidget);
    expect(find.text('Universal Design for Learning'), findsNothing);

    final adhdBurnoutTab = find.text('ADHD Burnout');
    expect(adhdBurnoutTab, findsOneWidget);
    await tester.ensureVisible(adhdBurnoutTab);
    await tester.tap(adhdBurnoutTab);
    await tester.pumpAndSettle();

    expect(find.text('What Is ADHD Burnout?'), findsOneWidget);
    expect(find.text('What causes ADHD burnout?'), findsOneWidget);
    expect(find.text('How to prevent ADHD burnout?'), findsOneWidget);
    expect(
      find.text('What are tools to alleviate ADHD burnout?'),
      findsOneWidget,
    );
    expect(find.text('Content coming soon'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'research remains overflow-free on a narrow enlarged-text layout',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
          child: MaterialApp(home: ResearchScreen(gameState: GameState())),
        ),
      );
      await tester.pumpAndSettle();

      final adhdBurnoutTab = find.text('ADHD Burnout');
      await tester.ensureVisible(adhdBurnoutTab);
      await tester.tap(adhdBurnoutTab);
      await tester.pumpAndSettle();

      expect(find.text('Research'), findsOneWidget);
      expect(find.text('What Is ADHD Burnout?'), findsOneWidget);
      expect(find.text('How to prevent ADHD burnout?'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
