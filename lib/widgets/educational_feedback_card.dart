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
      borderColor: AppColors.accentAmber.withValues(alpha: 0.6),
      backgroundColor: const Color(0xFF1a1810),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              border: Border(
                left: BorderSide(
                  color: AppColors.accentAmber.withValues(alpha: 0.6),
                  width: 3,
                ),
              ),
            ),
            child: Text(
              '"$choiceLabel"',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 10, top: 1),
                alignment: Alignment.center,
                color: AppColors.accentAmber.withValues(alpha: 0.2),
                child: Text(
                  '!',
                  style: TextStyle(
                    color: AppColors.accentAmber,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: ReadingText(
                  feedbackText,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Different people may respond differently.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
              ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: Text(isLastScenario ? 'See Results' : 'Continue'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
