import 'package:burnout_simulator/app/routes.dart';
import 'package:burnout_simulator/app/session_navigation.dart';
import 'package:burnout_simulator/data/character_registry.dart';
import 'package:burnout_simulator/models/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final registration in registeredCharacters) {
    testWidgets(
      '${registration.profile.name} cannot return to a stale route after reset',
      (tester) async {
        final gameState = GameState();
        final navigatorKey = GlobalKey<NavigatorState>();

        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            initialRoute: AppRoutes.home,
            onGenerateRoute: (settings) {
              final route = gameState.routeFor(settings.name ?? AppRoutes.home);
              return MaterialPageRoute<void>(
                settings: RouteSettings(name: route),
                builder: (_) => Scaffold(body: Text(route)),
              );
            },
          ),
        );

        SessionNavigation.startNewGame(navigatorKey.currentContext!, gameState);
        await tester.pumpAndSettle();
        _expectOnlyRoute(tester, AppRoutes.select, navigatorKey);

        gameState.selectCharacter(registration.profile, registration.scenarios);
        SessionNavigation.openPlay(navigatorKey.currentContext!, gameState);
        await tester.pumpAndSettle();
        _expectOnlyRoute(tester, AppRoutes.play, navigatorKey);

        _completeGame(gameState);
        SessionNavigation.openResults(navigatorKey.currentContext!, gameState);
        await tester.pumpAndSettle();
        _expectOnlyRoute(tester, AppRoutes.results, navigatorKey);

        SessionNavigation.goHome(navigatorKey.currentContext!, gameState);
        await tester.pumpAndSettle();
        _expectOnlyRoute(tester, AppRoutes.home, navigatorKey);
        expect(gameState.sessionStatus, GameSessionStatus.unselected);
        expect(await tester.binding.handlePopRoute(), isFalse);
      },
    );
  }
}

void _expectOnlyRoute(
  WidgetTester tester,
  String route,
  GlobalKey<NavigatorState> navigatorKey,
) {
  expect(find.text(route), findsOneWidget);
  expect(navigatorKey.currentState!.canPop(), isFalse);
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
