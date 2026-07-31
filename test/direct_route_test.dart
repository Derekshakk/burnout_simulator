import 'package:burnout_simulator/app/app.dart';
import 'package:burnout_simulator/app/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  for (final entry in <({String route, String expectedText})>[
    (route: AppRoutes.home, expectedText: 'EDUCATIONAL SIMULATION'),
    (route: AppRoutes.about, expectedText: 'ABOUT THE GAME'),
    (route: AppRoutes.select, expectedText: 'CHOOSE YOUR CHARACTER'),
    (route: AppRoutes.team, expectedText: 'MEET THE TEAM'),
    (route: AppRoutes.contact, expectedText: 'CONTACT / FEEDBACK'),
  ]) {
    testWidgets('direct ${entry.route} opens its public page', (tester) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue = entry.route;
      addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
      );

      await tester.pumpWidget(const BurnoutSimulatorApp());
      await tester.pumpAndSettle();

      expect(find.text(entry.expectedText), findsOneWidget);
      if (entry.route == AppRoutes.contact) {
        expect(find.text('Share Feedback or Suggestions'), findsOneWidget);
      }
      expect(
        Navigator.of(tester.element(find.text(entry.expectedText))).canPop(),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    });
  }

  for (final guardedRoute in <String>[AppRoutes.play, AppRoutes.results]) {
    testWidgets('direct $guardedRoute starts at character selection', (
      tester,
    ) async {
      tester.binding.platformDispatcher.defaultRouteNameTestValue =
          guardedRoute;
      addTearDown(
        tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
      );

      await tester.pumpWidget(const BurnoutSimulatorApp());
      await tester.pumpAndSettle();

      expect(find.text('CHOOSE YOUR CHARACTER'), findsOneWidget);
      expect(
        Navigator.of(
          tester.element(find.text('CHOOSE YOUR CHARACTER')),
        ).canPop(),
        isFalse,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('an unknown direct URL returns to the public home page', (
    tester,
  ) async {
    tester.binding.platformDispatcher.defaultRouteNameTestValue = '/missing';
    addTearDown(
      tester.binding.platformDispatcher.clearDefaultRouteNameTestValue,
    );

    await tester.pumpWidget(const BurnoutSimulatorApp());
    await tester.pumpAndSettle();

    expect(find.text('EDUCATIONAL SIMULATION'), findsOneWidget);
    expect(
      Navigator.of(
        tester.element(find.text('EDUCATIONAL SIMULATION')),
      ).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });
}
