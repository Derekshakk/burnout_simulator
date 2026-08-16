import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import '../services/external_action_service.dart';
import '../widgets/section_label.dart';
import '../widgets/site_navigation.dart';

/// A single internal research subtab. Adding a new research topic later is a
/// matter of appending one entry to [_ResearchScreenState._tabs] — the tab bar
/// and content area are both driven off this list.
class _ResearchTab {
  final String label;

  /// Shorter label used inside the tab chip so wide labels stay compact.
  final String shortLabel;
  final IconData icon;
  final Widget Function(bool isMobile) contentBuilder;

  const _ResearchTab({
    required this.label,
    required this.shortLabel,
    required this.icon,
    required this.contentBuilder,
  });
}

class ResearchScreen extends StatefulWidget {
  final GameState gameState;

  /// Optional index of the subtab to open first. Defaults to the first tab.
  final int initialTab;

  const ResearchScreen({
    super.key,
    required this.gameState,
    this.initialTab = 0,
  });

  @override
  State<ResearchScreen> createState() => _ResearchScreenState();
}

class _ResearchScreenState extends State<ResearchScreen> {
  late int _selected;

  late final List<_ResearchTab> _tabs = [
    _ResearchTab(
      label: 'Universal Design for Learning & Strength-Based Model',
      shortLabel: 'UDL & Strength-Based Model',
      icon: Icons.architecture_outlined,
      contentBuilder: (isMobile) => _UdlSection(isMobile: isMobile),
    ),
    _ResearchTab(
      label: 'What Is Autistic Burnout?',
      shortLabel: 'Autistic Burnout',
      icon: Icons.psychology_outlined,
      contentBuilder: (isMobile) => _AutisticBurnoutSection(isMobile: isMobile),
    ),
    _ResearchTab(
      label: 'What Is ADHD Burnout?',
      shortLabel: 'ADHD Burnout',
      icon: Icons.bolt_outlined,
      contentBuilder: (isMobile) => _AdhdBurnoutSection(isMobile: isMobile),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.initialTab.clamp(0, _tabs.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    final horizontal = isMobile ? 20.0 : 80.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: AppRoutes.research,
            gameState: widget.gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(isMobile: isMobile),
                  // Tab bar shares the content container's horizontal padding so
                  // it stays aligned with the body rather than drifting right.
                  Padding(
                    padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 0),
                    child: _ResearchTabBar(
                      tabs: _tabs,
                      selectedIndex: _selected,
                      onSelected: (i) => setState(() => _selected = i),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(horizontal, 32, horizontal, 8),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 900),
                      child: _tabs[_selected].contentBuilder(isMobile),
                    ),
                  ),
                  _DisclaimerSection(isMobile: isMobile),
                  _PageFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final bool isMobile;

  const _PageHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 56,
      ),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: 'RESEARCH'),
          const SizedBox(height: 20),
          A11yHeading(
            'Research',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ReadingText(
              'The frameworks and lived-experience research behind Project Ignite. '
              'Use the tabs below to explore how supportive learning environments '
              'are designed, and what current research says about burnout for '
              'neurodivergent people.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Internal subtab bar ───────────────────────────────────────────────────────

class _ResearchTabBar extends StatelessWidget {
  final List<_ResearchTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const _ResearchTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap keeps the chips on one row when there is space and lets them flow to
    // the next line on narrow screens — no horizontal overflow either way.
    return Semantics(
      container: true,
      label: 'Research topics',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          for (var i = 0; i < tabs.length; i++)
            _ResearchTabChip(
              tab: tabs[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
        ],
      ),
    );
  }
}

class _ResearchTabChip extends StatefulWidget {
  final _ResearchTab tab;
  final bool selected;
  final VoidCallback onTap;

  const _ResearchTabChip({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_ResearchTabChip> createState() => _ResearchTabChipState();
}

class _ResearchTabChipState extends State<_ResearchTabChip> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    // Selection is signalled by more than colour: a filled surface, a heavier
    // 2px border, a bottom accent bar, bold text, and a leading check icon.
    final borderColor = _focused
        ? AppColors.focusRing
        : selected
        ? AppColors.accentText
        : AppColors.border;

    return Semantics(
      button: true,
      selected: selected,
      label: widget.tab.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: FocusableActionDetector(
          onShowFocusHighlight: (f) => setState(() => _focused = f),
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              constraints: const BoxConstraints(maxWidth: 420, minHeight: 44),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accent.withValues(alpha: 0.22)
                    : _hovered
                    ? AppColors.surfaceVariant
                    : AppColors.surface,
                border: Border(
                  top: BorderSide(
                    color: borderColor,
                    width: selected || _focused ? 2 : 1,
                  ),
                  left: BorderSide(
                    color: borderColor,
                    width: selected || _focused ? 2 : 1,
                  ),
                  right: BorderSide(
                    color: borderColor,
                    width: selected || _focused ? 2 : 1,
                  ),
                  bottom: BorderSide(
                    color: selected ? AppColors.accentText : borderColor,
                    width: selected ? 3 : (_focused ? 2 : 1),
                  ),
                ),
                borderRadius: AppTheme.compactButtonRadius,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? Icons.check_circle : widget.tab.icon,
                    size: 16,
                    color: selected
                        ? AppColors.accentText
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      widget.tab.shortLabel,
                      maxLines: 3,
                      style: TextStyle(
                        color: selected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        fontSize: 15,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared content building blocks ───────────────────────────────────────────

class _TabTitle extends StatelessWidget {
  final String text;

  const _TabTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return A11yHeading(text, style: Theme.of(context).textTheme.headlineMedium);
  }
}

class _SubHeading extends StatelessWidget {
  final String text;

  const _SubHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return A11yHeading(
      text,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final String text;

  const _Body(this.text);

  @override
  Widget build(BuildContext context) {
    return ReadingText(
      text,
      style: TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        height: 1.7,
      ),
    );
  }
}

/// A bordered content card matching the site's panel treatment.
class _InfoCard extends StatelessWidget {
  final IconData? icon;
  final String? title;
  final List<Widget> children;
  final Color? borderColor;

  const _InfoCard({
    this.icon,
    this.title,
    required this.children,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: borderColor ?? AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: AppColors.accentText, size: 20),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: A11yHeading(
                    title!,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          ...children,
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color? bulletColor;

  const _BulletList({required this.items, this.bulletColor});

  @override
  Widget build(BuildContext context) {
    final color = bulletColor ?? AppColors.accent;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 9, right: 10),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: ReadingText(
                    item,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Tab 1: UDL & Strength-Based Model ────────────────────────────────────────

class _UdlSection extends StatelessWidget {
  final bool isMobile;

  const _UdlSection({required this.isMobile});

  static const _videoUrl =
      'https://www.youtube.com/watch?v=uO3EYG8M3n8&feature=youtu.be';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TabTitle('Universal Design for Learning'),
        const SizedBox(height: 12),
        const _Body(
          'Universal Design for Learning (UDL) is a framework for optimizing '
          'teaching and learning based on research about how people learn and '
          'the predictable variability among learners.',
        ),
        const SizedBox(height: 24),
        const _SubHeading('UDL focuses on three areas'),
        const SizedBox(height: 16),
        _UdlAreas(isMobile: isMobile),
        const SizedBox(height: 40),
        const _TabTitle('Strength-Based Model vs. Medical Model'),
        const SizedBox(height: 12),
        const _Body(
          'Two models offer different starting points for understanding '
          'neurodivergence. They are not mutually exclusive, but they place '
          'emphasis differently.',
        ),
        const SizedBox(height: 20),
        _ModelComparison(isMobile: isMobile),
        const SizedBox(height: 20),
        _GuidingQuestions(),
        const SizedBox(height: 20),
        _ModelConclusion(),
        const SizedBox(height: 28),
        _WatchVideoButton(url: _videoUrl),
        const SizedBox(height: 40),
        _ResearchSources(),
      ],
    );
  }
}

class _UdlAreas extends StatelessWidget {
  final bool isMobile;

  const _UdlAreas({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const areas = [
      (
        icon: Icons.emoji_objects_outlined,
        title: 'Engagement',
        body: 'Different ways for students to be motivated.',
        example: 'Example: students have choices in what they work on.',
      ),
      (
        icon: Icons.menu_book_outlined,
        title: 'Representation',
        body: 'Different ways to present information to students.',
        example:
            'Example: options for language and symbols, including text-to-speech.',
      ),
      (
        icon: Icons.gesture_outlined,
        title: 'Action and Expression',
        body: 'Different ways for students to demonstrate learning.',
        example:
            'Example: one student may write an essay while another creates a '
            'presentation, diagram, or project.',
      ),
    ];

    final cards = [
      for (final a in areas)
        _InfoCard(
          icon: a.icon,
          title: a.title,
          children: [
            _Body(a.body),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border(
                  left: BorderSide(color: AppColors.accentText, width: 3),
                ),
              ),
              child: ReadingText(
                a.example,
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
    ];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            cards[i],
          ],
        ],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Expanded(child: cards[i]),
          ],
        ],
      ),
    );
  }
}

class _ModelComparison extends StatelessWidget {
  final bool isMobile;

  const _ModelComparison({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final strength = _InfoCard(
      icon: Icons.trending_up,
      title: 'Strength-Based Model',
      borderColor: AppColors.accentGreen.withValues(alpha: 0.5),
      children: const [
        _BulletListGreen(
          items: [
            'Recognizes differences within human brains as natural.',
            'Focuses on strengths, talents, and potential.',
            'Changes the learning environment to reduce barriers.',
            'Helps people use their strengths while supporting areas that are '
                'difficult.',
          ],
        ),
      ],
    );

    final medical = _InfoCard(
      icon: Icons.local_hospital_outlined,
      title: 'Medical Model',
      borderColor: AppColors.focusColor.withValues(alpha: 0.5),
      children: const [
        _BulletListFocus(
          items: [
            'Primarily views conditions as disorders or impairments within the '
                'individual.',
            'May involve diagnosis, treatment, medication, therapy, behavioral '
                'interventions, or coping strategies.',
            'These supports can provide important access to healthcare.',
            'However, focusing too heavily on deficits may contribute to stigma '
                'or place responsibility mainly on the individual to adapt.',
          ],
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [strength, const SizedBox(height: 16), medical],
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: strength),
          const SizedBox(width: 16),
          Expanded(child: medical),
        ],
      ),
    );
  }
}

class _BulletListGreen extends StatelessWidget {
  final List<String> items;

  const _BulletListGreen({required this.items});

  @override
  Widget build(BuildContext context) =>
      _BulletList(items: items, bulletColor: AppColors.accentGreen);
}

class _BulletListFocus extends StatelessWidget {
  final List<String> items;

  const _BulletListFocus({required this.items});

  @override
  Widget build(BuildContext context) =>
      _BulletList(items: items, bulletColor: AppColors.focusColor);
}

class _GuidingQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const questions = [
      'What does the learner do well?',
      'What motivates them?',
      'How can their strengths support learning?',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withValues(alpha: 0.08),
        border: Border.all(
          color: AppColors.accentGreen.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline, color: AppColors.accentGreen, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: A11yHeading(
                  'Guiding questions for the Strength-Based Model',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final q in questions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ReadingText(
                '“$q”',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModelConclusion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(left: BorderSide(color: AppColors.accentText, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ConclusionLine(
            term: 'UDL',
            body:
                'How can we design the learning environment to reduce barriers '
                'for everyone?',
          ),
          const SizedBox(height: 12),
          _ConclusionLine(
            term: 'Strength-Based Model',
            body:
                'How can we recognize and build upon what each learner does '
                'well?',
          ),
        ],
      ),
    );
  }
}

class _ConclusionLine extends StatelessWidget {
  final String term;
  final String body;

  const _ConclusionLine({required this.term, required this.body});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
          height: 1.6,
        ),
        children: [
          TextSpan(
            text: '$term = ',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(text: body),
        ],
      ),
    );
  }
}

class _WatchVideoButton extends StatelessWidget {
  final String url;

  const _WatchVideoButton({required this.url});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => ExternalActionService.openWebsite(url),
      icon: const Icon(Icons.play_circle_outline, size: 18),
      label: const Text('Watch the Video'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.navBackground,
        foregroundColor: AppColors.textOnDark,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }
}

class _ResearchSources extends StatelessWidget {
  static const _sources = [
    (
      label: 'CAST — Universal Design for Learning Guidelines',
      url: 'https://udlguidelines.cast.org/',
    ),
    (
      label:
          'Monterey County Office of Education — Universal Design for Learning',
      url: 'https://www.montereycoe.org/',
    ),
    (
      label:
          'American Psychiatric Association — Exploring a Strengths-Based Approach to Neurodiversity',
      url:
          'https://www.psychiatry.org/news-room/apa-blogs/exploring-a-strengths-based-approach-to-neurodiver',
    ),
    (
      label: 'Stanford SNP-REACH 2026',
      url:
          'https://stanfordneurodiversityproject.stanford.edu/neurodiversity-education/snp-reach-2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link, color: AppColors.textMuted, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'RESEARCH SOURCES',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final s in _sources)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.only(top: 9, right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accentText,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: A11yLink(
                    label: s.label,
                    onTap: () => ExternalActionService.openWebsite(s.url),
                    style: TextStyle(
                      color: AppColors.accentText,
                      fontSize: 15,
                      height: 1.6,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Tab 2: Autistic Burnout (research-team-approved content) ──────────────────

class _AutisticBurnoutSection extends StatelessWidget {
  final bool isMobile;

  const _AutisticBurnoutSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TabTitle('What Is Autistic Burnout?'),
        const SizedBox(height: 12),
        const _Body(
          'Autistic burnout is a long-term state of physical, mental, and '
          'emotional exhaustion experienced by many autistic individuals. It is '
          'triggered by the cumulative effects of masking and coping with '
          'overwhelming environments — not ordinary tiredness or a temporary '
          'slump. Experiences vary widely from person to person.',
        ),
        const SizedBox(height: 24),
        _InfoCard(
          icon: Icons.warning_amber_outlined,
          title: 'What causes autistic burnout?',
          children: const [
            _Body('Causes may include:'),
            SizedBox(height: 10),
            _BulletList(
              items: [
                'Autistic masking — adjusting behavior to appear neurotypical, '
                    'such as suppressing stimming or forcing eye contact. Masking '
                    'requires significant energy and accumulates over time.',
                'People pleasing — continually prioritizing others’ comfort over '
                    'one’s own needs.',
                'Sensory overload — prolonged exposure to overwhelming sounds, '
                    'lights, textures, or other sensory input.',
                'Lack of accommodations — facing environments or demands that do '
                    'not account for neurodivergent needs.',
                'Executive functioning overload — sustained effort in planning, '
                    'transitioning, and self-regulating beyond available capacity.',
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.self_improvement,
          title: 'How to prevent autistic burnout?',
          children: const [
            _Body(
              'Mindfulness practices such as meditation, yoga, and journaling '
              'may help by reducing sensory inputs, lowering stress levels, and '
              'increasing mindful awareness. Surrounding oneself with people who '
              'offer genuine acceptance and validate one’s concerns may also '
              'reduce the need for sustained masking.',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.spa_outlined,
          title: 'What are tools to alleviate autistic burnout?',
          children: const [
            _Body('Helpful approaches may include:'),
            SizedBox(height: 10),
            _BulletList(
              items: [
                'Addressing sensory needs — finding quieter spaces, adjusting '
                    'lighting, or using sensory tools.',
                'Stimming whenever possible — allowing natural self-regulatory '
                    'movements and behaviors.',
                'Limiting social obligations — reducing demands that require '
                    'sustained masking or social performance.',
                'Leaning into comfort activities — familiar, low-demand '
                    'activities that feel restorative.',
                'Allowing permission to rest — recognizing rest as necessary and '
                    'restorative, not a failure.',
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.battery_0_bar,
          title: 'Capacity changes with burnout',
          children: const [
            _Body(
              'When burnout is high, activities that are normally possible may '
              'become genuinely inaccessible — including activities the person '
              'enjoys and wants to do. This is not a choice or a character flaw, '
              'and recovery is how capacity is restored for future demands.',
            ),
          ],
        ),
      ],
    );
  }
}

// ── Tab 3: ADHD Burnout (research-team-approved content) ─────────────────────

class _AdhdBurnoutSection extends StatelessWidget {
  final bool isMobile;

  const _AdhdBurnoutSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _TabTitle('What Is ADHD Burnout?'),
        const SizedBox(height: 12),
        const _Body(
          'ADHD burnout is a deep state of mental, emotional, and physical '
          'exhaustion caused by the chronic stress of trying to manage, mask, '
          'and compensate for ADHD symptoms in a demanding world. Experiences '
          'vary widely from person to person.',
        ),
        const SizedBox(height: 24),
        _InfoCard(
          icon: Icons.warning_amber_outlined,
          title: 'What causes ADHD burnout?',
          children: const [
            _Body('Causes may include:'),
            SizedBox(height: 10),
            _BulletList(
              items: [
                'Executive dysfunction strain — sustained effort to manage '
                    'planning, initiation, and task completion with executive '
                    'function challenges.',
                'ADHD masking — suppressing or concealing ADHD traits to meet '
                    'neurotypical expectations, which requires significant ongoing '
                    'energy.',
                'Overcommitting — taking on more obligations than available '
                    'capacity can support.',
                'Sensory overload — prolonged exposure to overwhelming sensory '
                    'input that exceeds the nervous system\'s ability to regulate.',
                'Emotional dysregulation — intense emotional responses and the '
                    'effort required to manage them in social or academic settings.',
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.self_improvement,
          title: 'How to prevent ADHD burnout?',
          children: const [
            _Body(
              'To prevent ADHD burnout, it is important to protect mental energy '
              'by setting realistic expectations and planning regular rests and '
              'resets. Reducing chronic overcommitment, lowering sensory load, and '
              'creating flexible routines and schedules may also help.',
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoCard(
          icon: Icons.spa_outlined,
          title: 'What are tools to alleviate ADHD burnout?',
          children: const [
            _Body('Helpful approaches may include:'),
            SizedBox(height: 10),
            _BulletList(
              items: [
                'Creating study guide plans — structured tools that may help '
                    'with organization, planning assignments, and managing time '
                    'more effectively.',
                'Reducing daily demands — dropping non-essential obligations to '
                    'create space for recovery.',
              ],
            ),
          ],
        ),
      ],
    );
  }
}

// ── Shared page chrome ───────────────────────────────────────────────────────

class _DisclaimerSection extends StatelessWidget {
  final bool isMobile;

  const _DisclaimerSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 40,
      ),
      color: AppColors.surface,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.accent, size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This page is an educational resource. It is not a clinical '
                  'assessment, diagnostic tool, or substitute for mental health '
                  'support. Neurodivergent experiences vary widely.',
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
    );
  }
}

class _PageFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Ignite — Educational Game for SNP-REACH 2026',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fictional content · Not for diagnosis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Project Ignite — Educational Game for SNP-REACH 2026',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Fictional content · Not for diagnosis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            ),
    );
  }
}
