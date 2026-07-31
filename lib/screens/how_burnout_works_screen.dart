import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/session_navigation.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import '../widgets/section_label.dart';
import '../widgets/site_navigation.dart';

class HowBurnoutWorksScreen extends StatelessWidget {
  final GameState gameState;

  const HowBurnoutWorksScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: AppRoutes.burnout,
            gameState: gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(isMobile: isMobile),
                  _PointsSection(isMobile: isMobile),
                  _DisclaimerSection(isMobile: isMobile),
                  _PlayCTA(
                    isMobile: isMobile,
                    onPlay: () =>
                        SessionNavigation.startNewGame(context, gameState),
                  ),
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
          const SectionLabel(text: 'EDUCATIONAL CONTEXT'),
          const SizedBox(height: 20),
          A11yHeading(
            'How Burnout Works',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ReadingText(
              'Neurodivergent burnout is not the same as ordinary tiredness. '
              'Understanding how it builds, what makes it harder, and how '
              'recovery works can shift how we interpret and support the people '
              'experiencing it.',
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

class _PointsSection extends StatelessWidget {
  final bool isMobile;

  const _PointsSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          A11yHeading(
            'What the research tells us',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _BurnoutPoint(
                  icon: Icons.warning_amber_outlined,
                  title: 'Burnout is not laziness',
                  body:
                      'Burnout is a state that results from sustained demand exceeding available capacity. It accumulates over time and may not be immediately visible to others.',
                ),
                _BurnoutPoint(
                  icon: Icons.battery_0_bar,
                  title: 'Capacity changes with burnout',
                  body:
                      'When burnout is high, activities that are normally possible may become genuinely inaccessible — including activities the person enjoys and wants to do. This is not a choice or a character flaw.',
                ),
                _BurnoutPoint(
                  icon: Icons.theater_comedy_outlined,
                  title: 'Masking adds to the load',
                  body:
                      'Masking means adjusting behavior to appear neurotypical in social or academic settings — suppressing stimming, forcing eye contact, or mimicking expected reactions. Masking requires significant energy and accumulates over time, often increasing stress and accelerating burnout even when nothing seems outwardly wrong.',
                ),
                _BurnoutPoint(
                  icon: Icons.self_improvement,
                  title: 'Recovery and coping take many forms',
                  body:
                      'Sustainable functioning requires adequate rest and coping strategies that fit the individual. These may include movement breaks, sensory-friendly environments, structured routines, self-advocacy, or simply unstructured downtime. Choosing rest or using a coping strategy is not giving up — it is how capacity is restored for future demands.',
                ),
                _BurnoutPoint(
                  icon: Icons.diversity_3,
                  title: 'Experiences vary widely',
                  body:
                      'This simulation uses fictional examples. It does not diagnose, nor does it represent every autistic or ADHD experience. Players should not use this game to draw conclusions about themselves or others.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BurnoutPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _BurnoutPoint({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 16),
            color: AppColors.surfaceVariant,
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.accent, size: 18),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                A11yHeading(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ReadingText(
                  body,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.65,
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
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
                      'This game is an educational tool. It is not a clinical assessment, diagnostic tool, or substitute for mental health support.',
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
          ],
        ),
      ),
    );
  }
}

class _PlayCTA extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onPlay;

  const _PlayCTA({required this.isMobile, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 56,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          A11yHeading(
            'Experience it in the simulation',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ReadingText(
              'The simulation lets you make choices alongside a fictional high school student and see how burnout builds across the day — not as an abstraction, but as a set of consequences that become visible through the choices available to you.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(onPressed: onPlay, child: const Text('Play the Game')),
        ],
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
