import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../data/demo_character.dart';
import '../data/demo_scenarios.dart';
import '../models/game_state.dart';
import '../widgets/pixel_panel.dart';
import '../widgets/site_navigation.dart';
import '../widgets/status_meter.dart';

class ResultsScreen extends StatelessWidget {
  final GameState gameState;

  const ResultsScreen({super.key, required this.gameState});

  void _playAgain(BuildContext context) {
    gameState.reset();
    Navigator.pushReplacementNamed(context, AppRoutes.play);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(activeSection: AppRoutes.results),
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
                              _ReflectionPanel(),
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
                                        _ReflectionPanel(),
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
    switch (gameState.burnoutRange) {
      case 'high':
        return 'Alex\'s burnout reached a high level by the end of the day. Recovery will be important.';
      case 'elevated':
        return 'Alex\'s burnout is elevated but manageable. Some strategies helped reduce demands.';
      default:
        return 'Alex maintained a lower burnout level through the day. Good balance of demand and recovery.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final burnoutColor = _burnoutColor();
    final range = gameState.burnoutRange.toUpperCase();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: AppColors.accent.withValues(alpha: 0.1),
            child: Text(
              'END OF DAY — RESULTS',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          A11yHeading(
            'Alex\'s Day is Complete',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                color: burnoutColor.withValues(alpha: 0.15),
                child: Text(
                  'BURNOUT: $range',
                  style: TextStyle(
                    color: burnoutColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                color: AppColors.surfaceVariant,
                child: Text(
                  'Final time: ${gameState.currentTimeLabel}',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ReadingText(
              _burnoutMessage(),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
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
                fontSize: 9,
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
                      width: 16,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      alignment: Alignment.center,
                      color: AppColors.accentGreen.withValues(alpha: 0.15),
                      child: Icon(
                        Icons.check,
                        size: 10,
                        color: AppColors.accentGreen,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        task,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
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

class _ChoiceHistoryPanel extends StatelessWidget {
  final GameState gameState;

  const _ChoiceHistoryPanel({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final history = gameState.selectedChoiceHistory;
    final scenarioTitles = demoScenarios.map((s) => s.title).toList();

    return PixelPanel(
      title: 'CHOICES MADE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Here is how Alex\'s day unfolded through your choices:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          ...history.asMap().entries.map((entry) {
            final i = entry.key;
            final choice = entry.value;
            final title = i < scenarioTitles.length ? scenarioTitles[i] : '';
            final time = i < demoScenarios.length
                ? demoScenarios[i].timeLabel
                : '';
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                color: AppColors.surfaceVariant,
                child: Text(
                  '$number. $scenarioTitle',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: TextStyle(color: AppColors.textMuted, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            choiceLabel,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StrategiesSummary extends StatelessWidget {
  final GameState gameState;

  const _StrategiesSummary({required this.gameState});

  @override
  Widget build(BuildContext context) {
    final choices = gameState.selectedChoiceHistory;
    final helpful = <String>[];
    final demanding = <String>[];

    for (final choice in choices) {
      if (choice.contains('smaller steps') ||
          choice.contains('movement break') ||
          choice.contains('visual design') ||
          choice.contains('rest') ||
          choice.contains('music')) {
        helpful.add(choice);
      }
      if (choice.contains('without planning') ||
          choice.contains('silently') ||
          choice.contains('everything is finished')) {
        demanding.add(choice);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WHAT SHAPED TODAY',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        if (helpful.isNotEmpty) ...[
          _SummaryGroup(
            label: 'Strategies that helped',
            color: AppColors.accentGreen,
            icon: Icons.arrow_upward,
            items: helpful,
          ),
          const SizedBox(height: 10),
        ],
        if (demanding.isNotEmpty) ...[
          _SummaryGroup(
            label: 'Approaches that increased demand',
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
              fontSize: 13,
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
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
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
                fontSize: 12,
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
            'Can Alex do a favorite activity?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _ActivityRow(
            activity: demoCharacter.highEnergyActivity,
            label: 'HIGH ENERGY',
            available: canHigh,
            unavailableReason: canHigh
                ? null
                : 'Burnout is too high and energy too low for a high-demand activity right now. Wanting to do something does not always mean having the available capacity to do it. This is not a choice — it is a result of accumulated demand.',
          ),
          const SizedBox(height: 8),
          _ActivityRow(
            activity: demoCharacter.lowEnergyActivity,
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
                ? 'Alex has enough capacity to engage in a preferred creative project tonight.'
                : canLow
                ? 'Alex can enjoy music, though the higher-demand creative project is beyond reach right now.'
                : 'Alex needs rest above all else tonight. Recovery is not giving up — it is what makes tomorrow possible.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
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
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            activity,
            style: TextStyle(
              color: available ? AppColors.textPrimary : AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          if (!available && unavailableReason != null) ...[
            const SizedBox(height: 8),
            Text(
              unavailableReason!,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
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
  @override
  Widget build(BuildContext context) {
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
            'Which choice best matched Alex\'s needs, and what made it helpful?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ReadingText(
            'Consider: Which strategies reduced demand without removing Alex from participation? Were there moments where speaking up changed the outcome? What would have happened if Alex had more energy at the end of the day?',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          Text(
            'Different players may make different choices — and different people in real life will have different needs. There is no single correct path through Alex\'s day.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
              height: 1.5,
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
            label: const Text('Play Again'),
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
          const SizedBox(height: 12),
          Text(
            'Try different choices to see how the outcomes change. No path through the simulation is a failure.',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
