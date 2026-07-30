import 'package:flutter/material.dart';
import '../accessibility/accessibility_state.dart'
    show AccessibilityState, FontChoice;

/// A complete color palette. Two instances exist — the default light palette
/// and the high-contrast palette — and [AppColors] exposes whichever is active.
///
/// This indirection is what makes High Contrast work: the whole app references
/// `AppColors.*` (not the ThemeData ColorScheme), so flipping the active
/// palette recolors every widget at once.
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
  // Text for dark surfaces such as navigation, tooltips, and feedback cards.
  final Color textOnDark;
  // Deep coral reserved for text and icons on light surfaces. The palette
  // coral remains a visual accent and button fill, where charcoal is used on
  // top of it.
  final Color accentText;
  final Color disabledText;
  final Color disabledSurface;
  final Color focusRing;
  final Color accent;
  // Darker variant of accent for hover/pressed states and pixel-art shadows.
  final Color accentDark;
  // Navigation bar background (deep teal) and the text drawn on top of it.
  // These are separate from textPrimary/textSecondary because the nav sits on
  // a dark surface even when the rest of the page is light.
  final Color navBackground;
  final Color navText;
  final Color publicNavigationBackground;
  final Color feedbackSurface;
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
  // Pixel-art and accessibility-overlay colors are also palette tokens so
  // high-contrast mode never leaves an old hard-coded surface behind.
  final Color illustrationSkyStart;
  final Color illustrationSkyEnd;
  final Color illustrationBuilding;
  final Color illustrationBuildingDim;
  final Color illustrationGround;
  final Color illustrationMoon;
  final Color illustrationStar;
  final Color illustrationWindow;
  final Color illustrationDesk;
  final Color illustrationSkin;
  final Color illustrationHair;
  final Color illustrationScreen;
  final Color illustrationScreenGlow;
  final Color illustrationBook;
  final Color illustrationWarm;
  final Color illustrationTrim;
  final Color illustrationDeepSky;
  final Color illustrationEveningGround;
  final Color transparent;
  final Color overlayScrim;
  final Color overlaySurface;
  final Color overlayBorder;
  final Color overlayHandle;
  final Color readingMask;
  final Color magnifierSurface;
  final Color magnifierBorder;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.border,
    required this.borderBright,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textOnDark,
    required this.accentText,
    required this.disabledText,
    required this.disabledSurface,
    required this.focusRing,
    required this.accent,
    required this.accentDark,
    required this.navBackground,
    required this.navText,
    required this.publicNavigationBackground,
    required this.feedbackSurface,
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
    required this.illustrationSkyStart,
    required this.illustrationSkyEnd,
    required this.illustrationBuilding,
    required this.illustrationBuildingDim,
    required this.illustrationGround,
    required this.illustrationMoon,
    required this.illustrationStar,
    required this.illustrationWindow,
    required this.illustrationDesk,
    required this.illustrationSkin,
    required this.illustrationHair,
    required this.illustrationScreen,
    required this.illustrationScreenGlow,
    required this.illustrationBook,
    required this.illustrationWarm,
    required this.illustrationTrim,
    required this.illustrationDeepSky,
    required this.illustrationEveningGround,
    required this.transparent,
    required this.overlayScrim,
    required this.overlaySurface,
    required this.overlayBorder,
    required this.overlayHandle,
    required this.readingMask,
    required this.magnifierSurface,
    required this.magnifierBorder,
  });
}

// ── Project Ignite — light warm palette ──────────────────────────────────────
//
// Hierarchy:
//   Cream   #FBE0C3  → background (all page backgrounds)
//   Surface #FFF5EC  → cards, panels, raised sections
//   Muted   #EDF1F3  → PixelPanel title bars, alternating sections
//   Border  #7D8E95  → all borders and dividers  (palette blue-gray)
//   Teal    #344648  → navigation, footer, selected dark sections
//   Coral   #FFB09B  → primary buttons, highlights, active states
//   Charcoal #2E3A3C → body text on light backgrounds
//   Cream   #FBE0C3  → text on dark (nav/footer) backgrounds
//
// Semantic-accent colours are deepened relative to the previous dark palette
// so they remain legible on the new light surfaces.

const AppPalette _defaultPalette = AppPalette(
  // ── page backgrounds ──────────────────────────────────────────────────────
  background: Color(0xFFFBE0C3), // palette cream — all page backgrounds
  surface: Color(0xFFFFF5EC), // near-white warm cream — cards / panels
  surfaceVariant: Color(
    0xFFEDF1F3,
  ), // light blue-gray — muted panels, title bars
  // ── structural ────────────────────────────────────────────────────────────
  border: Color(0xFF5A7080), // readable blue-gray — 4.1:1 on cream
  borderBright: Color(0xFF2E3A3C), // active / focus borders
  // ── text on light backgrounds ─────────────────────────────────────────────
  textPrimary: Color(
    0xFF2E3A3C,
  ), // dark warm charcoal — body text      11.6:1 on bg
  textSecondary: Color(
    0xFF506065,
  ), // medium charcoal — secondary labels   6.6:1 on bg
  textMuted: Color(
    0xFF52676C,
  ), // muted blue-gray — meta / helper text   4.7:1 on bg
  textOnDark: Color(0xFFFBE0C3), // 7.8:1 on deep teal
  accentText: Color(
    0xFF8B443B,
  ), // 5.5:1 on cream; never use light coral as text
  disabledText: Color(0xFF52676C), // 4.7:1 on cream
  disabledSurface: Color(0xFFEDF1F3),
  focusRing: Color(0xFF2E3A3C),
  // ── interactive accent ────────────────────────────────────────────────────
  accent: Color(0xFFFFB09B), // palette coral — buttons, highlights
  accentDark: Color(0xFFD47B65), // deep coral — hover, pressed, shadows
  // ── navigation (always dark, regardless of page brightness) ───────────────
  navBackground: Color(0xFF344648), // palette deep teal — nav bar, footer
  navText: Color(0xFFFBE0C3),
  publicNavigationBackground: Color(0xFF38D0B5),
  feedbackSurface: Color(0xFF38D0B5),
  // ── semantic accents (deepened for legibility on light surfaces) ──────────
  accentGreen: Color(0xFF27734D), // 4.5:1 on cream
  accentAmber: Color(0xFF8A5818), // 4.7:1 on cream
  accentRed: Color(0xFFA63B36), // 5.0:1 on cream
  accentPurple: Color(0xFF665287), // 5.3:1 on cream
  pixelGreen: Color(0xFF27734D),
  // ── status meters ─────────────────────────────────────────────────────────
  energyColor: Color(0xFF27734D),
  focusColor: Color(0xFF236B8C),
  stressColor: Color(0xFFA63B36),
  motivationColor: Color(0xFF665287),
  satisfactionColor: Color(0xFF8B443B),
  selfAdvocacyColor: Color(0xFF246A88),
  // ── burnout scale ─────────────────────────────────────────────────────────
  burnoutLow: Color(0xFF27734D),
  burnoutMid: Color(0xFF8A5818),
  burnoutHigh: Color(0xFFA63B36),
  illustrationSkyStart: Color(0xFF0C1A1C),
  illustrationSkyEnd: Color(0xFF1A1028),
  illustrationBuilding: Color(0xFF1C2B2D),
  illustrationBuildingDim: Color(0xFF162426),
  illustrationGround: Color(0xFF0D1E22),
  illustrationMoon: Color(0xFFFBD4A0),
  illustrationStar: Color(0xFFE6EDF3),
  illustrationWindow: Color(0xFFFFD54F),
  illustrationDesk: Color(0xFF3D2B1F),
  illustrationSkin: Color(0xFFE8C99A),
  illustrationHair: Color(0xFF4A3728),
  illustrationScreen: Color(0xFF1E1E1E),
  illustrationScreenGlow: Color(0xFF58A6FF),
  illustrationBook: Color(0xFFD29922),
  illustrationWarm: Color(0xFFFFA040),
  illustrationTrim: Color(0xFF5A3A20),
  illustrationDeepSky: Color(0xFF050E10),
  illustrationEveningGround: Color(0xFF2A1E12),
  transparent: Color(0x00000000),
  overlayScrim: Color(0x99000000),
  overlaySurface: Color(0xFF161B22),
  overlayBorder: Color(0xFF30363D),
  overlayHandle: Color(0xFF484F58),
  readingMask: Color(0xCC000000),
  magnifierSurface: Color(0xFFF8F8F8),
  magnifierBorder: Color(0xFFCCCCCC),
);

/// High-contrast palette: near-black backgrounds, white/near-white text, vivid
/// semantic hues. Accessibility-critical — values are not adjusted for style.
const AppPalette _highContrastPalette = AppPalette(
  background: Color(0xFF000000),
  surface: Color(0xFF0B0B0B),
  surfaceVariant: Color(0xFF1A1A1A),
  border: Color(0xFFFFFFFF),
  borderBright: Color(0xFFFFFFFF),
  textPrimary: Color(0xFFFFFFFF),
  textSecondary: Color(0xFFEDEDED),
  textMuted: Color(0xFFCFCFCF),
  textOnDark: Color(0xFFFFFFFF),
  accentText: Color(0xFF7FD4FF),
  disabledText: Color(0xFFCFCFCF),
  disabledSurface: Color(0xFF1A1A1A),
  focusRing: Color(0xFFFFFFFF),
  accent: Color(0xFF7FD4FF),
  accentDark: Color(0xFF5AB0E0),
  navBackground: Color(0xFF000000), // fully black nav in HC
  navText: Color(0xFFFFFFFF),
  publicNavigationBackground: Color(0xFF000000),
  feedbackSurface: Color(0xFF000000),
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
  illustrationSkyStart: Color(0xFF000000),
  illustrationSkyEnd: Color(0xFF0B0B0B),
  illustrationBuilding: Color(0xFF1A1A1A),
  illustrationBuildingDim: Color(0xFF0B0B0B),
  illustrationGround: Color(0xFF000000),
  illustrationMoon: Color(0xFFFFFFFF),
  illustrationStar: Color(0xFFFFFFFF),
  illustrationWindow: Color(0xFFFFD84D),
  illustrationDesk: Color(0xFF1A1A1A),
  illustrationSkin: Color(0xFFFFFFFF),
  illustrationHair: Color(0xFFFFFFFF),
  illustrationScreen: Color(0xFF0B0B0B),
  illustrationScreenGlow: Color(0xFF7FD4FF),
  illustrationBook: Color(0xFFFFD84D),
  illustrationWarm: Color(0xFFFFD84D),
  illustrationTrim: Color(0xFFFFFFFF),
  illustrationDeepSky: Color(0xFF000000),
  illustrationEveningGround: Color(0xFF0B0B0B),
  transparent: Color(0x00000000),
  overlayScrim: Color(0xCC000000),
  overlaySurface: Color(0xFF0B0B0B),
  overlayBorder: Color(0xFFFFFFFF),
  overlayHandle: Color(0xFFFFFFFF),
  readingMask: Color(0xDD000000),
  magnifierSurface: Color(0xFFFFFFFF),
  magnifierBorder: Color(0xFF000000),
);

/// Active-palette facade. Every widget reads colors through these getters, so
/// toggling [highContrast] recolors the entire app on the next rebuild.
class AppColors {
  AppColors._();

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
  static Color get textOnDark => palette.textOnDark;
  static Color get accentText => palette.accentText;
  static Color get disabledText => palette.disabledText;
  static Color get disabledSurface => palette.disabledSurface;
  static Color get focusRing => palette.focusRing;
  static Color get accent => palette.accent;
  static Color get accentDark => palette.accentDark;
  static Color get navBackground => palette.navBackground;
  static Color get navText => palette.navText;
  static Color get publicNavigationBackground =>
      palette.publicNavigationBackground;
  static Color get feedbackSurface => palette.feedbackSurface;
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
  static Color get illustrationSkyStart => palette.illustrationSkyStart;
  static Color get illustrationSkyEnd => palette.illustrationSkyEnd;
  static Color get illustrationBuilding => palette.illustrationBuilding;
  static Color get illustrationBuildingDim => palette.illustrationBuildingDim;
  static Color get illustrationGround => palette.illustrationGround;
  static Color get illustrationMoon => palette.illustrationMoon;
  static Color get illustrationStar => palette.illustrationStar;
  static Color get illustrationWindow => palette.illustrationWindow;
  static Color get illustrationDesk => palette.illustrationDesk;
  static Color get illustrationSkin => palette.illustrationSkin;
  static Color get illustrationHair => palette.illustrationHair;
  static Color get illustrationScreen => palette.illustrationScreen;
  static Color get illustrationScreenGlow => palette.illustrationScreenGlow;
  static Color get illustrationBook => palette.illustrationBook;
  static Color get illustrationWarm => palette.illustrationWarm;
  static Color get illustrationTrim => palette.illustrationTrim;
  static Color get illustrationDeepSky => palette.illustrationDeepSky;
  static Color get illustrationEveningGround =>
      palette.illustrationEveningGround;
  static Color get transparent => palette.transparent;
  static Color get overlayScrim => palette.overlayScrim;
  static Color get overlaySurface => palette.overlaySurface;
  static Color get overlayBorder => palette.overlayBorder;
  static Color get overlayHandle => palette.overlayHandle;
  static Color get readingMask => palette.readingMask;
  static Color get magnifierSurface => palette.magnifierSurface;
  static Color get magnifierBorder => palette.magnifierBorder;
}

class AppTheme {
  /// Shared geometry for interactive controls. Panels intentionally retain
  /// their square pixel-art treatment; buttons use this softer radius.
  static const BorderRadius buttonRadius = BorderRadius.all(
    Radius.circular(10),
  );
  static const BorderRadius compactButtonRadius = BorderRadius.all(
    Radius.circular(8),
  );
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

  static ThemeData get themeData {
    final hc = AppColors.highContrast;

    // The default palette is light (cream background). High-contrast mode
    // uses Brightness.dark because its background is near-black.
    final brightness = hc ? Brightness.dark : Brightness.light;

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: hc
          ? ColorScheme.dark(
              surface: AppColors.surface,
              primary: AppColors.accent,
              secondary: AppColors.accentGreen,
              error: AppColors.accentRed,
              onSurface: AppColors.textPrimary,
              onPrimary: AppColors.background,
              outline: AppColors.border,
            )
          : ColorScheme.light(
              surface: AppColors.surface,
              primary: AppColors.accent,
              secondary: AppColors.accentGreen,
              error: AppColors.accentRed,
              onSurface: AppColors.textPrimary,
              // Text on coral buttons: dark charcoal gives 7.6:1 contrast.
              onPrimary: AppColors.textPrimary,
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
          fontSize: 38,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          height: 1.65,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
          height: 1.65,
        ),
        bodySmall: TextStyle(
          color: AppColors.textMuted,
          fontSize: 14,
          height: 1.5,
        ),
        labelLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          // Dark charcoal on coral: 7.6:1 contrast — never use cream/background here.
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          side: BorderSide(
            color: hc ? AppColors.accent : AppColors.borderBright,
            width: hc ? 2 : 1,
          ),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentText,
          side: BorderSide(
            color: hc ? AppColors.accent : AppColors.border,
            width: hc ? 2 : 1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: compactButtonRadius,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
        ),
        textStyle: TextStyle(color: AppColors.navText, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme => themeData;
}
