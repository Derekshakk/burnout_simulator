import 'package:burnout_simulator/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() => AppColors.highContrast = false);

  test('default semantic text and component tokens meet contrast targets', () {
    AppColors.highContrast = false;

    for (final background in <Color>[
      AppColors.background,
      AppColors.surface,
      AppColors.surfaceVariant,
    ]) {
      for (final foreground in <Color>[
        AppColors.textPrimary,
        AppColors.textSecondary,
        AppColors.textMuted,
        AppColors.accentText,
        AppColors.disabledText,
      ]) {
        expect(
          contrastRatio(foreground, background),
          greaterThanOrEqualTo(4.5),
          reason: '$foreground must be readable on $background',
        );
      }

      for (final component in <Color>[
        AppColors.border,
        AppColors.borderBright,
        AppColors.energyColor,
        AppColors.focusColor,
        AppColors.stressColor,
        AppColors.motivationColor,
        AppColors.satisfactionColor,
        AppColors.selfAdvocacyColor,
      ]) {
        expect(
          contrastRatio(component, background),
          greaterThanOrEqualTo(3),
          reason: '$component must remain distinguishable on $background',
        );
      }
    }

    expect(
      contrastRatio(AppColors.textOnDark, AppColors.navBackground),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrastRatio(AppColors.textPrimary, AppColors.feedbackSurface),
      greaterThanOrEqualTo(4.5),
    );
    expect(
      contrastRatio(AppColors.textPrimary, AppColors.accent),
      greaterThanOrEqualTo(4.5),
    );
  });

  test(
    'high contrast palette keeps text and selected control colors readable',
    () {
      AppColors.highContrast = true;

      for (final foreground in <Color>[
        AppColors.textPrimary,
        AppColors.textSecondary,
        AppColors.textMuted,
        AppColors.textOnDark,
        AppColors.accentText,
        AppColors.disabledText,
      ]) {
        expect(
          contrastRatio(foreground, AppColors.surface),
          greaterThanOrEqualTo(4.5),
        );
      }
      expect(
        contrastRatio(AppColors.focusRing, AppColors.surfaceVariant),
        greaterThanOrEqualTo(3),
      );
    },
  );
}

double contrastRatio(Color first, Color second) {
  final firstLuminance = first.computeLuminance();
  final secondLuminance = second.computeLuminance();
  final lighter = firstLuminance > secondLuminance
      ? firstLuminance
      : secondLuminance;
  final darker = firstLuminance > secondLuminance
      ? secondLuminance
      : firstLuminance;
  return (lighter + 0.05) / (darker + 0.05);
}
