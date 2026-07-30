import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app/theme.dart';
import '../models/game_choice.dart';

class ChoiceButton extends StatefulWidget {
  final GameChoice choice;
  final String choiceLetter;
  final VoidCallback? onPressed;
  final bool isDisabled;
  final String? disabledReason;

  const ChoiceButton({
    super.key,
    required this.choice,
    required this.choiceLetter,
    this.onPressed,
    this.isDisabled = false,
    this.disabledReason,
  });

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isDisabled && widget.onPressed != null;
    final borderColor = (_hovered || _focused) && isEnabled
        ? AppColors.focusRing
        : isEnabled
        ? AppColors.borderBright
        : AppColors.border;
    final bgColor = !isEnabled
        ? AppColors.disabledSurface
        : (_hovered || _focused)
        ? AppColors.surfaceVariant
        : AppColors.surface;
    final textColor = widget.isDisabled
        ? AppColors.disabledText
        : AppColors.textPrimary;

    Widget button = Semantics(
      button: true,
      enabled: isEnabled,
      label: '${widget.choiceLetter}. ${widget.choice.label}',
      child: FocusableActionDetector(
        enabled: isEnabled,
        onShowFocusHighlight: (focused) => setState(() => _focused = focused),
        shortcuts: <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: MouseRegion(
          cursor: isEnabled
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: isEnabled ? widget.onPressed : null,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: AppTheme.buttonRadius,
                border: Border.all(color: borderColor, width: 1),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(right: 10, top: 1),
                        alignment: Alignment.center,
                        color: isEnabled
                            ? AppColors.accent.withValues(alpha: 0.15)
                            : AppColors.surfaceVariant,
                        child: Text(
                          widget.choiceLetter,
                          style: TextStyle(
                            color: isEnabled
                                ? AppColors.accentText
                                : AppColors.disabledText,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.choice.label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 32),
                    child: Text(
                      widget.isDisabled && widget.disabledReason != null
                          ? widget.disabledReason!
                          : widget.choice.description,
                      style: TextStyle(
                        color: widget.isDisabled
                            ? AppColors.disabledText
                            : AppColors.textSecondary,
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                  ),
                  if (widget.isDisabled && widget.disabledReason == null)
                    Padding(
                      padding: const EdgeInsets.only(left: 32, top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 12,
                            color: AppColors.disabledText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Not available right now',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.isDisabled && widget.disabledReason != null) {
      return Tooltip(message: widget.disabledReason!, child: button);
    }

    return button;
  }
}
