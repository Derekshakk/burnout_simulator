import 'package:flutter/material.dart';
import '../app/theme.dart';
import 'accessibility_state.dart';

/// A full-screen overlay that dims the page above and below a horizontal
/// reading-focus band that tracks the pointer/touch position.
class ReadingMaskOverlay extends StatefulWidget {
  final AccessibilityState a11yState;

  const ReadingMaskOverlay({super.key, required this.a11yState});

  @override
  State<ReadingMaskOverlay> createState() => _ReadingMaskOverlayState();
}

class _ReadingMaskOverlayState extends State<ReadingMaskOverlay> {
  double _pointerY = 200;

  double get _bandHeight {
    // ~1.5 lines tall: base 28px scaled by font size and line height
    final lineH =
        18.0 *
        widget.a11yState.fontSizeScale *
        widget.a11yState.lineHeightScale;
    return (lineH * 1.6).clamp(24.0, 72.0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: MouseRegion(
        opaque: false,
        onHover: (e) => setState(() => _pointerY = e.position.dy),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: (e) => setState(() => _pointerY = e.position.dy),
          child: IgnorePointer(
            child: CustomPaint(
              painter: _MaskPainter(
                pointerY: _pointerY,
                bandHeight: _bandHeight,
              ),
              size: Size.infinite,
            ),
          ),
        ),
      ),
    );
  }
}

class _MaskPainter extends CustomPainter {
  final double pointerY;
  final double bandHeight;

  _MaskPainter({required this.pointerY, required this.bandHeight});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.readingMask;

    final top = pointerY - bandHeight / 2;
    final bottom = pointerY + bandHeight / 2;

    // Mask above the reading band
    if (top > 0) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, top.clamp(0, size.height)),
        paint,
      );
    }
    // Mask below the reading band
    if (bottom < size.height) {
      canvas.drawRect(
        Rect.fromLTWH(
          0,
          bottom.clamp(0, size.height),
          size.width,
          (size.height - bottom).clamp(0, size.height),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_MaskPainter old) =>
      old.pointerY != pointerY || old.bandHeight != bandHeight;
}
