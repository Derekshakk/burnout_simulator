import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import 'accessibility_state.dart' show AccessibilityState, FontChoice;
import 'tts_controller.dart';
import 'tts_service.dart';

/// The settings panel content. Mounted inside an animated panel container.
class AccessibilityPanel extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;
  final VoidCallback onClose;
  final String Function() getPageText;

  const AccessibilityPanel({
    super.key,
    required this.a11y,
    required this.tts,
    required this.onClose,
    required this.getPageText,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Decide the layout from the panel's *actual* available width (its incoming
    // constraints), not the whole screen — so it never overflows when it is
    // given less room than the viewport (narrow screens, browser zoom, etc.).
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : mq.size.width;
        final availableHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : mq.size.height * 0.85;

        final twoCol = availableWidth >= 560;
        final panelMaxWidth = twoCol
            ? 560.0
            : (availableWidth < 360 ? availableWidth : 360.0);

        return Material(
          color: AppColors.surface,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          elevation: 16,
          shadowColor: AppColors.overlayScrim.withValues(alpha: 0.54),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            constraints: BoxConstraints(
              maxWidth: panelMaxWidth,
              maxHeight: availableHeight,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _PanelHeader(onClose: onClose),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 2,
                    ),
                    child: twoCol
                        ? _TwoColumnContent(
                            a11y: a11y,
                            tts: tts,
                            getPageText: getPageText,
                          )
                        : _SingleColumnContent(
                            a11y: a11y,
                            tts: tts,
                            getPageText: getPageText,
                          ),
                  ),
                ),
                _ResetFooter(a11y: a11y, tts: tts),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PanelHeader extends StatelessWidget {
  final VoidCallback onClose;

  const _PanelHeader({required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
      ),
      child: Row(
        children: [
          Icon(Icons.accessibility_new, color: AppColors.accentText, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Accessibility Preferences',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Semantics(
            label: 'Close accessibility panel',
            button: true,
            child: IconButton(
              icon: Icon(Icons.close, size: 18, color: AppColors.textSecondary),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: onClose,
              tooltip: 'Close (Escape)',
            ),
          ),
        ],
      ),
    );
  }
}

class _TwoColumnContent extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;
  final String Function() getPageText;

  const _TwoColumnContent({
    required this.a11y,
    required this.tts,
    required this.getPageText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _LeftColumn(a11y: a11y)),
        const SizedBox(width: 16),
        Expanded(
          child: _RightColumn(a11y: a11y, tts: tts, getPageText: getPageText),
        ),
      ],
    );
  }
}

class _SingleColumnContent extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;
  final String Function() getPageText;

  const _SingleColumnContent({
    required this.a11y,
    required this.tts,
    required this.getPageText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LeftColumn(a11y: a11y),
        const SizedBox(height: 4),
        _RightColumn(a11y: a11y, tts: tts, getPageText: getPageText),
      ],
    );
  }
}

class _LeftColumn extends StatelessWidget {
  final AccessibilityState a11y;

  const _LeftColumn({required this.a11y});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Typography'),
        _StepControl(
          label: 'Font Size',
          value: a11y.fontSizeScale,
          displayValue: '${(a11y.fontSizeScale * 100).round()}%',
          step: 0.1,
          min: 0.7,
          max: 2.0,
          onDecrement: () => a11y.setFontSizeScale(a11y.fontSizeScale - 0.1),
          onIncrement: () => a11y.setFontSizeScale(a11y.fontSizeScale + 0.1),
        ),
        _StepControl(
          label: 'Line Height',
          value: a11y.lineHeightScale,
          displayValue: '${(a11y.lineHeightScale * 100).round()}%',
          step: 0.1,
          min: 0.7,
          max: 2.5,
          onDecrement: () =>
              a11y.setLineHeightScale(a11y.lineHeightScale - 0.1),
          onIncrement: () =>
              a11y.setLineHeightScale(a11y.lineHeightScale + 0.1),
        ),
        _StepControl(
          label: 'Letter Spacing',
          value: a11y.letterSpacingDelta,
          displayValue: a11y.letterSpacingDelta == 0
              ? '0'
              : '${a11y.letterSpacingDelta > 0 ? "+" : ""}${a11y.letterSpacingDelta.toStringAsFixed(1)}',
          step: 0.5,
          min: -0.5,
          max: 5.0,
          onDecrement: () =>
              a11y.setLetterSpacingDelta(a11y.letterSpacingDelta - 0.5),
          onIncrement: () =>
              a11y.setLetterSpacingDelta(a11y.letterSpacingDelta + 0.5),
        ),
        _StepControl(
          label: 'Content Scale',
          value: a11y.contentScale,
          displayValue: '${(a11y.contentScale * 100).round()}%',
          step: 0.1,
          min: 0.7,
          max: 1.5,
          onDecrement: () => a11y.setContentScale(a11y.contentScale - 0.1),
          onIncrement: () => a11y.setContentScale(a11y.contentScale + 0.1),
        ),
        const SizedBox(height: 8),
        _SectionLabel('Appearance'),
        _FontChoiceGroup(a11y: a11y),
        const SizedBox(height: 4),
        _ToggleRow(
          label: 'High Contrast',
          value: a11y.highContrast,
          onToggle: a11y.toggleHighContrast,
          description: 'Maximum text/background contrast',
        ),
        _ToggleRow(
          label: 'Highlight Links',
          value: a11y.highlightLinks,
          onToggle: a11y.toggleHighlightLinks,
          description: 'Underline and outline links',
        ),
        _ToggleRow(
          label: 'Highlight Titles',
          value: a11y.highlightTitles,
          onToggle: a11y.toggleHighlightTitles,
          description: 'Strong emphasis on headings',
        ),
        _ToggleRow(
          label: 'Hide Images',
          value: a11y.hideImages,
          onToggle: a11y.toggleHideImages,
          description: 'Hide decorative visuals',
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;
  final String Function() getPageText;

  const _RightColumn({
    required this.a11y,
    required this.tts,
    required this.getPageText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionLabel('Text Alignment'),
        _AlignmentGroup(a11y: a11y),
        const SizedBox(height: 8),
        _SectionLabel('Reading Aids'),
        _ToggleRow(
          label: 'Reading Mask',
          value: a11y.readingMask,
          onToggle: a11y.toggleReadingMask,
          description: 'Focus band follows your cursor',
        ),
        _ToggleRow(
          label: 'Text Magnifier',
          value: a11y.textMagnifier,
          onToggle: a11y.toggleTextMagnifier,
          description: 'Zoomed view near cursor',
        ),
        _ToggleRow(
          label: 'Selective Bolding',
          value: a11y.selectiveBolding,
          onToggle: a11y.toggleSelectiveBolding,
          description: 'Bold word beginnings as visual anchors',
        ),
        const SizedBox(height: 8),
        _SectionLabel('Read Aloud'),
        _ReadAloudSection(a11y: a11y, tts: tts, getPageText: getPageText),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: AppColors.accentText,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StepControl extends StatelessWidget {
  final String label;
  final double value;
  final String displayValue;
  final double step;
  final double min;
  final double max;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _StepControl({
    required this.label,
    required this.value,
    required this.displayValue,
    required this.step,
    required this.min,
    required this.max,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final canDecrement = value > min + 0.001;
    final canIncrement = value < max - 0.001;

    return Padding(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          _StepButton(
            semanticLabel: 'Decrease $label',
            onPressed: canDecrement ? onDecrement : null,
            icon: Icons.remove,
          ),
          Semantics(
            label: '$label: $displayValue',
            child: Container(
              width: 52,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                displayValue,
                style: TextStyle(
                  color: AppColors.focusColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
          _StepButton(
            semanticLabel: 'Increase $label',
            onPressed: canIncrement ? onIncrement : null,
            icon: Icons.add,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final String semanticLabel;
  final VoidCallback? onPressed;
  final IconData icon;

  const _StepButton({
    required this.semanticLabel,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppTheme.compactButtonRadius,
        child: Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: onPressed != null
                ? AppColors.surfaceVariant
                : AppColors.surface,
            border: Border.all(
              color: onPressed != null
                  ? AppColors.border
                  : AppColors.surfaceVariant,
              width: 1,
            ),
            borderRadius: AppTheme.compactButtonRadius,
          ),
          child: Icon(
            icon,
            size: 14,
            color: onPressed != null
                ? AppColors.textPrimary
                : AppColors.borderBright,
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final VoidCallback onToggle;

  const _ToggleRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      button: true,
      label: '$label: $description',
      child: FocusableActionDetector(
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onToggle();
              return null;
            },
          ),
        },
        child: Builder(
          builder: (focusContext) => GestureDetector(
            onTap: () {
              Focus.of(focusContext).requestFocus();
              onToggle();
            },
            behavior: HitTestBehavior.translucent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: value
                                ? AppColors.focusColor
                                : AppColors.textPrimary,
                            fontSize: 14,
                            fontWeight: value
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _Switch(value: value),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  final bool value;

  const _Switch({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 36,
      height: 20,
      decoration: BoxDecoration(
        color: value ? AppColors.accentGreen : AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value ? AppColors.accentGreen : AppColors.border,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: value ? AppColors.textPrimary : AppColors.textSecondary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

/// Three-way font selector: System / Readable (Verdana) / OpenDyslexic.
/// Only one option can be active at a time, so there is no conflicting state.
class _FontChoiceGroup extends StatelessWidget {
  final AccessibilityState a11y;

  const _FontChoiceGroup({required this.a11y});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Font',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _FontButton(
              label: 'System',
              description: 'Default',
              selected: a11y.fontChoice == FontChoice.system,
              onTap: () => a11y.setFontChoice(FontChoice.system),
            ),
            const SizedBox(width: 6),
            _FontButton(
              label: 'Readable',
              description: 'Verdana',
              selected: a11y.fontChoice == FontChoice.readable,
              onTap: () => a11y.setFontChoice(FontChoice.readable),
            ),
            const SizedBox(width: 6),
            _FontButton(
              label: 'OpenDyslexic',
              description: 'Dyslexia-friendly',
              selected: a11y.fontChoice == FontChoice.openDyslexic,
              onTap: () => a11y.setFontChoice(FontChoice.openDyslexic),
            ),
          ],
        ),
      ],
    );
  }
}

class _FontButton extends StatelessWidget {
  final String label;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _FontButton({
    required this.label,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: 'Font: $label — $description',
        selected: selected,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.compactButtonRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.accent.withValues(alpha: 0.22)
                  : AppColors.surfaceVariant,
              border: Border.all(
                color: selected ? AppColors.focusRing : AppColors.border,
                width: 1,
              ),
              borderRadius: AppTheme.compactButtonRadius,
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.focusColor
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  description,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlignmentGroup extends StatelessWidget {
  final AccessibilityState a11y;

  const _AlignmentGroup({required this.a11y});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AlignButton(
          label: 'Left',
          icon: Icons.format_align_left,
          selected:
              a11y.textAlign == TextAlign.left ||
              a11y.textAlign == TextAlign.start,
          onTap: () => a11y.setTextAlign(TextAlign.left),
        ),
        const SizedBox(width: 6),
        _AlignButton(
          label: 'Center',
          icon: Icons.format_align_center,
          selected: a11y.textAlign == TextAlign.center,
          onTap: () => a11y.setTextAlign(TextAlign.center),
        ),
        const SizedBox(width: 6),
        _AlignButton(
          label: 'Right',
          icon: Icons.format_align_right,
          selected: a11y.textAlign == TextAlign.right,
          onTap: () => a11y.setTextAlign(TextAlign.right),
        ),
      ],
    );
  }
}

class _AlignButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _AlignButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        label: 'Align $label',
        selected: selected,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.compactButtonRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.accent.withValues(alpha: 0.22)
                  : AppColors.surfaceVariant,
              border: Border.all(
                color: selected ? AppColors.focusRing : AppColors.border,
                width: 1,
              ),
              borderRadius: AppTheme.compactButtonRadius,
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: selected
                      ? AppColors.focusColor
                      : AppColors.textSecondary,
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? AppColors.focusColor
                        : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadAloudSection extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;
  final String Function() getPageText;

  const _ReadAloudSection({
    required this.a11y,
    required this.tts,
    required this.getPageText,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: tts,
      builder: (_, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Playback controls — Wrap so buttons reflow on narrow columns.
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (tts.isIdle)
                  _TtsButton(
                    icon: Icons.play_arrow,
                    label: 'Read page aloud',
                    onTap: () => tts.speak(getPageText(), a11y.speechRate),
                  )
                else ...[
                  _TtsButton(
                    icon: tts.isPlaying ? Icons.pause : Icons.play_arrow,
                    label: tts.isPlaying ? 'Pause' : 'Resume',
                    onTap: tts.isPlaying ? tts.pause : tts.resume,
                  ),
                  _TtsButton(icon: Icons.stop, label: 'Stop', onTap: tts.stop),
                ],
                if (!TtsService.isSupported)
                  Text(
                    'Not available in this browser',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Speed selector
            Text(
              'Speed',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final speed in [0.75, 1.0, 1.25, 1.5])
                  _SpeedButton(
                    label: '${speed}x',
                    selected: (a11y.speechRate - speed).abs() < 0.01,
                    onTap: () {
                      a11y.setSpeechRate(speed);
                      if (tts.isPlaying) {
                        final text = tts.activeText;
                        tts.stop();
                        tts.speak(text, speed);
                      }
                    },
                  ),
              ],
            ),
            if (!tts.isIdle)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: LinearProgressIndicator(
                  value: null,
                  backgroundColor: AppColors.surfaceVariant,
                  color: AppColors.accentText,
                  minHeight: 2,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TtsButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _TtsButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.compactButtonRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            border: Border.all(color: AppColors.border, width: 1),
            borderRadius: AppTheme.compactButtonRadius,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.accentText),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SpeedButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: 'Speed $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppTheme.compactButtonRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.accent.withValues(alpha: 0.22)
                : AppColors.surfaceVariant,
            border: Border.all(
              color: selected ? AppColors.focusRing : AppColors.border,
              width: 1,
            ),
            borderRadius: AppTheme.compactButtonRadius,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.focusColor : AppColors.textSecondary,
              fontSize: 13,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetFooter extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;

  const _ResetFooter({required this.a11y, required this.tts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          ListenableBuilder(
            listenable: a11y,
            builder: (_, _) => a11y.hasAnyChange
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentText,
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox(width: 8, height: 8),
          ),
          TextButton.icon(
            onPressed: () {
              tts.stop();
              a11y.resetAll();
            },
            icon: const Icon(Icons.restart_alt, size: 14),
            label: const Text('Reset All Settings'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              textStyle: const TextStyle(fontSize: 14),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ],
      ),
    );
  }
}
