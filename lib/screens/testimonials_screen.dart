import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../data/testimonials.dart';
import '../models/game_state.dart';
import '../services/external_action_service.dart';
import '../widgets/section_label.dart';
import '../widgets/site_navigation.dart';

/// Public "Testimonials" page: lived experiences related to neurodivergent
/// burnout, presented as individual readable cards. Content lives in
/// `lib/data/testimonials.dart`; wording is reproduced faithfully.
class TestimonialsScreen extends StatelessWidget {
  final GameState gameState;

  const TestimonialsScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: AppRoutes.testimonials,
            gameState: gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(isMobile: isMobile),
                  _TestimonialsBody(isMobile: isMobile),
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
          const SectionLabel(text: 'TESTIMONIALS'),
          const SizedBox(height: 20),
          A11yHeading(
            'Testimonials',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadingText(
                  'These are real experiences related to neurodivergent '
                  'burnout, shared in people\'s own words. They describe what '
                  'burnout can feel like and what has helped.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 17,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 12),
                ReadingText(
                  'Experiences vary from person to person. These accounts are '
                  'individual perspectives and do not represent every '
                  'neurodivergent person.',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 15,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const _ShareButton(),
        ],
      ),
    );
  }
}

/// Opens the external testimonials form in a new tab. Uses the popup-blocker-
/// safe launcher so it works on Firebase Hosting, not just localhost.
class _ShareButton extends StatelessWidget {
  const _ShareButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Share your experience — opens the testimonials form in a new tab',
      child: ElevatedButton.icon(
        onPressed: () => ExternalActionService.openWebsite(
          ExternalActionService.testimonialsFormUrl,
        ),
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: const Text('Share Your Experience'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: const RoundedRectangleBorder(
            borderRadius: AppTheme.buttonRadius,
          ),
        ),
      ),
    );
  }
}

class _TestimonialsBody extends StatelessWidget {
  final bool isMobile;

  const _TestimonialsBody({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      color: AppColors.surfaceVariant,
      child: Center(
        // A single readable column keeps long quotes from becoming cramped in
        // narrow cards, while staying responsive on tablet and mobile.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TestimonialCard(testimonial: featuredTestimonial),
              const SizedBox(height: 32),
              // Attribution for the externally sourced testimonials.
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accentAmber.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.accentAmber.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.public_outlined,
                      color: AppColors.accentAmber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ReadingText(
                        testimonialsSourceNote,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 15,
                          height: 1.55,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              for (final t in sourcedTestimonials) ...[
                _TestimonialCard(testimonial: t),
                const SizedBox(height: 20),
              ],
              const SizedBox(height: 12),
              const _ClosingShare(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final Testimonial testimonial;

  const _TestimonialCard({required this.testimonial});

  @override
  Widget build(BuildContext context) {
    final featured = testimonial.featured;
    final borderColor = featured ? AppColors.accent : AppColors.cardBorderGold;

    return Semantics(
      container: true,
      label: featured
          ? 'Featured testimonial, ${testimonial.attribution}'
          : 'Testimonial from ${testimonial.attribution}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: featured
              ? AppColors.accent.withValues(alpha: 0.08)
              : AppColors.surface,
          border: Border.all(color: borderColor, width: featured ? 2 : 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  featured ? Icons.star_rounded : Icons.format_quote_rounded,
                  color: featured ? AppColors.accent : AppColors.accentText,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    testimonial.attribution,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (var i = 0; i < testimonial.paragraphs.length; i++) ...[
              if (i > 0) const SizedBox(height: 12),
              ReadingText(
                testimonial.paragraphs[i],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  height: 1.7,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A quieter, secondary call to action at the end of the list.
class _ClosingShare extends StatelessWidget {
  const _ClosingShare();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          A11yHeading(
            'Share your experience',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ReadingText(
            'If you would like to add your own experience with burnout, you can '
            'fill out our form. Sharing is optional, and every experience is '
            'different.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 18),
          const _ShareButton(),
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
