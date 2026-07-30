import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import 'accessibility_scope.dart';
import 'selective_bold_text.dart';

/// Body-text widget that applies selective bolding when enabled.
/// Use in place of [Text] for readable long-form paragraphs.
class ReadingText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ReadingText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final a11y = AccessibilityScope.maybeOf(context);
    // Text alignment is applied here (on the leaf) because a DefaultTextStyle
    // set above the Navigator is shadowed by the Material inside each Scaffold.
    final effectiveAlign = textAlign ?? a11y?.textAlign;
    if (a11y != null && a11y.selectiveBolding) {
      return SelectiveBoldText(
        data,
        style: style,
        textAlign: effectiveAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
    return Text(
      data,
      style: style,
      textAlign: effectiveAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Heading widget that adds a visible underline/decoration when
/// "Highlight Titles" is enabled.
class A11yHeading extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const A11yHeading(this.data, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final a11y = AccessibilityScope.maybeOf(context);
    final shouldHighlight = a11y?.highlightTitles ?? false;
    final align = a11y?.textAlign;
    final baseStyle = style ?? Theme.of(context).textTheme.displaySmall;

    if (!shouldHighlight) {
      return Text(data, style: baseStyle, textAlign: align);
    }

    // Emphasize headings with a subtle highlight fill, a thicker underline,
    // and a heavier weight (more than color alone).
    final accent = baseStyle?.color ?? AppColors.textPrimary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(color: accent.withValues(alpha: 0.7), width: 3),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          data,
          textAlign: align,
          style: (baseStyle ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

/// Wraps a decorative image/visual widget and hides it when "Hide Images"
/// is enabled in accessibility preferences. Shows an accessible placeholder.
class A11yImage extends StatelessWidget {
  final Widget child;
  final String semanticLabel;
  final bool alwaysShow; // for functional images (logos, icons, charts)

  const A11yImage({
    super.key,
    required this.child,
    this.semanticLabel = 'Decorative image',
    this.alwaysShow = false,
  });

  @override
  Widget build(BuildContext context) {
    final a11y = AccessibilityScope.maybeOf(context);
    final hide = !alwaysShow && (a11y?.hideImages ?? false);

    if (!hide) return child;

    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
        decoration: BoxDecoration(
          color: AppColors.overlaySurface,
          border: Border.all(color: AppColors.overlayBorder, width: 1),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.overlayHandle,
          size: 24,
        ),
      ),
    );
  }
}

/// A link-style text button that adds underline + border highlight when
/// "Highlight Links" is enabled.
class A11yLink extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final TextStyle? style;

  const A11yLink({super.key, required this.label, this.onTap, this.style});

  @override
  Widget build(BuildContext context) {
    final a11y = AccessibilityScope.maybeOf(context);
    final highlight = a11y?.highlightLinks ?? false;
    final baseStyle =
        style ??
        TextStyle(
          color: AppColors.focusColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        );

    final decoratedStyle = highlight
        ? baseStyle.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: baseStyle.color,
            decorationThickness: 2,
          )
        : baseStyle;

    Widget text = Text(label, style: decoratedStyle);

    if (highlight) {
      text = Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          border: Border.all(
            color: (baseStyle.color ?? AppColors.focusColor).withValues(
              alpha: 0.5,
            ),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        child: text,
      );
    }

    return FocusableActionDetector(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Semantics(link: true, label: label, child: text),
        ),
      ),
    );
  }
}
