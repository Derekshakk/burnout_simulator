import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import '../widgets/section_label.dart';
import '../widgets/site_navigation.dart';

class PodcastsScreen extends StatelessWidget {
  final GameState gameState;

  const PodcastsScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: AppRoutes.podcasts,
            gameState: gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(isMobile: isMobile),
                  _PodcastsBody(isMobile: isMobile),
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
          const SectionLabel(text: 'PODCASTS'),
          const SizedBox(height: 20),
          A11yHeading(
            'Listen and learn',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ReadingText(
              'Podcast episodes related to neurodivergence, burnout, and the work behind Project Ignite.',
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

class _PodcastsBody extends StatelessWidget {
  final bool isMobile;

  const _PodcastsBody({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.headphones, color: AppColors.accent, size: 32),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Episodes coming soon',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ReadingText(
                        'We\'re putting together a collection of podcast episodes to share here. Check back soon.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                    ],
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
