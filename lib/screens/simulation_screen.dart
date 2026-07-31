import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/session_navigation.dart';
import '../app/theme.dart';
import '../models/game_scenario.dart';
import '../models/game_state.dart';
import '../models/scene_artwork.dart';
import '../widgets/character_portrait.dart';
import '../widgets/choice_button.dart';
import '../widgets/educational_feedback_card.dart';
import '../widgets/pixel_panel.dart';
import '../widgets/project_ignite_logo.dart';
import '../widgets/scenario_card.dart';
import '../widgets/status_meter.dart';

class SimulationScreen extends StatefulWidget {
  final GameState gameState;

  const SimulationScreen({super.key, required this.gameState});

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  @override
  void initState() {
    super.initState();
    widget.gameState.addListener(_onStateChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.gameState.selectedCharacter == null) {
        SessionNavigation.chooseCharacter(context, widget.gameState);
      }
    });
  }

  @override
  void dispose() {
    widget.gameState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (widget.gameState.isFinished && mounted) {
      SessionNavigation.openResults(context, widget.gameState);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.gameState,
      builder: (context, _) {
        final burnout = widget.gameState.burnoutLevel;
        final reduceFx = widget.gameState.reduceVisualEffects;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              Column(
                children: [
                  _SimNavBar(gameState: widget.gameState),
                  Expanded(child: _buildContent(context)),
                ],
              ),
              if (!reduceFx && burnout >= 40)
                _BurnoutOverlay(
                  burnoutLevel: burnout,
                  severe: widget.gameState.hasSevereOverload,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    if (isMobile) {
      return _MobileLayout(gameState: widget.gameState);
    }
    return _DesktopLayout(gameState: widget.gameState);
  }
}

class _SimNavBar extends StatelessWidget {
  final GameState gameState;

  const _SimNavBar({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.textSecondary,
                size: 18,
              ),
              tooltip: 'Return to home',
              onPressed: () => SessionNavigation.goHome(context, gameState),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: const ProjectIgniteLogo(height: 28),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: ListenableBuilder(
                  listenable: gameState,
                  builder: (_, child) =>
                      _TimeDisplay(time: gameState.currentTimeLabel),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeDisplay extends StatelessWidget {
  final String time;

  const _TimeDisplay({required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, color: AppColors.textMuted, size: 12),
          const SizedBox(width: 6),
          Text(
            time,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  final GameState gameState;

  const _DesktopLayout({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 280, child: _SidePanel(gameState: gameState)),
        VerticalDivider(color: AppColors.border, width: 1, thickness: 1),
        Expanded(child: _MainInteractionPanel(gameState: gameState)),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final GameState gameState;

  const _MobileLayout({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _MobileStatusBar(gameState: gameState),
          const SizedBox(height: 16),
          _ScenePanel(gameState: gameState, isMobile: true),
          const SizedBox(height: 16),
          _InteractionContent(gameState: gameState),
        ],
      ),
    );
  }
}

class _SidePanel extends StatelessWidget {
  final GameState gameState;

  const _SidePanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ScenePanel(gameState: gameState, isMobile: false),
            const SizedBox(height: 16),
            _StatusPanel(gameState: gameState),
          ],
        ),
      ),
    );
  }
}

class _ScenePanel extends StatelessWidget {
  final GameState gameState;
  final bool isMobile;

  const _ScenePanel({required this.gameState, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final scenarios = gameState.activeScenarios;
    if (scenarios.isEmpty) return const SizedBox.shrink();
    final scenario = scenarios[gameState.currentScenarioIndex];

    final semanticLabel =
        scenario.sceneSemanticLabel ??
        (scenario.sceneImagePath != null
            ? 'Scene illustration for ${scenario.title}'
            : 'Pixel art scene for scenario ${scenario.sceneTone}');

    return PixelPanel(
      title: 'SCENE',
      padding: EdgeInsets.zero,
      child: A11yImage(
        semanticLabel: semanticLabel,
        child: _SceneArtwork(
          sceneTone: scenario.sceneTone,
          sceneType: scenario.sceneType,
          preferredArtwork: scenario.sceneArtwork,
          selectedCharacterId: gameState.selectedCharacter!.id,
          burnoutLevel: gameState.burnoutLevel,
          reduceEffects: gameState.reduceVisualEffects,
          hasSensoryOverload: gameState.hasSensoryOverload,
          height: isMobile ? 160.0 : 200.0,
        ),
      ),
    );
  }
}

class _SceneArtwork extends StatelessWidget {
  final String sceneTone;
  final String sceneType;
  final SceneArtwork? preferredArtwork;
  final String selectedCharacterId;
  final double burnoutLevel;
  final bool reduceEffects;
  final bool hasSensoryOverload;
  final double height;

  const _SceneArtwork({
    required this.sceneTone,
    required this.sceneType,
    this.preferredArtwork,
    required this.selectedCharacterId,
    required this.burnoutLevel,
    required this.reduceEffects,
    required this.hasSensoryOverload,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final artwork = _assetOrFallback(
      SceneArtworkResolver.assetCandidates(
        preferredArtwork: preferredArtwork,
        selectedCharacterId: selectedCharacterId,
        sceneType: sceneType,
      ),
    );

    if (reduceEffects || burnoutLevel < 40) {
      return SizedBox(height: height, child: artwork);
    }

    final overlayOpacity = burnoutLevel < 70
        ? (burnoutLevel - 40) / 30 * 0.12
        : 0.12 + (burnoutLevel - 70) / 30 * 0.14;

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          artwork,
          Container(
            color: AppColors.illustrationBook.withValues(alpha: overlayOpacity),
          ),
          if (burnoutLevel >= 70)
            Positioned(top: 8, right: 8, child: _BrainFogBadge()),
          if (hasSensoryOverload)
            Positioned(top: 8, left: 8, child: _SensoryOverloadBadge()),
        ],
      ),
    );
  }

  Widget _assetOrFallback(List<String> assetPaths, [int index = 0]) {
    if (index >= assetPaths.length) return _pixelOrNeutralPlaceholder();
    return Image.asset(
      assetPaths[index],
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) => _assetOrFallback(assetPaths, index + 1),
    );
  }

  Widget _pixelOrNeutralPlaceholder() {
    switch (sceneTone) {
      case 'morning':
        return _MorningScene(height: height);
      case 'hallway':
        return _HallwayScene(height: height);
      case 'lunch':
        return _LunchScene(height: height);
      case 'class':
        return _ClassScene(height: height);
      case 'evening':
        return _EveningScene(height: height);
      default:
        return const _NeutralScenePlaceholder();
    }
  }
}

class _NeutralScenePlaceholder extends StatelessWidget {
  const _NeutralScenePlaceholder();

  @override
  Widget build(BuildContext context) => Container(
    color: AppColors.surface,
    alignment: Alignment.center,
    child: Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textSecondary,
    ),
  );
}

class _BrainFogBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        border: Border.all(
          color: AppColors.accentAmber.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_queue, color: AppColors.accentAmber, size: 10),
          SizedBox(width: 4),
          Text(
            'Brain fog',
            style: TextStyle(
              color: AppColors.accentAmber,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SensoryOverloadBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        border: Border.all(
          color: AppColors.accentRed.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hearing_disabled, color: AppColors.accentRed, size: 10),
          SizedBox(width: 4),
          Text(
            'Sensory overload',
            style: TextStyle(
              color: AppColors.accentRed,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MorningScene extends StatelessWidget {
  final double height;

  const _MorningScene({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.illustrationBuilding,
                  AppColors.illustrationDesk,
                ],
              ),
            ),
          ),
          // Window
          Positioned(
            top: 16,
            right: 24,
            child: Container(
              width: 48,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.illustrationWarm.withValues(alpha: 0.3),
                border: Border.all(color: AppColors.illustrationTrim, width: 2),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: AppColors.illustrationWarm.withValues(alpha: 0.3),
                    ),
                  ),
                  Container(height: 2, color: AppColors.illustrationTrim),
                  Expanded(
                    child: Container(
                      color: AppColors.illustrationWarm.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 20, color: AppColors.illustrationDesk),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(height: 4, color: AppColors.illustrationTrim),
          ),
          // Papers/notebook
          Positioned(
            bottom: 24,
            left: 20,
            child: Container(
              width: 50,
              height: 38,
              color: AppColors.textPrimary,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: List.generate(
                    5,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        height: 2,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Coffee mug
          Positioned(
            bottom: 24,
            right: 30,
            child: Container(
              width: 14,
              height: 18,
              decoration: BoxDecoration(color: AppColors.accent),
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  color: AppColors.accentDark,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 80,
            child: _PixelFigure(
              headColor: AppColors.illustrationSkin,
              bodyColor: AppColors.accent,
              posture: 'sitting',
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassScene extends StatelessWidget {
  final double height;

  const _ClassScene({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.illustrationGround,
                  AppColors.illustrationBuildingDim,
                ],
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              color: AppColors.illustrationBuilding,
              child: Center(
                child: Container(
                  width: 80,
                  height: 30,
                  color: AppColors.textPrimary.withValues(alpha: 0.1),
                  child: Center(
                    child: Container(
                      width: 60,
                      height: 4,
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_SmallDesk(), _SmallDesk(), _SmallDesk()],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 30,
            right: 30,
            child: Container(height: 10, color: AppColors.illustrationDesk),
          ),
          Positioned(
            bottom: 8,
            left: 90,
            child: _PixelFigure(
              headColor: AppColors.illustrationSkin,
              bodyColor: AppColors.accentGreen,
              posture: 'sitting',
            ),
          ),
          Positioned(
            bottom: 10,
            left: 50,
            child: Container(
              width: 28,
              height: 20,
              color: AppColors.illustrationWarm.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallDesk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 8,
      color: AppColors.illustrationDesk.withValues(alpha: 0.7),
    );
  }
}

class _EveningScene extends StatelessWidget {
  final double height;

  const _EveningScene({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.illustrationDeepSky,
                  AppColors.illustrationSkyEnd,
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 30,
            child: Container(
              width: 2,
              height: 2,
              color: AppColors.illustrationStar.withValues(alpha: 0.54),
            ),
          ),
          Positioned(
            top: 25,
            left: 80,
            child: Container(
              width: 1,
              height: 1,
              color: AppColors.illustrationStar.withValues(alpha: 0.54),
            ),
          ),
          Positioned(
            top: 15,
            right: 50,
            child: Container(
              width: 2,
              height: 2,
              color: AppColors.illustrationStar.withValues(alpha: 0.54),
            ),
          ),
          // Lamp glow
          Positioned(
            top: 20,
            left: 24,
            child: Container(
              width: 40,
              height: 30,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    AppColors.illustrationWarm.withValues(alpha: 0.3),
                    AppColors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Lamp
          Positioned(
            top: 30,
            left: 30,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 12,
                  color: AppColors.illustrationWindow.withValues(alpha: 0.8),
                ),
                Container(
                  width: 4,
                  height: 20,
                  color: AppColors.illustrationTrim,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              color: AppColors.illustrationEveningGround,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(height: 4, color: AppColors.illustrationDesk),
          ),
          Positioned(
            bottom: 24,
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 18,
                  color: AppColors.illustrationBook.withValues(alpha: 0.8),
                ),
                Container(
                  width: 8,
                  height: 14,
                  color: AppColors.accentRed.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 70,
            child: _PixelFigure(
              headColor: AppColors.illustrationSkin,
              bodyColor: AppColors.illustrationScreenGlow.withValues(
                alpha: 0.6,
              ),
              posture: 'tired',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hallway scene ─────────────────────────────────────────────────────────────

class _HallwayScene extends StatelessWidget {
  final double height;

  const _HallwayScene({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Corridor background — cool gray-teal
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.surfaceVariant, AppColors.background],
              ),
            ),
          ),
          // Ceiling strip
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              color: AppColors.border.withValues(alpha: 0.25),
            ),
          ),
          // Fluorescent light fixtures on ceiling
          Positioned(
            top: 8,
            left: 50,
            right: 50,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.illustrationWindow.withValues(alpha: 0.55),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.illustrationWindow.withValues(alpha: 0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          // Left locker bank
          Positioned(
            top: 30,
            left: 0,
            bottom: 30,
            width: 48,
            child: _LockerColumn(count: 5, color: AppColors.surfaceVariant),
          ),
          // Right locker bank
          Positioned(
            top: 30,
            right: 0,
            bottom: 30,
            width: 48,
            child: _LockerColumn(count: 5, color: AppColors.surfaceVariant),
          ),
          // Wall–floor seam
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(height: 2, color: AppColors.border),
          ),
          // Floor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              color: AppColors.illustrationDesk.withValues(alpha: 0.35),
            ),
          ),
          // Floor center line
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 30,
            child: Center(
              child: Container(
                width: 2,
                color: AppColors.border.withValues(alpha: 0.2),
              ),
            ),
          ),
          // Small pixel figure walking
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: _PixelFigure(
                headColor: AppColors.illustrationSkin,
                bodyColor: AppColors.accent.withValues(alpha: 0.55),
                posture: 'sitting',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LockerColumn extends StatelessWidget {
  final int count;
  final Color color;

  const _LockerColumn({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        children: List.generate(count, (i) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 3,
                  height: 3,
                  margin: const EdgeInsets.only(left: 3),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Lunch / cafeteria scene ───────────────────────────────────────────────────

class _LunchScene extends StatelessWidget {
  final double height;

  const _LunchScene({required this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Warm cafeteria background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.illustrationBuilding,
                  AppColors.illustrationDesk,
                ],
              ),
            ),
          ),
          // Window on right — warm outdoor light
          Positioned(
            top: 16,
            right: 20,
            child: Container(
              width: 44,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.illustrationWarm.withValues(alpha: 0.25),
                border: Border.all(color: AppColors.illustrationTrim, width: 2),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: AppColors.illustrationWarm.withValues(alpha: 0.2),
                    ),
                  ),
                  Container(height: 2, color: AppColors.illustrationTrim),
                  Expanded(
                    child: Container(
                      color: AppColors.illustrationWarm.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Overhead cafeteria light
          Positioned(
            top: 8,
            left: 40,
            width: 60,
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.illustrationWindow.withValues(alpha: 0.5),
              ),
            ),
          ),
          // Floor
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 20,
              color: AppColors.illustrationDesk.withValues(alpha: 0.8),
            ),
          ),
          // Long cafeteria table surface
          Positioned(
            bottom: 44,
            left: 16,
            right: 80,
            child: Container(height: 8, color: AppColors.illustrationDesk),
          ),
          // Bench/seat
          Positioned(
            bottom: 28,
            left: 20,
            width: 80,
            child: Container(
              height: 6,
              color: AppColors.illustrationTrim.withValues(alpha: 0.7),
            ),
          ),
          // Tray on table
          Positioned(
            bottom: 52,
            left: 24,
            child: Container(
              width: 28,
              height: 6,
              color: AppColors.illustrationScreen.withValues(alpha: 0.6),
            ),
          ),
          // Plate (circle approximated by square + decoration)
          Positioned(
            bottom: 55,
            left: 30,
            child: Container(
              width: 14,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.magnifierSurface,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          // Food dot on plate
          Positioned(
            bottom: 58,
            left: 36,
            child: Container(
              width: 4,
              height: 4,
              color: AppColors.accentAmber.withValues(alpha: 0.8),
            ),
          ),
          // Drink carton
          Positioned(
            bottom: 52,
            left: 60,
            child: Container(
              width: 8,
              height: 14,
              color: AppColors.accentPurple.withValues(alpha: 0.5),
            ),
          ),
          // Seated figure at table
          Positioned(
            bottom: 44,
            left: 28,
            child: _PixelFigure(
              headColor: AppColors.illustrationSkin,
              bodyColor: AppColors.accentGreen.withValues(alpha: 0.7),
              posture: 'sitting',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pixel figure ───────────────────────────────────────────────────────────────

class _PixelFigure extends StatelessWidget {
  final Color headColor;
  final Color bodyColor;
  final String posture;

  const _PixelFigure({
    required this.headColor,
    required this.bodyColor,
    required this.posture,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 4, color: AppColors.illustrationHair),
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          color: headColor,
        ),
        Container(width: 18, height: 12, color: bodyColor),
        if (posture != 'tired')
          Container(
            width: 14,
            height: 8,
            color: bodyColor.withValues(alpha: 0.6),
          ),
      ],
    );
  }
}

class _StatusPanel extends StatelessWidget {
  final GameState gameState;

  const _StatusPanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final charName = (gameState.selectedCharacter?.name ?? 'Character')
        .toUpperCase();

    return PixelPanel(
      title: 'STATUS — $charName',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (gameState.selectedCharacter != null) ...[
            Center(
              child: CharacterPortrait(
                character: gameState.selectedCharacter!,
                width: 96,
                height: 120,
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
          ],
          BurnoutMeter(
            value: gameState.burnoutLevel,
            range: gameState.burnoutRange,
          ),
          if (gameState.hasSensoryOverload) ...[
            const SizedBox(height: 8),
            _SensoryOverloadWarning(severe: gameState.hasSevereOverload),
          ],
          const SizedBox(height: 12),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          StatusMeter(
            label: 'Energy',
            value: gameState.energy,
            color: AppColors.energyColor,
            tooltipMessage:
                'Available capacity for tasks. Drains with demand, restores with recovery.',
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Focus',
            value: gameState.focus,
            color: AppColors.focusColor,
            tooltipMessage:
                'Ability to direct attention effectively. Affected by stress and recovery.',
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Stress',
            value: gameState.stress,
            color: AppColors.stressColor,
            invertScale: true,
            tooltipMessage:
                'Accumulated tension from demands and uncertainty. Lower is better.',
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Motivation',
            value: gameState.motivation,
            color: AppColors.motivationColor,
            tooltipMessage:
                'Drive to engage with activities. Affected by alignment with strengths.',
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Life Satisfaction',
            value: gameState.lifeSatisfaction,
            color: AppColors.satisfactionColor,
            tooltipMessage:
                'Sense of meaning and wellbeing beyond immediate tasks.',
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Self-Advocacy',
            value: gameState.selfAdvocacy,
            color: AppColors.selfAdvocacyColor,
            tooltipMessage:
                'Ability to communicate needs and ask for appropriate support.',
          ),
          if (gameState.completedTasks.isNotEmpty) ...[
            const SizedBox(height: 12),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Text(
              'COMPLETED',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 6),
            ...gameState.completedTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.check, size: 12, color: AppColors.accentGreen),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        task,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          _MeterGlossary(),
        ],
      ),
    );
  }
}

class _MeterGlossary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT DO THESE MEASURE?',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        _MeterDef(
          'Burnout',
          'Computed from all meters. Rises when energy depletes, stress accumulates, or self-advocacy is suppressed.',
          AppColors.burnoutMid,
        ),
        _MeterDef(
          'Energy',
          'Available capacity for demands. Drains with effort, restores with rest.',
          AppColors.energyColor,
        ),
        _MeterDef(
          'Stress',
          'Accumulated tension. Lower is better. Rises with unresolved demands.',
          AppColors.stressColor,
        ),
        _MeterDef(
          'Focus',
          'Ability to direct attention. Affected by sensory load and recovery.',
          AppColors.focusColor,
        ),
        _MeterDef(
          'Motivation',
          'Drive to engage. Falls when tasks mismatch strengths.',
          AppColors.motivationColor,
        ),
        _MeterDef(
          'Life Satisfaction',
          'Sense of meaning beyond immediate tasks.',
          AppColors.satisfactionColor,
        ),
        _MeterDef(
          'Self-Advocacy',
          'Ability to name and communicate needs to others.',
          AppColors.selfAdvocacyColor,
        ),
      ],
    );
  }
}

class _MeterDef extends StatelessWidget {
  final String name;
  final String definition;
  final Color color;

  const _MeterDef(this.name, this.definition, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 3, right: 6),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$name: ',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                    ),
                  ),
                  TextSpan(
                    text: definition,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SensoryOverloadWarning extends StatelessWidget {
  final bool severe;

  const _SensoryOverloadWarning({required this.severe});

  @override
  Widget build(BuildContext context) {
    final color = severe ? AppColors.accentRed : AppColors.accentAmber;
    final label = severe ? 'Severe sensory overload' : 'Sensory overload';
    final detail = severe
        ? 'Some actions are no longer accessible. Recovery is the priority.'
        : 'Sensory demands have exceeded a sustainable threshold.';

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hearing_disabled, color: color, size: 12),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            detail,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileStatusBar extends StatelessWidget {
  final GameState gameState;

  const _MobileStatusBar({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          BurnoutMeter(
            value: gameState.burnoutLevel,
            range: gameState.burnoutRange,
          ),
          if (gameState.hasSensoryOverload) ...[
            const SizedBox(height: 6),
            _SensoryOverloadWarning(severe: gameState.hasSevereOverload),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatusMeter(
                  label: 'Energy',
                  value: gameState.energy,
                  color: AppColors.energyColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatusMeter(
                  label: 'Stress',
                  value: gameState.stress,
                  color: AppColors.stressColor,
                  invertScale: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: StatusMeter(
                  label: 'Focus',
                  value: gameState.focus,
                  color: AppColors.focusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainInteractionPanel extends StatelessWidget {
  final GameState gameState;

  const _MainInteractionPanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _InteractionContent(gameState: gameState),
    );
  }
}

class _InteractionContent extends StatelessWidget {
  final GameState gameState;

  const _InteractionContent({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final scenarios = gameState.activeScenarios;
    if (scenarios.isEmpty) return const SizedBox.shrink();

    final idx = gameState.currentScenarioIndex;
    final scenario = scenarios[idx];
    final total = scenarios.length;
    final progress = _ProgressIndicator(current: idx + 1, total: total);
    if (gameState.pendingFeedback != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          progress,
          const SizedBox(height: 16),
          EducationalFeedbackCard(
            choiceLabel: gameState.lastChoiceLabel ?? '',
            feedbackText: gameState.pendingFeedback!,
            isLastScenario: idx + 1 >= total,
            onContinue: gameState.advanceScenario,
          ),
        ],
      );
    }

    final carryover = gameState.carryoverNote(scenario);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        progress,
        const SizedBox(height: 16),
        if (carryover != null) _CarryoverNote(text: carryover),
        ScenarioCard(
          scenario: scenario,
          scenarioNumber: idx + 1,
          totalScenarios: total,
          characterName: gameState.selectedCharacter?.name ?? 'the character',
        ),
        const SizedBox(height: 16),
        _ChoiceList(gameState: gameState, scenario: scenario),
      ],
    );
  }
}

class _CarryoverNote extends StatelessWidget {
  final String text;

  const _CarryoverNote({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.accentPurple.withValues(alpha: 0.06),
        border: Border(
          left: BorderSide(
            color: AppColors.accentPurple.withValues(alpha: 0.5),
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            color: AppColors.accentPurple.withValues(alpha: 0.10),
            child: Row(
              children: [
                Icon(Icons.history, color: AppColors.accentPurple, size: 11),
                const SizedBox(width: 6),
                Text(
                  'AN EARLIER CHOICE IS STILL SHOWING',
                  style: TextStyle(
                    color: AppColors.accentPurple,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.55,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceList extends StatelessWidget {
  final GameState gameState;
  final GameScenario scenario;

  const _ChoiceList({required this.gameState, required this.scenario});

  @override
  Widget build(BuildContext context) {
    final labels = ['A', 'B', 'C', 'D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: scenario.choices.asMap().entries.map((entry) {
        final i = entry.key;
        final choice = entry.value;

        final bool isAvailable = gameState.isChoiceAvailable(choice);
        final String? disabledReason = isAvailable
            ? null
            : (choice.unavailableReason ??
                  'This option is not accessible right now. Current capacity makes this action out of reach. This is not a choice — it is a limit.');

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ChoiceButton(
            choice: choice,
            choiceLetter: labels[i],
            isDisabled: !isAvailable,
            disabledReason: disabledReason,
            onPressed: isAvailable ? () => gameState.applyChoice(choice) : null,
          ),
        );
      }).toList(),
    );
  }
}

class _ProgressIndicator extends StatelessWidget {
  final int current;
  final int total;

  const _ProgressIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final label = Text(
      'Scenario $current of $total',
      style: TextStyle(
        color: AppColors.textMuted,
        fontSize: 14,
        letterSpacing: 0.5,
      ),
    );
    final steps = Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        total,
        (i) => Container(
          width: 20,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          color: i < current ? AppColors.accent : AppColors.surfaceVariant,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [label, const SizedBox(height: 8), steps],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [label, const SizedBox(width: 12), steps],
        );
      },
    );
  }
}

class _BurnoutOverlay extends StatelessWidget {
  final double burnoutLevel;
  final bool severe;

  const _BurnoutOverlay({required this.burnoutLevel, required this.severe});

  @override
  Widget build(BuildContext context) {
    final baseOpacity = burnoutLevel < 70
        ? (burnoutLevel - 40) / 30 * 0.05
        : 0.05 + (burnoutLevel - 70) / 30 * 0.07;

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            Container(
              color: AppColors.illustrationBook.withValues(alpha: baseOpacity),
            ),
            if (severe)
              Container(color: AppColors.accentRed.withValues(alpha: 0.06)),
          ],
        ),
      ),
    );
  }
}
