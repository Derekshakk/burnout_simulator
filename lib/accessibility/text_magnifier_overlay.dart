import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../app/theme.dart';
import 'package:flutter/rendering.dart';

/// Floating text magnifier that captures a screenshot region beneath the cursor
/// and displays it at 2× zoom in a light-background popup.
class TextMagnifierOverlay extends StatefulWidget {
  final GlobalKey boundaryKey;

  const TextMagnifierOverlay({super.key, required this.boundaryKey});

  @override
  State<TextMagnifierOverlay> createState() => _TextMagnifierOverlayState();
}

class _TextMagnifierOverlayState extends State<TextMagnifierOverlay> {
  Offset _pointer = Offset.zero;
  ui.Image? _image;
  Timer? _timer;
  bool _visible = false;

  static const double _zoom = 2.2;
  static const double _w = 280;
  static const double _h = 100;
  static const double _captureW = _w / _zoom;
  static const double _captureH = _h / _zoom;

  void _onPointerMove(Offset global) {
    _pointer = global;
    _visible = true;
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 60), _capture);
    setState(() {});
  }

  void _onPointerExit() {
    _timer?.cancel();
    setState(() => _visible = false);
  }

  Future<void> _capture() async {
    final boundary = widget.boundaryKey.currentContext?.findRenderObject();
    if (boundary == null || boundary is! RenderRepaintBoundary) return;
    try {
      final img = await boundary.toImage(pixelRatio: _zoom);
      if (mounted) setState(() => _image = img);
    } catch (_) {}
  }

  /// Position the magnifier so it stays fully within the viewport, offset above
  /// or below the cursor with a small gap.
  Offset _computePosition(Size screen) {
    const gapY = 20.0;
    const marginX = 12.0;

    double x = _pointer.dx - _w / 2;
    double y = _pointer.dy - _h - gapY;

    // Flip below cursor if too close to top
    if (y < 8) y = _pointer.dy + gapY;
    // Clamp horizontally
    if (x < marginX) x = marginX;
    if (x + _w > screen.width - marginX) x = screen.width - _w - marginX;
    // Clamp vertically
    if (y + _h > screen.height - 8) y = screen.height - _h - 8;
    if (y < 8) y = 8;

    return Offset(x, y);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Positioned.fill(
      child: MouseRegion(
        opaque: false,
        onHover: (e) => _onPointerMove(e.position),
        onExit: (_) => _onPointerExit(),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: (e) => _onPointerMove(e.position),
          onPointerUp: (_) => _onPointerExit(),
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _visible && _image != null ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 120),
              child: Builder(
                builder: (ctx) {
                  if (_image == null) return const SizedBox.shrink();
                  final pos = _computePosition(screen);
                  return Stack(
                    children: [
                      Positioned(
                        left: pos.dx,
                        top: pos.dy,
                        child: _MagnifierBox(
                          image: _image!,
                          pointerLocal: _pointer,
                          zoom: _zoom,
                          width: _w,
                          height: _h,
                          captureW: _captureW,
                          captureH: _captureH,
                          boundaryKey: widget.boundaryKey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MagnifierBox extends StatelessWidget {
  final ui.Image image;
  final Offset pointerLocal;
  final double zoom;
  final double width;
  final double height;
  final double captureW;
  final double captureH;
  final GlobalKey boundaryKey;

  const _MagnifierBox({
    required this.image,
    required this.pointerLocal,
    required this.zoom,
    required this.width,
    required this.height,
    required this.captureW,
    required this.captureH,
    required this.boundaryKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.magnifierSurface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: AppColors.overlayScrim.withValues(alpha: 0.27),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: AppColors.magnifierBorder, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: CustomPaint(
          painter: _MagnifierPainter(
            image: image,
            pointerGlobal: pointerLocal,
            zoom: zoom,
            captureW: captureW,
            captureH: captureH,
            boundaryKey: boundaryKey,
          ),
          size: Size(width, height),
        ),
      ),
    );
  }
}

class _MagnifierPainter extends CustomPainter {
  final ui.Image image;
  final Offset pointerGlobal;
  final double zoom;
  final double captureW;
  final double captureH;
  final GlobalKey boundaryKey;

  _MagnifierPainter({
    required this.image,
    required this.pointerGlobal,
    required this.zoom,
    required this.captureW,
    required this.captureH,
    required this.boundaryKey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Compute pointer position relative to the repaint boundary
    final box = boundaryKey.currentContext?.findRenderObject();
    Offset localPointer = pointerGlobal;
    if (box is RenderBox) {
      localPointer = box.globalToLocal(pointerGlobal);
    }

    // Source rect in the image (scaled by zoom because toImage uses pixelRatio=zoom)
    final srcX = ((localPointer.dx - captureW / 2) * zoom).clamp(
      0.0,
      (image.width - captureW * zoom).clamp(0.0, double.infinity),
    );
    final srcY = ((localPointer.dy - captureH / 2) * zoom).clamp(
      0.0,
      (image.height - captureH * zoom).clamp(0.0, double.infinity),
    );

    final src = Rect.fromLTWH(srcX, srcY, captureW * zoom, captureH * zoom);
    final dst = Rect.fromLTWH(0, 0, size.width, size.height);

    // White background first (ensures light bg even over dark page areas)
    canvas.drawRect(dst, Paint()..color = AppColors.magnifierSurface);
    canvas.drawImageRect(
      image,
      src,
      dst,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(_MagnifierPainter old) =>
      old.image != image || old.pointerGlobal != pointerGlobal;
}
