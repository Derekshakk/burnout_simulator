import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/game_scenario.dart';
import '../models/game_state.dart';
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
        Navigator.pushReplacementNamed(context, AppRoutes.select);
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
      Navigator.pushReplacementNamed(context, AppRoutes.results);
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
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                (_) => false,
              ),
            ),
            const SizedBox(width: 8),
            const ProjectIgniteLogo(height: 32),
            const Spacer(),
            ListenableBuilder(
              listenable: gameState,
              builder: (_, child) =>
                  _TimeDisplay(time: gameState.currentTimeLabel),
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
              fontSize: 13,
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

    return PixelPanel(
      title: 'SCENE',
      padding: EdgeInsets.zero,
      child: A11yImage(
        semanticLabel: 'Pixel art scene for scenario ${scenario.sceneTone}',
        child: _SceneArtwork(
          sceneTone: scenario.sceneTone,
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
  final double burnoutLevel;
  final bool reduceEffects;
  final bool hasSensoryOverload;
  final double height;

  const _SceneArtwork({
    required this.sceneTone,
    required this.burnoutLevel,
    required this.reduceEffects,
    required this.hasSensoryOverload,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget artwork;
    switch (sceneTone) {
      case 'morning':
        artwork = _MorningScene(height: height);
      case 'class':
        artwork = _ClassScene(height: height);
      default:
        artwork = _EveningScene(height: height);
    }

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
            color: const Color(0xFFd29922).withValues(alpha: overlayOpacity),
          ),
          if (burnoutLevel >= 70)
            Positioned(top: 8, right: 8, child: _BrainFogBadge()),
          if (hasSensoryOverload)
            Positioned(top: 8, left: 8, child: _SensoryOverloadBadge()),
        ],
      ),
    );
  }
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
              fontSize: 9,
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
              fontSize: 9,
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1a1025), Color(0xFF3d2010)],
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
                color: const Color(0xFFffa040).withValues(alpha: 0.3),
                border: Border.all(color: const Color(0xFF5a3a20), width: 2),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: const Color(0xFFff8c00).withValues(alpha: 0.3),
                    ),
                  ),
                  Container(height: 2, color: const Color(0xFF5a3a20)),
                  Expanded(
                    child: Container(
                      color: const Color(0xFFffa040).withValues(alpha: 0.2),
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
            child: Container(height: 20, color: const Color(0xFF3d2b1f)),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(height: 4, color: const Color(0xFF5a3d26)),
          ),
          // Papers/notebook
          Positioned(
            bottom: 24,
            left: 20,
            child: Container(
              width: 50,
              height: 38,
              color: const Color(0xFFe6edf3),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: List.generate(
                    5,
                    (_) => Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Container(
                        height: 2,
                        color: const Color(0xFF8b949e).withValues(alpha: 0.5),
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
              decoration: const BoxDecoration(color: Color(0xFF58a6ff)),
              child: Center(
                child: Container(
                  width: 6,
                  height: 6,
                  color: const Color(0xFF3d7ab3),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 80,
            child: _PixelFigure(
              headColor: const Color(0xFFe8c99a),
              bodyColor: const Color(0xFF58a6ff),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0d1520), Color(0xFF162030)],
              ),
            ),
          ),
          Positioned(
            top: 12,
            left: 20,
            right: 20,
            child: Container(
              height: 50,
              color: const Color(0xFF1e2d3d),
              child: Center(
                child: Container(
                  width: 80,
                  height: 30,
                  color: const Color(0xFFe6edf3).withValues(alpha: 0.1),
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
            child: Container(height: 10, color: const Color(0xFF3d2b1f)),
          ),
          Positioned(
            bottom: 8,
            left: 90,
            child: _PixelFigure(
              headColor: const Color(0xFFe8c99a),
              bodyColor: const Color(0xFF3fb950),
              posture: 'sitting',
            ),
          ),
          Positioned(
            bottom: 10,
            left: 50,
            child: Container(
              width: 28,
              height: 20,
              color: const Color(0xFFffa657).withValues(alpha: 0.8),
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
      color: const Color(0xFF3d2b1f).withValues(alpha: 0.7),
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF050c1a), Color(0xFF1a1030)],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 30,
            child: Container(width: 2, height: 2, color: Colors.white54),
          ),
          Positioned(
            top: 25,
            left: 80,
            child: Container(width: 1, height: 1, color: Colors.white54),
          ),
          Positioned(
            top: 15,
            right: 50,
            child: Container(width: 2, height: 2, color: Colors.white54),
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
                    const Color(0xFFffa040).withValues(alpha: 0.3),
                    Colors.transparent,
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
                  color: const Color(0xFFffd54f).withValues(alpha: 0.8),
                ),
                Container(width: 4, height: 20, color: const Color(0xFF5a4a30)),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(height: 20, color: const Color(0xFF2a1e12)),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Container(height: 4, color: const Color(0xFF3d2b1f)),
          ),
          Positioned(
            bottom: 24,
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 18,
                  color: const Color(0xFFd29922).withValues(alpha: 0.8),
                ),
                Container(
                  width: 8,
                  height: 14,
                  color: const Color(0xFFf85149).withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 70,
            child: _PixelFigure(
              headColor: const Color(0xFFe8c99a),
              bodyColor: const Color(0xFF58a6ff).withValues(alpha: 0.6),
              posture: 'tired',
            ),
          ),
        ],
      ),
    );
  }
}

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
        Container(width: 16, height: 4, color: const Color(0xFF4a3728)),
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
                fontSize: 9,
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
                    Icon(Icons.check, size: 11, color: AppColors.accentGreen),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        task,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
                  fontSize: 9,
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
              fontSize: 10,
              height: 1.4,
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

    if (gameState.pendingFeedback != null) {
      return EducationalFeedbackCard(
        choiceLabel: gameState.lastChoiceLabel ?? '',
        feedbackText: gameState.pendingFeedback!,
        isLastScenario: idx + 1 >= total,
        onContinue: () => gameState.advanceScenario(scenarios),
      );
    }

    final carryover = gameState.carryoverNote(scenario);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (carryover != null) _CarryoverNote(text: carryover),
        ScenarioCard(
          scenario: scenario,
          scenarioNumber: idx + 1,
          totalScenarios: total,
          characterName: gameState.selectedCharacter?.name ?? 'the character',
        ),
        const SizedBox(height: 16),
        _ChoiceList(gameState: gameState, scenario: scenario),
        const SizedBox(height: 24),
        _ProgressIndicator(current: idx + 1, total: total),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentPurple.withValues(alpha: 0.06),
        border: Border(
          left: BorderSide(
            color: AppColors.accentPurple.withValues(alpha: 0.5),
            width: 3,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.history, color: AppColors.accentPurple, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.5,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Scenario $current of $total',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 12),
        ...List.generate(
          total,
          (i) => Container(
            width: 20,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            color: i < current ? AppColors.accent : AppColors.surfaceVariant,
          ),
        ),
      ],
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
              color: const Color(0xFFd29922).withValues(alpha: baseOpacity),
            ),
            if (severe)
              Container(color: const Color(0xFFf85149).withValues(alpha: 0.06)),
          ],
        ),
      ),
    );
  }
}
