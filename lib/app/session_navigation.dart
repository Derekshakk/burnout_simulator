import 'package:flutter/material.dart';

import '../models/game_state.dart';
import 'routes.dart';

/// Navigation intents for the simulation lifecycle.
///
/// Screens should use these methods instead of pushing lifecycle routes
/// directly. Each intent owns the appropriate session transition and removes
/// obsolete routes, so browser back/forward cannot reveal a stale game.
class SessionNavigation {
  const SessionNavigation._();

  static void startNewGame(BuildContext context, GameState gameState) {
    gameState.beginNewSession();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.select, (_) => false);
  }

  static void chooseCharacter(BuildContext context, GameState gameState) {
    gameState.beginNewSession();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.select, (_) => false);
  }

  static void goHome(BuildContext context, GameState gameState) {
    gameState.endSession();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  static void goAbout(BuildContext context, GameState gameState) {
    gameState.endSession();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.about, (_) => false);
  }

  /// Opens a named section on the public home page as a single navigation
  /// entry, so it also works from the game and from direct web URLs.
  static void goHomeSection(
    BuildContext context,
    GameState gameState,
    String sectionRoute,
  ) {
    gameState.endSession();
    Navigator.pushNamedAndRemoveUntil(context, sectionRoute, (_) => false);
  }

  static void openPlay(BuildContext context, GameState gameState) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      gameState.routeFor(AppRoutes.play),
      (_) => false,
    );
  }

  static void openResults(BuildContext context, GameState gameState) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      gameState.routeFor(AppRoutes.results),
      (_) => false,
    );
  }
}
