import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.isDisabled && widget.onPressed != null;
    final borderColor = _hovered && isEnabled
        ? AppColors.accent
        : isEnabled
        ? AppColors.borderBright
        : AppColors.border;
    final bgColor = _hovered && isEnabled
        ? AppColors.surfaceVariant
        : AppColors.surface;
    final textColor = widget.isDisabled
        ? AppColors.textMuted
        : AppColors.textPrimary;

    Widget button = MouseRegion(
      cursor: isEnabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.forbidden,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: isEnabled ? widget.onPressed : null,
        child: Semantics(
          button: true,
          enabled: isEnabled,
          label: '${widget.choiceLetter}. ${widget.choice.label}',
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: bgColor,
              border: Border(
                left: BorderSide(
                  color: isEnabled ? AppColors.accent : AppColors.textMuted,
                  width: 3,
                ),
                top: BorderSide(color: borderColor, width: 1),
                right: BorderSide(color: borderColor, width: 1),
                bottom: BorderSide(color: borderColor, width: 1),
              ),
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
                              ? AppColors.accent
                              : AppColors.textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.choice.label,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
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
                          ? AppColors.textMuted
                          : AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
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
                          color: AppColors.textMuted,
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
    );

    if (widget.isDisabled && widget.disabledReason != null) {
      return Tooltip(message: widget.disabledReason!, child: button);
    }

    return button;
  }
}
