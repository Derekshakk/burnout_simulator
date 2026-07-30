import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/theme.dart';
import 'pixel_panel.dart';

class EducationalFeedbackCard extends StatelessWidget {
  final String choiceLabel;
  final String feedbackText;
  final VoidCallback onContinue;
  final bool isLastScenario;

  const EducationalFeedbackCard({
    super.key,
    required this.choiceLabel,
    required this.feedbackText,
    required this.onContinue,
    this.isLastScenario = false,
  });

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title: 'WHAT HAPPENED',
      borderColor: AppColors.textPrimary,
      backgroundColor: AppColors.feedbackSurface,
      titleBackgroundColor: AppColors.feedbackSurface,
      titleTextColor: AppColors.textPrimary,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(
                left: BorderSide(color: AppColors.accentAmber, width: 3),
              ),
            ),
            child: Text(
              '"$choiceLabel"',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 22,
                height: 22,
                margin: const EdgeInsets.only(right: 10, top: 1),
                alignment: Alignment.center,
                color: AppColors.accentAmber.withValues(alpha: 0.2),
                child: Text(
                  '!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: ReadingText(
                  feedbackText,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    height: 1.65,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: AppColors.textPrimary.withValues(alpha: 0.5),
            height: 1,
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final note = Text(
                'Different people may respond differently.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
              );
              final continueButton = ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.highContrast
                      ? AppColors.accent
                      : AppColors.navBackground,
                  foregroundColor: AppColors.highContrast
                      ? AppColors.textPrimary
                      : AppColors.textOnDark,
                  side: BorderSide(color: AppColors.textPrimary, width: 1),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Text(isLastScenario ? 'See Results' : 'Continue'),
              );

              if (constraints.maxWidth < 440) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    note,
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: continueButton,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: note),
                  const SizedBox(width: 16),
                  continueButton,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
