import 'package:flutter/material.dart';
import '../accessibility/accessibility_overlay.dart';
import '../accessibility/accessibility_state.dart';
import '../models/game_state.dart';
import '../screens/character_select_screen.dart';
import '../screens/game_overview_screen.dart';
import '../screens/home_screen.dart';
import '../screens/how_burnout_works_screen.dart';
import '../screens/results_screen.dart';
import '../screens/simulation_screen.dart';
import '../screens/podcasts_screen.dart';
import '../screens/team_screen.dart';
import '../screens/testimonials_screen.dart';
import 'routes.dart';
import 'theme.dart';

class BurnoutSimulatorApp extends StatefulWidget {
  const BurnoutSimulatorApp({super.key});

  @override
  State<BurnoutSimulatorApp> createState() => _BurnoutSimulatorAppState();
}

class _BurnoutSimulatorAppState extends State<BurnoutSimulatorApp> {
  final GameState _gameState = GameState();
  final AccessibilityState _a11y = AccessibilityState();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  bool _a11yReady = false;

  @override
  void initState() {
    super.initState();
    _a11y.initialize().then((_) {
      if (mounted) setState(() => _a11yReady = true);
    });
  }

  @override
  void dispose() {
    _gameState.dispose();
    _a11y.dispose();
    super.dispose();
  }

  ThemeData _buildTheme() {
    // AppColors.highContrast is synced before build() runs the tree, so the
    // theme (and every AppColors.* read) reflects the current mode.
    return AppTheme.withA11y(AppTheme.themeData, _a11y);
  }

  /// Wraps a route's screen so it rebuilds whenever accessibility state changes.
  /// This is what makes High Contrast / Readable Font repaint the whole screen:
  /// the screens read hard-coded `AppColors.*`, so they must rebuild to pick up
  /// the swapped palette. State (and navigation) is preserved because the same
  /// element is reused across rebuilds.
  Widget _a11yRoute(Widget Function() buildScreen) {
    return ListenableBuilder(
      listenable: _a11y,
      // Keep the initial navigator route alive while preferences load. Replacing
      // MaterialApp with a temporary splash app loses a direct web URL before
      // its route can be generated.
      builder: (_, _) => _a11yReady
          ? buildScreen()
          : Scaffold(
              backgroundColor: AppColors.background,
              body: const SizedBox.shrink(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _a11y,
      builder: (_, _) {
        // Sync the global palette flag BEFORE the tree (theme + screens) builds,
        // so every AppColors.* read resolves to the correct palette this frame.
        AppColors.highContrast = _a11y.highContrast;
        Route<dynamic> generateRoute(RouteSettings settings) {
          final requestedRoute = settings.name ?? AppRoutes.home;
          final knownRoutes = {
            AppRoutes.home,
            AppRoutes.about,
            AppRoutes.select,
            AppRoutes.play,
            AppRoutes.results,
            AppRoutes.burnout,
            AppRoutes.resources,
            AppRoutes.team,
            AppRoutes.contact,
            AppRoutes.podcasts,
            AppRoutes.testimonials,
          };
          final route = knownRoutes.contains(requestedRoute)
              ? _gameState.routeFor(requestedRoute)
              : AppRoutes.home;
          // A public or character-selection route is a session boundary.
          // This also covers direct URLs and browser history entries that
          // bypass the screen-level navigation intents.
          if (route == AppRoutes.home ||
              route == AppRoutes.about ||
              route == AppRoutes.select ||
              route == AppRoutes.burnout ||
              route == AppRoutes.resources ||
              route == AppRoutes.team ||
              route == AppRoutes.contact ||
              route == AppRoutes.podcasts ||
              route == AppRoutes.testimonials) {
            _gameState.endSession();
          }
          final effectiveSettings = RouteSettings(name: route);
          switch (route) {
            case AppRoutes.home:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => HomeScreen(gameState: _gameState)),
              );
            case AppRoutes.about:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => GameOverviewScreen(gameState: _gameState)),
              );
            case AppRoutes.burnout:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) => _a11yRoute(
                  () => HowBurnoutWorksScreen(gameState: _gameState),
                ),
              );
            case AppRoutes.team:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => TeamScreen(gameState: _gameState)),
              );
            case AppRoutes.podcasts:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => PodcastsScreen(gameState: _gameState)),
              );
            case AppRoutes.testimonials:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => TestimonialsScreen(gameState: _gameState)),
              );
            case AppRoutes.resources:
            case AppRoutes.contact:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) => _a11yRoute(
                  () => HomeScreen(
                    gameState: _gameState,
                    initialSection: route.substring(1),
                  ),
                ),
              );
            case AppRoutes.select:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) => _a11yRoute(
                  () => CharacterSelectScreen(gameState: _gameState),
                ),
              );
            case AppRoutes.play:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => SimulationScreen(gameState: _gameState)),
              );
            case AppRoutes.results:
              return MaterialPageRoute(
                settings: effectiveSettings,
                builder: (_) =>
                    _a11yRoute(() => ResultsScreen(gameState: _gameState)),
              );
            default:
              return MaterialPageRoute(
                settings: const RouteSettings(name: AppRoutes.home),
                builder: (_) =>
                    _a11yRoute(() => HomeScreen(gameState: _gameState)),
              );
          }
        }

        return MediaQuery(
          // Apply font-size scaling globally via the Flutter text scaler
          data: MediaQueryData.fromView(
            WidgetsBinding.instance.platformDispatcher.views.first,
          ).copyWith(textScaler: TextScaler.linear(_a11y.fontSizeScale)),
          child: MaterialApp(
            title: 'Project Ignite',
            debugShowCheckedModeBanner: false,
            theme: _buildTheme(),
            navigatorKey: _navigatorKey,
            builder: (context, child) {
              // Note: typography (line height, letter spacing, readable font)
              // is applied through the theme's textTheme in AppTheme.withA11y —
              // that survives the Material inside each Scaffold. Text alignment
              // is applied per reading widget (ReadingText/A11yHeading) for the
              // same reason. This DefaultTextStyle only covers any stray text
              // rendered outside a Material.
              final routeChild = DefaultTextStyle(
                style: DefaultTextStyle.of(context).style.copyWith(
                  height: (1.4 * _a11y.lineHeightScale).clamp(0.8, 3.0),
                  letterSpacing: _a11y.letterSpacingDelta.clamp(-0.5, 8.0),
                  fontFamily: _a11y.readableFont
                      ? AppTheme.readableFontFamily
                      : null,
                  fontFamilyFallback: _a11y.readableFont
                      ? AppTheme.readableFontFallback
                      : null,
                ),
                child: child!,
              );
              // Keep the direct route mounted but avoid rendering content with
              // temporary default preferences before they are restored.
              if (!_a11yReady) return routeChild;
              return AccessibilityOverlay(
                a11yState: _a11y,
                navigatorKey: _navigatorKey,
                child: routeChild,
              );
            },
            // Use the platform route so direct web URLs flow through the same
            // lifecycle guards as in-app navigation.
            initialRoute:
                WidgetsBinding.instance.platformDispatcher.defaultRouteName,
            // A deep link must be a single route. The Material default creates
            // both '/' and the requested route, which makes browser Back reveal
            // a page the visitor did not navigate from.
            onGenerateInitialRoutes: (initialRoute) => [
              generateRoute(RouteSettings(name: initialRoute)),
            ],
            onGenerateRoute: generateRoute,
          ),
        );
      },
    );
  }
}
