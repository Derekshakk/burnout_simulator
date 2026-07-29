import 'package:flutter/material.dart';
import '../accessibility/accessibility_state.dart'
    show AccessibilityState, FontChoice;

/// A complete color palette. Two instances exist — the default dark palette and
/// the high-contrast palette — and [AppColors] exposes whichever is active.
///
/// This indirection is what makes High Contrast work: the whole app references
/// `AppColors.*` (not the ThemeData ColorScheme), so flipping the active palette
/// recolors every widget at once.
@immutable
class AppPalette {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color border;
  final Color borderBright;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentGreen;
  final Color accentAmber;
  final Color accentRed;
  final Color accentPurple;
  final Color pixelGreen;
  final Color energyColor;
  final Color focusColor;
  final Color stressColor;
  final Color motivationColor;
  final Color satisfactionColor;
  final Color selfAdvocacyColor;
  final Color burnoutLow;
  final Color burnoutMid;
  final Color burnoutHigh;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.borderBright,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentGreen,
    required this.accentAmber,
    required this.accentRed,
    required this.accentPurple,
    required this.pixelGreen,
    required this.energyColor,
    required this.focusColor,
    required this.stressColor,
    required this.motivationColor,
    required this.satisfactionColor,
    required this.selfAdvocacyColor,
    required this.burnoutLow,
    required this.burnoutMid,
    required this.burnoutHigh,
  });
}

const AppPalette _defaultPalette = AppPalette(
  background: Color(0xFF0d1117),
  surface: Color(0xFF161b22),
  surfaceVariant: Color(0xFF21262d),
  border: Color(0xFF30363d),
  borderBright: Color(0xFF484f58),
  textPrimary: Color(0xFFe6edf3),
  textSecondary: Color(0xFF8b949e),
  textMuted: Color(0xFF6e7681),
  accent: Color(0xFF58a6ff),
  accentGreen: Color(0xFF3fb950),
  accentAmber: Color(0xFFd29922),
  accentRed: Color(0xFFf85149),
  accentPurple: Color(0xFFd2a8ff),
  pixelGreen: Color(0xFF7ee787),
  energyColor: Color(0xFF3fb950),
  focusColor: Color(0xFF79c0ff),
  stressColor: Color(0xFFf85149),
  motivationColor: Color(0xFFd2a8ff),
  satisfactionColor: Color(0xFFffa657),
  selfAdvocacyColor: Color(0xFF56d364),
  burnoutLow: Color(0xFF3fb950),
  burnoutMid: Color(0xFFd29922),
  burnoutHigh: Color(0xFFf85149),
);

/// High-contrast palette: near-black backgrounds, white/near-white text, bright
/// borders, and vivid status hues that keep their meaning (green energy, red
/// stress, amber caution) while clearing ~4.5:1 against the background.
const AppPalette _highContrastPalette = AppPalette(
  background: Color(0xFF000000),
  surface: Color(0xFF0B0B0B),
  surfaceVariant: Color(0xFF1A1A1A),
  border: Color(0xFFFFFFFF),
  borderBright: Color(0xFFFFFFFF),
  textPrimary: Color(0xFFFFFFFF),
  textSecondary: Color(0xFFEDEDED),
  textMuted: Color(0xFFCFCFCF),
  accent: Color(0xFF7FD4FF),
  accentGreen: Color(0xFF6EF0A6),
  accentAmber: Color(0xFFFFD84D),
  accentRed: Color(0xFFFF7A7A),
  accentPurple: Color(0xFFEC9BFF),
  pixelGreen: Color(0xFF8CFFA0),
  energyColor: Color(0xFF6EF0A6),
  focusColor: Color(0xFF7FD4FF),
  stressColor: Color(0xFFFF7A7A),
  motivationColor: Color(0xFFEC9BFF),
  satisfactionColor: Color(0xFFFFB861),
  selfAdvocacyColor: Color(0xFF7BE38B),
  burnoutLow: Color(0xFF6EF0A6),
  burnoutMid: Color(0xFFFFD84D),
  burnoutHigh: Color(0xFFFF7A7A),
);

/// Active-palette facade. Every widget reads colors through these getters, so
/// toggling [highContrast] recolors the entire app on the next rebuild.
class AppColors {
  AppColors._();

  /// When true, [AppColors] resolves to the high-contrast palette. Set from
  /// AccessibilityState before the widget tree builds (see app.dart).
  static bool highContrast = false;

  static AppPalette get palette =>
      highContrast ? _highContrastPalette : _defaultPalette;

  static Color get background => palette.background;
  static Color get surface => palette.surface;
  static Color get surfaceVariant => palette.surfaceVariant;
  static Color get border => palette.border;
  static Color get borderBright => palette.borderBright;
  static Color get textPrimary => palette.textPrimary;
  static Color get textSecondary => palette.textSecondary;
  static Color get textMuted => palette.textMuted;
  static Color get accent => palette.accent;
  static Color get accentGreen => palette.accentGreen;
  static Color get accentAmber => palette.accentAmber;
  static Color get accentRed => palette.accentRed;
  static Color get accentPurple => palette.accentPurple;
  static Color get pixelGreen => palette.pixelGreen;
  static Color get energyColor => palette.energyColor;
  static Color get focusColor => palette.focusColor;
  static Color get stressColor => palette.stressColor;
  static Color get motivationColor => palette.motivationColor;
  static Color get satisfactionColor => palette.satisfactionColor;
  static Color get selfAdvocacyColor => palette.selfAdvocacyColor;
  static Color get burnoutLow => palette.burnoutLow;
  static Color get burnoutMid => palette.burnoutMid;
  static Color get burnoutHigh => palette.burnoutHigh;
}

class AppTheme {
  /// Bundled font families (see pubspec.yaml / fonts/).
  static const String readableFontFamily = 'Verdana';
  static const List<String> readableFontFallback = <String>[
    'Tahoma',
    'Segoe UI',
    'DejaVu Sans',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  static const String openDyslexicFontFamily = 'OpenDyslexic';
  static const List<String> openDyslexicFontFallback = <String>['sans-serif'];

  /// Applies AccessibilityState typography overrides on top of a base theme.
  static ThemeData withA11y(ThemeData base, AccessibilityState a11y) {
    final (
      String? overrideFamily,
      List<String>? overrideFallback,
    ) = switch (a11y.fontChoice) {
      FontChoice.readable => (readableFontFamily, readableFontFallback),
      FontChoice.openDyslexic => (
        openDyslexicFontFamily,
        openDyslexicFontFallback,
      ),
      FontChoice.system => (null, null),
    };

    TextStyle applyA11y(TextStyle? s) {
      final style = s ?? const TextStyle();
      final baseHeight = style.height ?? 1.4;
      final baseSpacing = style.letterSpacing ?? 0.0;
      return style.copyWith(
        height: (baseHeight * a11y.lineHeightScale).clamp(0.8, 3.0),
        letterSpacing: (baseSpacing + a11y.letterSpacingDelta).clamp(-0.5, 8.0),
        fontFamily: overrideFamily ?? style.fontFamily,
        fontFamilyFallback: overrideFallback ?? style.fontFamilyFallback,
      );
    }

    final tt = base.textTheme;
    return base.copyWith(
      textTheme: tt.copyWith(
        displayLarge: applyA11y(tt.displayLarge),
        displayMedium: applyA11y(tt.displayMedium),
        displaySmall: applyA11y(tt.displaySmall),
        headlineLarge: applyA11y(tt.headlineLarge),
        headlineMedium: applyA11y(tt.headlineMedium),
        headlineSmall: applyA11y(tt.headlineSmall),
        bodyLarge: applyA11y(tt.bodyLarge),
        bodyMedium: applyA11y(tt.bodyMedium),
        bodySmall: applyA11y(tt.bodySmall),
        labelLarge: applyA11y(tt.labelLarge),
        labelMedium: applyA11y(tt.labelMedium),
        labelSmall: applyA11y(tt.labelSmall),
        titleLarge: applyA11y(tt.titleLarge),
        titleMedium: applyA11y(tt.titleMedium),
        titleSmall: applyA11y(tt.titleSmall),
      ),
    );
  }

  /// Builds the app theme from the *active* [AppColors] palette. Because the
  /// palette swaps with High Contrast, this single builder covers both modes;
  /// the only mode-specific extra is heavier control borders in high contrast.
  static ThemeData get themeData {
    final hc = AppColors.highContrast;

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.accent,
        secondary: AppColors.accentGreen,
        error: AppColors.accentRed,
        onSurface: AppColors.textPrimary,
        onPrimary: AppColors.background,
        outline: AppColors.border,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.6,
        ),
        bodySmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 12,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: hc ? BorderSide(color: AppColors.accent, width: 2) : null,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: BorderSide(
            color: hc ? AppColors.accent : AppColors.border,
            width: hc ? 2 : 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        textStyle: TextStyle(color: AppColors.textPrimary, fontSize: 12),
      ),
    );
  }

  /// Backwards-compatible aliases.
  static ThemeData get darkTheme => themeData;
}
