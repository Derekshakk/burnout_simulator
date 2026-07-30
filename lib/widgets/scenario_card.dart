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
          // ── Zone 1: Situation ───────────────────────────────────────────────
          Text(
            'SITUATION',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          ReadingText(
            scenario.description,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 14),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          // ── Zone 2: Narration ───────────────────────────────────────────────
          Text(
            'THEIR THOUGHTS',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                left: BorderSide(
                  color: AppColors.accent.withValues(alpha: 0.6),
                  width: 3,
                ),
              ),
            ),
            child: ReadingText(
              scenario.narration,
              style: TextStyle(
                color: AppColors.accentText,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 12),
          // ── Zone 3: Decision prompt ─────────────────────────────────────────
          Text(
            'What should $characterName do?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
