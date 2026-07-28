import 'package:flutter/material.dart';
import '../app/theme.dart';

class StatusMeter extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String? tooltipMessage;
  final bool invertScale;

  const StatusMeter({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.tooltipMessage,
    this.invertScale = false,
  });

  Color _effectiveColor() {
    if (invertScale) {
      if (value > 70) return AppColors.accentRed;
      if (value > 40) return AppColors.accentAmber;
      return AppColors.accentGreen;
    }
    if (value < 30) return AppColors.accentRed;
    if (value < 50) return AppColors.accentAmber;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = _effectiveColor();
    final clampedValue = value.clamp(0, 100) / 100;

    return Semantics(
      label: '$label: ${value.round()} out of 100',
      child: Tooltip(
        message: tooltipMessage ?? '$label: ${value.round()}',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  '${value.round()}',
                  style: TextStyle(
                    color: effectiveColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 6,
              child: ClipRect(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.surfaceVariant,
                    ),
                    FractionallySizedBox(
                      widthFactor: clampedValue,
                      child: Container(color: effectiveColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BurnoutMeter extends StatelessWidget {
  final double value;
  final String range;

  const BurnoutMeter({super.key, required this.value, required this.range});

  Color _color() {
    if (range == 'high') return AppColors.burnoutHigh;
    if (range == 'elevated') return AppColors.burnoutMid;
    return AppColors.burnoutLow;
  }

  String _rangeLabel() {
    if (range == 'high') return 'HIGH';
    if (range == 'elevated') return 'ELEVATED';
    return 'LOW';
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final clampedValue = value.clamp(0, 100) / 100;

    return Semantics(
      label: 'Burnout level: ${value.round()} — ${_rangeLabel()}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'BURNOUT',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                color: color.withValues(alpha: 0.2),
                child: Text(
                  _rangeLabel(),
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 8,
            child: ClipRect(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: AppColors.surfaceVariant,
                  ),
                  FractionallySizedBox(
                    widthFactor: clampedValue,
                    child: Container(color: color),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
