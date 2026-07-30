import 'package:burnout_simulator/app/theme.dart';
import 'package:burnout_simulator/widgets/section_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('section labels use the readable semantic text color', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionLabel(text: 'IMPORTANT NOTICE')),
      ),
    );

    final label = tester.widget<Text>(find.text('IMPORTANT NOTICE'));
    expect(label.style?.color, AppColors.textPrimary);
  });

  testWidgets('section labels follow the high-contrast palette', (
    tester,
  ) async {
    addTearDown(() => AppColors.highContrast = false);
    AppColors.highContrast = true;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SectionLabel(text: 'END OF DAY — RESULTS')),
      ),
    );

    final label = tester.widget<Text>(find.text('END OF DAY — RESULTS'));
    expect(label.style?.color, const Color(0xFFFFFFFF));
  });
}
