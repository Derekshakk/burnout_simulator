import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/session_navigation.dart';
import '../data/character_registry.dart';
import '../app/theme.dart';
import '../models/character_profile.dart';
import '../models/game_scenario.dart';
import '../models/game_state.dart';
import '../widgets/site_navigation.dart';
import '../widgets/section_label.dart';

class CharacterSelectScreen extends StatelessWidget {
  final GameState gameState;

  const CharacterSelectScreen({super.key, required this.gameState});

  void _selectCharacter(
    BuildContext context,
    CharacterProfile character,
    List<GameScenario> scenarios,
  ) {
    gameState.selectCharacter(character, scenarios);
    SessionNavigation.openPlay(context, gameState);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(activeSection: AppRoutes.select, gameState: gameState),
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
                    const SizedBox(height: 24),
                    _SimulationIntro(),
                    const SizedBox(height: 32),
                    _CharacterGrid(
                      isMobile: isMobile,
                      onSelect: (character, scenarios) =>
                          _selectCharacter(context, character, scenarios),
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

class _SimulationIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ABOUT THIS SIMULATION',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          ReadingText(
            'Project Ignite is an educational simulation of one neurodivergent student\'s school day. The goal is not to win — it\'s to explore how demands, recovery, and self-advocacy interact.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          _IntroBullet(
            title: 'Choose a character',
            body:
                'Each profile has different strengths, burnout triggers, and recovery strategies. The day unfolds differently depending on who you play as.',
          ),
          const SizedBox(height: 8),
          _IntroBullet(
            title: 'Make choices across 5 self-paced scenarios',
            body:
                'Decisions affect energy, stress, and capacity. Some choices carry forward — later scenarios may reflect what happened earlier in the day.',
          ),
          const SizedBox(height: 8),
          _IntroBullet(
            title: 'Watch the meters',
            body:
                'Burnout rises when demands consistently exceed recovery. There are no right or wrong choices — the meters show what each path costs and what it preserves.',
          ),
        ],
      ),
    );
  }
}

class _IntroBullet extends StatelessWidget {
  final String title;
  final String body;

  const _IntroBullet({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(top: 5, right: 8),
          decoration: BoxDecoration(
            color: AppColors.accentText,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title: ',
                  style: TextStyle(
                    color: AppColors.accentText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                TextSpan(
                  text: body,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.5,
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

class _CharacterGrid extends StatelessWidget {
  final bool isMobile;
  final void Function(CharacterProfile, List<GameScenario>) onSelect;

  const _CharacterGrid({required this.isMobile, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final accents = [
      AppColors.accentText,
      AppColors.accentPurple,
      AppColors.accentAmber,
    ];
    final cards = registeredCharacters.asMap().entries.map((entry) {
      final registration = entry.value;
      return _CharacterCard(
        character: registration.profile,
        scenarios: registration.scenarios,
        accentColor: accents[entry.key % accents.length],
        onSelect: onSelect,
      );
    }).toList();

    if (isMobile) {
      return Column(
        children:
            cards.expand((card) => [card, const SizedBox(height: 20)]).toList()
              ..removeLast(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 20) / 2;
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: cards
              .map((card) => SizedBox(width: cardWidth, child: card))
              .toList(),
        );
      },
    );
  }
}

class _SelectHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionLabel(text: 'CHOOSE YOUR CHARACTER'),
        const SizedBox(height: 14),
        A11yHeading(
          'Who will you guide today?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
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
              fontSize: 16,
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
                  _CharacterPortrait(character: c, accentColor: accent),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.name,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${c.age} · ${c.context}',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Semantics(
                          label: 'Gender: ${c.gender}. Pronouns: ${c.pronouns}',
                          child: ExcludeSemantics(
                            child: Text(
                              '${c.gender.toUpperCase()} · ${c.pronouns.toUpperCase()}',
                              style: TextStyle(
                                color: accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                color: accent.withValues(alpha: 0.15),
                child: Text(
                  c.neurodivergenceType.toUpperCase(),
                  style: TextStyle(
                    color: accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(color: AppColors.border, height: 1),
              const SizedBox(height: 16),
              ReadingText(
                c.shortDescription,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
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
                      '${widget.scenarios.length} short scenarios · self-paced',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 14,
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
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.textPrimary,
                    side: BorderSide(color: AppColors.borderBright),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppTheme.buttonRadius,
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
            fontSize: 13,
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
                      fontSize: 14,
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
                fontSize: 14,
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

// ── Character portrait ─────────────────────────────────────────────────────────

class _CharacterPortrait extends StatelessWidget {
  final CharacterProfile character;
  final Color accentColor;

  const _CharacterPortrait({
    required this.character,
    required this.accentColor,
  });

  // Derives a hair-tone index from the character id — stable and future-proof.
  int get _hairIndex => character.id.codeUnitAt(0) % 3;

  static const _hairTones = [
    Color(0xFF3D2D1F), // dark warm brown
    Color(0xFF1C1C2E), // near-black / dark cool
    Color(0xFF5C3D1E), // medium chestnut
  ];

  @override
  Widget build(BuildContext context) {
    final hairColor = _hairTones[_hairIndex];
    final noAnimation = MediaQuery.of(context).disableAnimations;

    final portrait = character.portraitImagePath != null
        ? Semantics(
            label: 'Portrait of ${character.name}',
            child: Image.asset(
              character.portraitImagePath!,
              width: 100,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, err, stack) => _PixelPortrait(
                accentColor: accentColor,
                hairColor: hairColor,
                characterName: character.name,
              ),
            ),
          )
        : _PixelPortrait(
            accentColor: accentColor,
            hairColor: hairColor,
            characterName: character.name,
          );

    if (noAnimation) return portrait;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 450),
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: portrait,
    );
  }
}

class _PixelPortrait extends StatelessWidget {
  final Color accentColor;
  final Color hairColor;
  final String characterName;

  const _PixelPortrait({
    required this.accentColor,
    required this.hairColor,
    required this.characterName,
  });

  static const _skinTone = Color(0xFFE8C99A);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$characterName — pixel portrait',
      child: Container(
        width: 100,
        height: 120,
        color: accentColor.withValues(alpha: 0.08),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hair
              Container(width: 44, height: 10, color: hairColor),
              // Head
              Container(width: 40, height: 30, color: _skinTone),
              // Body / shirt
              Container(
                width: 52,
                height: 30,
                color: accentColor.withValues(alpha: 0.85),
              ),
              // Legs
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 12,
                    color: accentColor.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 16,
                    height: 12,
                    color: accentColor.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
