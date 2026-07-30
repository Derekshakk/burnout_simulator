import 'package:flutter/material.dart';

import '../app/theme.dart';

/// A small uppercase label for public-page sections and screen headers.
///
/// The fill keeps the coral cue subtle while semantic primary text preserves
/// readable contrast in both the default and high-contrast palettes.
class SectionLabel extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;

  const SectionLabel({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: backgroundColor ?? AppColors.accent.withValues(alpha: 0.15),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
