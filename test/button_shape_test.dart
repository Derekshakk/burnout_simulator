import 'package:burnout_simulator/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shared Material button themes use the app corner radius', () {
    final theme = AppTheme.themeData;

    for (final style in [
      theme.elevatedButtonTheme.style,
      theme.outlinedButtonTheme.style,
      theme.textButtonTheme.style,
      theme.iconButtonTheme.style,
    ]) {
      final shape = style?.shape?.resolve(<WidgetState>{});
      expect(shape, isA<RoundedRectangleBorder>());
      expect(
        (shape! as RoundedRectangleBorder).borderRadius,
        anyOf(AppTheme.buttonRadius, AppTheme.compactButtonRadius),
      );
    }
  });
}
