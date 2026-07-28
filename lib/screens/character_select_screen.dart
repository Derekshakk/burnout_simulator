import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../data/alex_scenarios.dart';
import '../data/demo_character.dart';
import '../data/jordan_character.dart';
import '../data/jordan_scenarios.dart';
import '../models/character_profile.dart';
import '../models/game_scenario.dart';
import '../models/game_state.dart';
import '../widgets/site_navigation.dart';

class CharacterSelectScreen extends StatelessWidget {
  final GameState gameState;

  const CharacterSelectScreen({super.key, required this.gameState});

  void _selectCharacter(
    BuildContext context,
    CharacterProfile character,
    List<GameScenario> scenarios,
  ) {
    gameState.selectCharacter(character, scenarios);
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
          SiteNavigation(activeSection: AppRoutes.select),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 80,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SelectHeader(),
                    const SizedBox(height: 32),
                    isMobile
                        ? Column(
                            children: [
                              _CharacterCard(
                                character: demoCharacter,
                                scenarios: alexScenarios,
                                accentColor: AppColors.accent,
                                onSelect: (c, s) =>
                                    _selectCharacter(context, c, s),
                              ),
                              const SizedBox(height: 20),
                              _CharacterCard(
                                character: jordanCharacter,
                                scenarios: jordanScenarios,
                                accentColor: AppColors.accentPurple,
                                onSelect: (c, s) =>
                                    _selectCharacter(context, c, s),
                              ),
                            ],
                          )
                        : IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _CharacterCard(
                                    character: demoCharacter,
                                    scenarios: alexScenarios,
                                    accentColor: AppColors.accent,
                                    onSelect: (c, s) =>
                                        _selectCharacter(context, c, s),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _CharacterCard(
                                    character: jordanCharacter,
                                    scenarios: jordanScenarios,
                                    accentColor: AppColors.accentPurple,
                                    onSelect: (c, s) =>
                                        _selectCharacter(context, c, s),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    const SizedBox(height: 32),
                    _Disclaimer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: AppColors.accent.withValues(alpha: 0.15),
          child: Text(
            'CHOOSE YOUR CHARACTER',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 14),
        A11yHeading(
          'Who will you guide today?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ReadingText(
            'Each character navigates burnout differently. Choose one to begin their day — the choices you make will reflect their specific strengths, needs, and recovery strategies.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _CharacterCard extends StatefulWidget {
  final CharacterProfile character;
  final List<GameScenario> scenarios;
  final Color accentColor;
  final void Function(CharacterProfile, List<GameScenario>) onSelect;

  const _CharacterCard({
    required this.character,
    required this.scenarios,
    required this.accentColor,
    required this.onSelect,
  });

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.character;
    final accent = widget.accentColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: _hovered
                ? accent.withValues(alpha: 0.8)
                : accent.withValues(alpha: 0.3),
            width: _hovered ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    color: accent.withValues(alpha: 0.15),
                    alignment: Alignment.center,
                    child: Icon(Icons.person, color: accent, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${c.age} · ${c.context}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    color: accent.withValues(alpha: 0.15),
                    child: Text(
                      c.neurodivergenceType.toUpperCase(),
                      style: TextStyle(
                        color: accent,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              ReadingText(
                c.shortDescription,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              _CardSection(
                label: 'STRENGTHS',
                color: AppColors.accentGreen,
                items: c.strengths,
              ),
              const SizedBox(height: 12),
              _CardSection(
                label: 'BURNOUT TRIGGERS',
                color: AppColors.accentAmber,
                items: c.burnoutTriggers.take(3).toList(),
              ),
              const SizedBox(height: 12),
              _CardSection(
                label: 'RECOVERY STRATEGIES',
                color: AppColors.accentPurple,
                items: c.recoveryStrategies.take(3).toList(),
              ),
              const SizedBox(height: 20),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.schedule, color: AppColors.textMuted, size: 13),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${widget.scenarios.length} scenarios · ~10 minutes',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => widget.onSelect(c, widget.scenarios),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    foregroundColor: AppColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                    ),
                  ),
                  child: Text('Play as ${c.name}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardSection extends StatelessWidget {
  final String label;
  final Color color;
  final List<String> items;

  const _CardSection({
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
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 5, right: 8),
                  color: color.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
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

class _Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.textMuted, size: 16),
          const SizedBox(width: 12),
          Expanded(
            child: ReadingText(
              'These fictional characters are created for educational purposes. They do not represent all people with ADHD, autism, or AuDHD. Neurodivergent experiences vary widely — strengths, challenges, and support needs differ from person to person.',
              style: TextStyle(
                color: AppColors.textMuted,
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
