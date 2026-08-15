import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/character_profile.dart';
import '../models/game_state.dart';
import '../services/external_action_service.dart';
import '../widgets/character_portrait.dart';
import '../widgets/pixel_panel.dart';
import '../widgets/site_navigation.dart';
import '../widgets/section_label.dart';
import '../widgets/status_meter.dart';

class ResultsScreen extends StatelessWidget {
  final GameState gameState;

  const ResultsScreen({super.key, required this.gameState});

  void _playAgain(BuildContext context) {
    gameState.reset();
    Navigator.pushReplacementNamed(context, AppRoutes.select);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: AppRoutes.results,
            gameState: gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ResultsHeader(gameState: gameState, isMobile: isMobile),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 80,
                      vertical: 40,
                    ),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _FinalStatusPanel(gameState: gameState),
                              const SizedBox(height: 24),
                              _ChoiceHistoryPanel(gameState: gameState),
                              const SizedBox(height: 24),
                              _ActivityPanel(gameState: gameState),
                              const SizedBox(height: 24),
                              _AftermathPanel(gameState: gameState),
                              const SizedBox(height: 24),
                              _ReflectionPanel(gameState: gameState),
                              const SizedBox(height: 24),
                              _PlayAgainPanel(
                                onPlayAgain: () => _playAgain(context),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        _FinalStatusPanel(gameState: gameState),
                                        const SizedBox(height: 24),
                                        _ActivityPanel(gameState: gameState),
                                        const SizedBox(height: 24),
                                        _PlayAgainPanel(
                                          onPlayAgain: () =>
                                              _playAgain(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        _ChoiceHistoryPanel(
                                          gameState: gameState,
                                        ),
                                        const SizedBox(height: 24),
                                        _AftermathPanel(gameState: gameState),
                                        const SizedBox(height: 24),
                                        _ReflectionPanel(gameState: gameState),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

class _ResultsHeader extends StatelessWidget {
  final GameState gameState;
  final bool isMobile;

  const _ResultsHeader({required this.gameState, required this.isMobile});

  Color _burnoutColor() {
    switch (gameState.burnoutRange) {
      case 'high':
        return AppColors.burnoutHigh;
      case 'elevated':
        return AppColors.burnoutMid;
      default:
        return AppColors.burnoutLow;
    }
  }

  String _burnoutMessage() {
    final name = gameState.selectedCharacter?.name ?? 'The character';
    switch (gameState.burnoutRange) {
      case 'high':
        return '$name\'s burnout reached a high level by the end of the day. Recovery will be important.';
      case 'elevated':
        return '$name\'s burnout is elevated but manageable. Some strategies helped reduce demands.';
      default:
        return '$name maintained a lower burnout level through the day. A good balance of demand and recovery.';
    }
  }

  String _conditionLabel() {
    final b = gameState.burnoutLevel;
    if (b >= 70) return 'Depleted';
    if (b >= 40) return 'Running low';
    return 'Manageable';
  }

  Color _conditionColor() {
    final b = gameState.burnoutLevel;
    if (b >= 70) return AppColors.burnoutHigh;
    if (b >= 40) return AppColors.burnoutMid;
    return AppColors.burnoutLow;
  }

  IconData _conditionIcon() {
    final b = gameState.burnoutLevel;
    if (b >= 70) return Icons.sentiment_very_dissatisfied_outlined;
    if (b >= 40) return Icons.sentiment_neutral_outlined;
    return Icons.sentiment_satisfied_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width >= 768 && width < 1100;
    final showConditionPortrait = width >= 1100;
    final burnoutColor = _burnoutColor();
    final range = gameState.burnoutRange.toUpperCase();
    final name = gameState.selectedCharacter?.name ?? 'Character';
    final conditionColor = _conditionColor();

    final headerContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'END OF DAY — RESULTS'),
        const SizedBox(height: 12),
        _ResultsCharacterSummary(
          character: gameState.selectedCharacter,
          name: name,
          burnoutColor: burnoutColor,
          burnoutRange: range,
          finalTime: gameState.currentTimeLabel,
          burnoutMessage: _burnoutMessage(),
          isMobile: isMobile,
          isTablet: isTablet,
          showConditionBadge: !showConditionPortrait,
          conditionColor: conditionColor,
          conditionIcon: _conditionIcon(),
          conditionLabel: _conditionLabel(),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: !showConditionPortrait
          ? headerContent
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: headerContent),
                const SizedBox(width: 24),
                _ConditionPortrait(
                  burnoutLevel: gameState.burnoutLevel,
                  appearance:
                      gameState.selectedCharacter?.appearance ??
                      CharacterAppearance.neutral,
                ),
              ],
            ),
    );
  }
}

class _ResultsCharacterSummary extends StatelessWidget {
  final CharacterProfile? character;
  final String name;
  final Color burnoutColor;
  final String burnoutRange;
  final String finalTime;
  final String burnoutMessage;
  final bool isMobile;
  final bool isTablet;
  final bool showConditionBadge;
  final Color conditionColor;
  final IconData conditionIcon;
  final String conditionLabel;

  const _ResultsCharacterSummary({
    required this.character,
    required this.name,
    required this.burnoutColor,
    required this.burnoutRange,
    required this.finalTime,
    required this.burnoutMessage,
    required this.isMobile,
    required this.isTablet,
    required this.showConditionBadge,
    required this.conditionColor,
    required this.conditionIcon,
    required this.conditionLabel,
  });

  Size get _portraitSize {
    if (isMobile) return const Size(96, 128);
    if (isTablet) return const Size(104, 136);
    return const Size(120, 156);
  }

  @override
  Widget build(BuildContext context) {
    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        A11yHeading(
          '$name\'s Day is Complete',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 36,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            _ResultsBadge(
              color: burnoutColor.withValues(alpha: 0.15),
              child: Text(
                'BURNOUT: $burnoutRange',
                style: TextStyle(
                  color: burnoutColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            _ResultsBadge(
              color: AppColors.surfaceVariant,
              child: Text(
                'Final time: $finalTime',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (showConditionBadge)
              _ResultsBadge(
                color: conditionColor.withValues(alpha: 0.12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(conditionIcon, color: conditionColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      conditionLabel.toUpperCase(),
                      style: TextStyle(
                        color: conditionColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ReadingText(
            burnoutMessage,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 17,
              height: 1.65,
            ),
          ),
        ),
      ],
    );

    if (character == null) return details;
    final portrait = CharacterPortrait(
      character: character!,
      width: _portraitSize.width,
      height: _portraitSize.height,
      fit: BoxFit.contain,
    );
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [portrait, const SizedBox(height: 16), details],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        portrait,
        const SizedBox(width: 20),
        Expanded(child: details),
      ],
    );
  }
}

class _ResultsBadge extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ResultsBadge({required this.color, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    color: color,
    child: child,
  );
}

// ── Condition portrait ────────────────────────────────────────────────────────

class _ConditionPortrait extends StatelessWidget {
  final double burnoutLevel;
  final CharacterAppearance appearance;

  const _ConditionPortrait({
    required this.burnoutLevel,
    required this.appearance,
  });

  String get _state {
    if (burnoutLevel >= 70) return 'overwhelmed';
    if (burnoutLevel >= 40) return 'tired';
    return 'calm';
  }

  Color get _stateColor {
    if (burnoutLevel >= 70) return AppColors.burnoutHigh;
    if (burnoutLevel >= 40) return AppColors.burnoutMid;
    return AppColors.burnoutLow;
  }

  String get _label {
    switch (_state) {
      case 'overwhelmed':
        return 'Depleted';
      case 'tired':
        return 'Running low';
      default:
        return 'Manageable';
    }
  }

  IconData get _icon {
    switch (_state) {
      case 'overwhelmed':
        return Icons.sentiment_very_dissatisfied_outlined;
      case 'tired':
        return Icons.sentiment_neutral_outlined;
      default:
        return Icons.sentiment_satisfied_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'End-of-day condition: $_label ($_state)',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'END-OF-DAY STATE',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          _PixelConditionFace(state: _state, appearance: appearance),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_icon, color: _stateColor, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: _stateColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PixelConditionFace extends StatelessWidget {
  final String state; // 'calm' | 'tired' | 'overwhelmed'
  final CharacterAppearance appearance;

  const _PixelConditionFace({required this.state, required this.appearance});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          key: const ValueKey('condition-figure-hair'),
          width: 52,
          height: 6,
          color: appearance.hairColor,
        ),
        // Head
        Container(
          key: const ValueKey('condition-figure-head'),
          width: 46,
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          color: appearance.skinTone,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Eyes
              Positioned(
                top: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEye(context, isLeft: true),
                    const SizedBox(width: 10),
                    _buildEye(context, isLeft: false),
                  ],
                ),
              ),
              // Mouth
              Positioned(bottom: 10, child: _buildMouth(context)),
            ],
          ),
        ),
        // Body — height and opacity shift with burnout state
        Container(
          width: 56,
          height: state == 'overwhelmed'
              ? 24
              : state == 'tired'
              ? 30
              : 36,
          key: const ValueKey('condition-figure-top'),
          color: appearance.topColor.withValues(
            alpha: state == 'overwhelmed'
                ? 0.45
                : state == 'tired'
                ? 0.6
                : 0.75,
          ),
        ),
        // Legs — absent when overwhelmed (slumped/collapsed posture)
        if (state != 'overwhelmed')
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 18,
                height: state == 'tired' ? 12 : 16,
                key: const ValueKey('condition-figure-left-bottom'),
                color: appearance.bottomColor.withValues(alpha: 0.55),
              ),
              const SizedBox(width: 4),
              Container(
                width: 18,
                height: state == 'tired' ? 12 : 16,
                key: const ValueKey('condition-figure-right-bottom'),
                color: appearance.bottomColor.withValues(alpha: 0.55),
              ),
            ],
          ),
        // Slump bar for overwhelmed — conveyed as a collapsed position
        if (state == 'overwhelmed')
          Container(
            width: 56,
            height: 10,
            color: AppColors.accentRed.withValues(alpha: 0.25),
          ),
      ],
    );
  }

  Widget _buildEye(BuildContext context, {required bool isLeft}) {
    switch (state) {
      case 'calm':
        return Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
        );
      case 'tired':
        return Container(width: 7, height: 3, color: AppColors.textPrimary);
      case 'overwhelmed':
        // X-shaped eye: two rotated thin bars in a Stack
        return SizedBox(
          width: 8,
          height: 8,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: 0.785, // 45 degrees
                child: Container(
                  width: 8,
                  height: 2,
                  color: AppColors.textPrimary,
                ),
              ),
              Transform.rotate(
                angle: -0.785, // -45 degrees
                child: Container(
                  width: 8,
                  height: 2,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      default:
        return Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            shape: BoxShape.circle,
          ),
        );
    }
  }

  Widget _buildMouth(BuildContext context) {
    switch (state) {
      case 'calm':
        // Slight smile: bar with rounded bottom
        return Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        );
      case 'tired':
        // Flat mouth
        return Container(width: 14, height: 3, color: AppColors.textPrimary);
      case 'overwhelmed':
        // Frown: bar with rounded top
        return Container(
          width: 16,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textPrimary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        );
      default:
        return Container(width: 14, height: 3, color: AppColors.textPrimary);
    }
  }
}

class _FinalStatusPanel extends StatelessWidget {
  final GameState gameState;

  const _FinalStatusPanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'FINAL STATUS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BurnoutMeter(
            value: gameState.burnoutLevel,
            range: gameState.burnoutRange,
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          StatusMeter(
            label: 'Energy',
            value: gameState.energy,
            color: AppColors.energyColor,
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Focus',
            value: gameState.focus,
            color: AppColors.focusColor,
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Stress',
            value: gameState.stress,
            color: AppColors.stressColor,
            invertScale: true,
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Motivation',
            value: gameState.motivation,
            color: AppColors.motivationColor,
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Life Satisfaction',
            value: gameState.lifeSatisfaction,
            color: AppColors.satisfactionColor,
          ),
          const SizedBox(height: 8),
          StatusMeter(
            label: 'Self-Advocacy',
            value: gameState.selfAdvocacy,
            color: AppColors.selfAdvocacyColor,
          ),
          if (gameState.completedTasks.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 12),
            Text(
              'TASKS COMPLETED',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            ...gameState.completedTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      color: AppColors.accentGreen.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.check,
                        size: 11,
                        color: AppColors.accentGreen,
                      ),
                    ),
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
        ],
      ),
    );
  }
}

class _ChoiceHistoryPanel extends StatelessWidget {
  final GameState gameState;

  const _ChoiceHistoryPanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final history = gameState.selectedChoiceHistory;
    final scenarioTitles = gameState.activeScenarios
        .map((s) => s.title)
        .toList();
    final scenarioTimes = gameState.activeScenarios
        .map((s) => s.timeLabel)
        .toList();
    final name = gameState.selectedCharacter?.name ?? 'the character';

    return PixelPanel(
      title: 'CHOICES MADE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Here is how $name\'s day unfolded through your choices:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 16),
          ...history.asMap().entries.map((entry) {
            final i = entry.key;
            final choice = entry.value;
            final title = i < scenarioTitles.length ? scenarioTitles[i] : '';
            final time = i < scenarioTimes.length ? scenarioTimes[i] : '';
            return _ChoiceHistoryRow(
              scenarioTitle: title,
              time: time,
              choiceLabel: choice,
              number: i + 1,
            );
          }),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          _StrategiesSummary(gameState: gameState),
        ],
      ),
    );
  }
}

class _ChoiceHistoryRow extends StatelessWidget {
  final String scenarioTitle;
  final String time;
  final String choiceLabel;
  final int number;

  const _ChoiceHistoryRow({
    required this.scenarioTitle,
    required this.time,
    required this.choiceLabel,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(left: BorderSide(color: AppColors.border, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AppColors.surfaceVariant,
                child: Text(
                  '$number. $scenarioTitle',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                time,
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            choiceLabel,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

const _helpfulTags = {
  // Alex
  'planned_morning',
  'sensory_break_taken',
  'mindful_transition',
  'task_started_fidget',
  'peer_helped_start',
  'quiet_lunch',
  'stim_recovery',
  'timer_strategy',
  'asked_movement_accommodation',
  // Jordan
  'routine_adapted',
  'asked_for_help',
  'sought_clarity',
  'initiated_structure',
  'redirect_gaze',
  'natural_gaze_breaks',
  'quiet_lunch_spot',
  'earplugs_classroom',
  'sensory_break_granted',
  'disclosed_needs_to_teacher',
  // Jordan + Maya (shared)
  'accommodations_initiated',
  'accommodations_researched',
  // Maya
  'maya_externalized_plan',
  'maya_clarified_change',
  'maya_protected_focus',
  'maya_requested_materials',
  'maya_quiet_reset',
  'maya_adapted_connection',
  'maya_processing_time',
  'maya_visual_strength',
  'maya_disclosed_to_instructor',
};

const _demandingTags = {
  // Alex
  'chaotic_morning',
  'pushed_sensory',
  'masked_restless',
  // Jordan
  'routine_panic',
  'masked_confusing',
  'masked_eye_contact',
  'endured_class_sensory',
  'accommodations_deferred',
  // Maya
  'maya_rushed_change',
  'maya_split_attention',
  'maya_socially_drained',
  'maya_masked_critique',
};

class _StrategiesSummary extends StatelessWidget {
  final GameState gameState;

  const _StrategiesSummary({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final history = gameState.selectedChoiceHistory;

    final helpful = history
        .asMap()
        .entries
        .where((e) {
          final scenarios = gameState.activeScenarios;
          if (e.key < scenarios.length) {
            final scenario = scenarios[e.key];
            for (final choice in scenario.choices) {
              if (choice.label == e.value &&
                  choice.tag != null &&
                  _helpfulTags.contains(choice.tag)) {
                return true;
              }
            }
          }
          return false;
        })
        .map((e) => e.value)
        .toList();

    final demanding = history
        .asMap()
        .entries
        .where((e) {
          final scenarios = gameState.activeScenarios;
          if (e.key < scenarios.length) {
            final scenario = scenarios[e.key];
            for (final choice in scenario.choices) {
              if (choice.label == e.value &&
                  choice.tag != null &&
                  _demandingTags.contains(choice.tag)) {
                return true;
              }
            }
          }
          return false;
        })
        .map((e) => e.value)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT SHAPED TODAY',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        if (helpful.isNotEmpty) ...[
          _SummaryGroup(
            label: 'Choices that preserved capacity',
            color: AppColors.accentGreen,
            icon: Icons.arrow_upward,
            items: helpful,
          ),
          const SizedBox(height: 10),
        ],
        if (demanding.isNotEmpty) ...[
          _SummaryGroup(
            label: 'Choices that added to the daily load',
            color: AppColors.accentAmber,
            icon: Icons.arrow_downward,
            items: demanding,
          ),
        ],
        if (helpful.isEmpty && demanding.isEmpty)
          Text(
            'A mix of strategies were used today. Review the feedback cards to see which had the most impact.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
      ],
    );
  }
}

class _SummaryGroup extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final List<String> items;

  const _SummaryGroup({
    required this.label,
    required this.color,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(left: 18, bottom: 4),
            child: Text(
              '· $item',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  final GameState gameState;

  const _ActivityPanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final canHigh = gameState.canDoHighEnergyActivity;
    final canLow = gameState.canDoLowEnergyActivity;
    final char = gameState.selectedCharacter;

    return PixelPanel(
      title: 'END-OF-DAY CAPACITY',
      borderColor: canHigh
          ? AppColors.accentGreen.withValues(alpha: 0.5)
          : canLow
          ? AppColors.accentAmber.withValues(alpha: 0.5)
          : AppColors.accentRed.withValues(alpha: 0.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Can ${char?.name ?? 'the character'} do a favorite activity?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _ActivityRow(
            activity:
                char?.highEnergyActivity ?? 'a high-energy preferred activity',
            label: 'HIGH ENERGY',
            available: canHigh,
            unavailableReason: canHigh
                ? null
                : 'Burnout is too high and energy too low for a high-demand activity right now. Wanting to do something does not always mean having the available capacity to do it. This is not a choice — it is a result of accumulated demand.',
          ),
          const SizedBox(height: 8),
          _ActivityRow(
            activity:
                char?.lowEnergyActivity ?? 'a low-energy preferred activity',
            label: 'LOW ENERGY',
            available: canLow,
            unavailableReason: canLow
                ? null
                : 'Even lower-demand activities may feel out of reach when burnout is very high and energy is critically low.',
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          ReadingText(
            canHigh
                ? '${char?.name ?? 'The character'} has enough capacity to engage in a preferred activity tonight.'
                : canLow
                ? '${char?.name ?? 'The character'} can manage a low-energy activity, though the higher-demand option is beyond reach right now.'
                : '${char?.name ?? 'The character'} needs rest above all else tonight. Recovery is not giving up — it is what makes tomorrow possible.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String activity;
  final String label;
  final bool available;
  final String? unavailableReason;

  const _ActivityRow({
    required this.activity,
    required this.label,
    required this.available,
    this.unavailableReason,
  });

  @override
  Widget build(BuildContext context) {
    final color = available ? AppColors.accentGreen : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: available
              ? AppColors.accentGreen.withValues(alpha: 0.3)
              : AppColors.border,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                available
                    ? Icons.check_circle_outline
                    : Icons.remove_circle_outline,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            activity,
            style: TextStyle(
              color: available ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: 16,
            ),
          ),
          if (!available && unavailableReason != null) ...[
            const SizedBox(height: 8),
            Text(
              unavailableReason!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.55,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AftermathPanel extends StatelessWidget {
  final GameState gameState;

  const _AftermathPanel({required this.gameState});

  String _feelingText(CharacterProfile? char, String range) {
    final name = char?.name ?? 'The character';
    switch (range) {
      case 'high':
        return '$name\'s system is significantly overwhelmed by the end of the day. '
            'Physical fatigue, difficulty with communication, and emotional sensitivity are common when burnout reaches this level. '
            'Small requests may feel very large right now.';
      case 'elevated':
        return '$name is noticeably drained. Concentration may be harder than usual, '
            'and minor frustrations may feel disproportionately heavy. '
            'There is still some capacity left, but it needs protecting.';
      default:
        return '$name is tired but still has meaningful reserves. '
            'The day was demanding in places, and some mild fatigue is present — '
            'but most ordinary evening activities remain within reach.';
    }
  }

  String _restText(String range) {
    switch (range) {
      case 'high':
        return 'Most activities beyond basic self-care will feel out of reach tonight. '
            'Quiet, low-demand environments — minimal sensory input, no performance pressure — '
            'are most supportive right now. Pushing through will extend recovery time.';
      case 'elevated':
        return 'Higher-demand activities are likely out of reach tonight. '
            'Low-key choices — a familiar show, gentle movement, or simply resting — '
            'will do more to restore capacity than trying to accomplish tasks.';
      default:
        return 'A quieter evening and good sleep will restore most capacity for tomorrow. '
            'Avoiding new high-demand commitments this evening will help maintain the balance reached today.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final char = gameState.selectedCharacter;
    final range = gameState.burnoutRange;
    final strategies = char?.recoveryStrategies ?? [];
    final color = range == 'high'
        ? AppColors.burnoutHigh
        : range == 'elevated'
        ? AppColors.burnoutMid
        : AppColors.burnoutLow;

    return PixelPanel(
      title: 'END-OF-DAY AFTERMATH',
      borderColor: color.withValues(alpha: 0.45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                range == 'high'
                    ? Icons.sentiment_very_dissatisfied_outlined
                    : range == 'elevated'
                    ? Icons.sentiment_neutral_outlined
                    : Icons.sentiment_satisfied_outlined,
                color: color,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'HOW THEY FEEL RIGHT NOW',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ReadingText(
            _feelingText(char, range),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.hotel_outlined, color: AppColors.textMuted, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'WHAT NEEDS REST OR SUPPORT',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ReadingText(
            _restText(range),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.65,
            ),
          ),
          if (strategies.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: AppColors.border, height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.spa_outlined,
                  color: AppColors.accentGreen,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'RECOVERY STRATEGIES FOR ${(char?.name ?? '').toUpperCase()}',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...strategies.map(
              (s) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        s,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          height: 1.55,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'These are the strategies associated with this character. Real recovery looks different for every person.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReflectionPanel extends StatelessWidget {
  final GameState gameState;

  const _ReflectionPanel({required this.gameState});

  String _reflectionPrompt(CharacterProfile? char) {
    return 'Which choice best matched ${char?.name ?? 'the character'}\'s needs, and what made it helpful?';
  }

  String _reflectionBody(CharacterProfile? char) {
    final name = char?.name ?? 'the character';
    return 'Consider: Which strategies reduced demand or provided clarity? Were there moments where speaking up changed the outcome? What would have happened if $name had more energy at the end of the day?';
  }

  @override
  Widget build(BuildContext context) {
    final char = gameState.selectedCharacter;

    return PixelPanel(
      title: 'REFLECTION PROMPT',
      borderColor: AppColors.accentPurple.withValues(alpha: 0.4),
      backgroundColor: const Color(0xFF100d1a),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: AppColors.accentPurple, size: 20),
          const SizedBox(height: 12),
          Text(
            _reflectionPrompt(char),
            style: TextStyle(
              color: AppColors.textOnDark,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          ReadingText(
            _reflectionBody(char),
            style: TextStyle(
              color: AppColors.textOnDark.withValues(alpha: 0.85),
              fontSize: 16,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: AppColors.textOnDark.withValues(alpha: 0.25),
            height: 1,
          ),
          const SizedBox(height: 12),
          Text(
            'Different players may make different choices — and different people in real life will have different needs. There is no single correct path through this day.',
            style: TextStyle(
              color: AppColors.textOnDark.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayAgainPanel extends StatelessWidget {
  final VoidCallback onPlayAgain;

  const _PlayAgainPanel({required this.onPlayAgain});

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: onPlayAgain,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Choose a Character'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (_) => false,
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.border),
              foregroundColor: AppColors.textSecondary,
            ),
            child: const Text('Return to Home'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => ExternalActionService.openWebsite(
              ExternalActionService.feedbackUrl,
            ),
            icon: const Icon(Icons.feedback_outlined, size: 16),
            label: const Text('Share Feedback or Suggestions'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.accent.withValues(alpha: 0.5)),
              foregroundColor: AppColors.accent,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Try a different character or different choices to see how the outcomes change. No path through the simulation is a failure.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              height: 1.55,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
