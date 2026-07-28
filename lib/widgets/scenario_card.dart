import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/theme.dart';
import '../models/game_scenario.dart';
import 'pixel_panel.dart';

class ScenarioCard extends StatelessWidget {
  final GameScenario scenario;
  final int scenarioNumber;
  final int totalScenarios;
  final String characterName;

  const ScenarioCard({
    super.key,
    required this.scenario,
    required this.scenarioNumber,
    required this.totalScenarios,
    required this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    return PixelPanel(
      title:
          'SCENARIO $scenarioNumber OF $totalScenarios — ${scenario.title.toUpperCase()}',
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReadingText(
            scenario.description,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3,
                  height: 40,
                  margin: const EdgeInsets.only(right: 12),
                  color: AppColors.accent.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: ReadingText(
                    scenario.narration,
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'What should $characterName do?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
