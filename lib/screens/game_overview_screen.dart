import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../data/demo_character.dart';
import '../models/game_state.dart';
import '../widgets/pixel_panel.dart';
import '../widgets/site_navigation.dart';

class GameOverviewScreen extends StatelessWidget {
  final GameState gameState;

  const GameOverviewScreen({super.key, required this.gameState});

  void _startGame(BuildContext context) {
    gameState.reset();
    Navigator.pushNamed(context, AppRoutes.play);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(activeSection: AppRoutes.about),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    isMobile: isMobile,
                    onPlay: () => _startGame(context),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 80,
                      vertical: 48,
                    ),
                    child: isMobile
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _CharacterPanel(),
                              const SizedBox(height: 24),
                              _GameMechanicsPanel(),
                              const SizedBox(height: 24),
                              _PlayCTA(onPlay: () => _startGame(context)),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _CharacterPanel(),
                                    const SizedBox(height: 24),
                                    _PlayCTA(onPlay: () => _startGame(context)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 32),
                              Expanded(flex: 3, child: _GameMechanicsPanel()),
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

class _Header extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onPlay;

  const _Header({required this.isMobile, required this.onPlay});

  @override
  Widget build(BuildContext context) {
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
            color: AppColors.accent.withValues(alpha: 0.15),
            child: Text(
              'ABOUT THE GAME',
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
            'Burnout: One More Day',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ReadingText(
              'A choice-based simulation about one neurodivergent student\'s day. Explore how demands, strengths, and recovery shape burnout — and what changes when you advocate for what you need.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CharacterPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'PROTOTYPE CHARACTER',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              color: AppColors.surfaceVariant,
              child: Icon(Icons.person, color: AppColors.accent, size: 48),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              demoCharacter.name,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Center(
            child: Text(
              '${demoCharacter.age} · ${demoCharacter.context}',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          ReadingText(
            demoCharacter.shortDescription,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          _CharacterSection(
            label: 'STRENGTHS',
            color: AppColors.accentGreen,
            items: demoCharacter.strengths,
          ),
          const SizedBox(height: 12),
          _CharacterSection(
            label: 'SUPPORTIVE STRATEGIES',
            color: AppColors.focusColor,
            items: demoCharacter.supportiveStrategies,
          ),
          const SizedBox(height: 12),
          _CharacterSection(
            label: 'FAVORITE ACTIVITIES',
            color: AppColors.motivationColor,
            items: [
              'Low energy: ${demoCharacter.lowEnergyActivity}',
              'High energy: ${demoCharacter.highEnergyActivity}',
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Text(
              demoCharacter.disclaimer,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
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

class _CharacterSection extends StatelessWidget {
  final String label;
  final Color color;
  final List<String> items;

  const _CharacterSection({
    required this.label,
    required this.color,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 5, right: 8),
                  color: color.withValues(alpha: 0.6),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GameMechanicsPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'HOW THE SIMULATION WORKS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadingText(
            'You guide Alex through three scenarios during a single school day. Each choice you make affects Alex\'s internal state — and some choices have ripple effects that change what\'s possible later.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          _MechanicBlock(
            title: 'Status Meters',
            icon: Icons.bar_chart,
            color: AppColors.focusColor,
            description:
                'Track Energy, Focus, Stress, Motivation, Life Satisfaction, and Self-Advocacy. These interact to determine Alex\'s burnout level. No single meter is the goal — balance matters.',
          ),
          _MechanicBlock(
            title: 'Burnout Level',
            icon: Icons.warning_amber_outlined,
            color: AppColors.accentAmber,
            description:
                'Burnout is derived from multiple factors: low energy, high stress, low motivation, and limited self-advocacy. As burnout rises, the interface reflects Alex\'s experience, and some activities may become unavailable.',
          ),
          _MechanicBlock(
            title: 'Educational Feedback',
            icon: Icons.lightbulb_outline,
            color: AppColors.accentGreen,
            description:
                'After every choice, you receive supportive educational context explaining what happened and why — without labeling choices "good" or "bad."',
          ),
          _MechanicBlock(
            title: 'End-of-Day Results',
            icon: Icons.summarize_outlined,
            color: AppColors.motivationColor,
            description:
                'See a summary of Alex\'s day: what helped, what contributed to burnout, and whether Alex has enough capacity left for a favorite activity.',
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 16),
          _ScenarioList(),
        ],
      ),
    );
  }
}

class _MechanicBlock extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String description;

  const _MechanicBlock({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 14),
            color: color.withValues(alpha: 0.15),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ReadingText(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scenarios = [
      (
        '8:00 AM',
        'Morning Planning',
        'A long task list and three ways to start the day.',
      ),
      (
        '10:30 AM',
        'Class Project',
        'An assigned role and the option to advocate for a better fit.',
      ),
      (
        '4:00 PM',
        'End of Day',
        'Limited energy, unfinished work, and a choice about rest.',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SCENARIO OVERVIEW',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        ...scenarios.asMap().entries.map(
          (e) => _ScenarioRow(
            number: e.key + 1,
            time: e.value.$1,
            title: e.value.$2,
            description: e.value.$3,
          ),
        ),
      ],
    );
  }
}

class _ScenarioRow extends StatelessWidget {
  final int number;
  final String time;
  final String title;
  final String description;

  const _ScenarioRow({
    required this.number,
    required this.time,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(left: BorderSide(color: AppColors.border, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            margin: const EdgeInsets.only(right: 12),
            color: AppColors.surfaceVariant,
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                ReadingText(
                  description,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayCTA extends StatelessWidget {
  final VoidCallback onPlay;

  const _PlayCTA({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      borderColor: AppColors.accent.withValues(alpha: 0.4),
      backgroundColor: const Color(0xFF0d1a2e),
      child: Column(
        children: [
          Icon(Icons.play_circle_outline, color: AppColors.accent, size: 36),
          const SizedBox(height: 12),
          Text(
            'Ready to play?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The prototype takes about 5–10 minutes.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onPlay,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
            ),
            child: const Text('Play the Prototype'),
          ),
        ],
      ),
    );
  }
}
