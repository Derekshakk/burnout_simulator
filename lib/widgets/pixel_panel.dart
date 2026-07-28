import 'package:flutter/material.dart';
import '../app/theme.dart';

class PixelPanel extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool showCornerAccents;

  const PixelPanel({
    super.key,
    required this.child,
    this.title,
    this.borderColor,
    this.backgroundColor,
    this.padding,
    this.showCornerAccents = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? AppColors.border;
    final bg = backgroundColor ?? AppColors.surface;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: 1),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) _TitleBar(title: title!, borderColor: border),
              Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ],
          ),
        ),
        if (showCornerAccents) ...[
          Positioned(top: 0, left: 0, child: _CornerAccent(color: border)),
          Positioned(top: 0, right: 0, child: _CornerAccent(color: border)),
          Positioned(bottom: 0, left: 0, child: _CornerAccent(color: border)),
          Positioned(bottom: 0, right: 0, child: _CornerAccent(color: border)),
        ],
      ],
    );
  }
}

class _TitleBar extends StatelessWidget {
  final String title;
  final Color borderColor;

  const _TitleBar({required this.title, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: borderColor, width: 1)),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 13,
          letterSpacing: 1.0,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _CornerAccent extends StatelessWidget {
  final Color color;

  const _CornerAccent({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 6, height: 6, child: ColoredBox(color: color));
  }
}
