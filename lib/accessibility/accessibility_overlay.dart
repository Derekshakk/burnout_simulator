import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'accessibility_panel.dart';
import 'accessibility_scope.dart';
import 'accessibility_state.dart';
import 'reading_mask_overlay.dart';
import 'text_magnifier_overlay.dart';
import 'tts_controller.dart';

/// Top-level overlay widget added via MaterialApp.builder.
///
/// It sits *above* the Navigator, so it hosts only chrome that does not need
/// an [Overlay] ancestor: the content transforms (content scale, text align),
/// the reading mask, the text magnifier, and the floating accessibility button.
///
/// The settings **panel** is opened as a route via [showGeneralDialog] using
/// the Navigator's own context ([navigatorKey]). That places the panel — and
/// every [Tooltip] inside it — beneath the Navigator's Overlay, which is
/// required for Tooltip/Material overlays to work.
class AccessibilityOverlay extends StatefulWidget {
  final AccessibilityState a11yState;
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const AccessibilityOverlay({
    super.key,
    required this.a11yState,
    required this.navigatorKey,
    required this.child,
  });

  @override
  State<AccessibilityOverlay> createState() => _AccessibilityOverlayState();
}

class _AccessibilityOverlayState extends State<AccessibilityOverlay> {
  bool _panelOpen = false;
  final TtsController _tts = TtsController();
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  void dispose() {
    _tts.dispose();
    super.dispose();
  }

  String _getPageText() {
    // Best-effort page text for Read Aloud. A future revision can walk the
    // semantics tree; for now this provides a stable, non-empty utterance.
    return 'Page content for Burnout: One More Day. Use the accessibility '
        'panel to navigate and read content on this page.';
  }

  void _togglePanel() {
    if (_panelOpen) {
      _closePanel();
    } else {
      _openPanel();
    }
  }

  void _closePanel() {
    final navState = widget.navigatorKey.currentState;
    if (navState != null && navState.canPop()) {
      navState.pop();
    }
  }

  Future<void> _openPanel() {
    // Use the Navigator's context so the panel is pushed into the Navigator's
    // Overlay (Tooltips inside the panel require an Overlay ancestor).
    final navContext = widget.navigatorKey.currentContext;
    if (navContext == null) return Future.value();

    setState(() => _panelOpen = true);

    return showGeneralDialog<void>(
      context: navContext,
      barrierDismissible: true,
      barrierLabel: 'Dismiss accessibility preferences',
      barrierColor: Colors.black.withValues(alpha: 0.25),
      transitionDuration: const Duration(milliseconds: 200),
      routeSettings: const RouteSettings(name: 'accessibility-panel'),
      pageBuilder: (dialogContext, _, _) {
        return _AccessibilityPanelHost(
          a11y: widget.a11yState,
          tts: _tts,
          getPageText: _getPageText,
        );
      },
      transitionBuilder: (context, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.96, end: 1.0).animate(curved),
            alignment: Alignment.bottomRight,
            child: child,
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) setState(() => _panelOpen = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AccessibilityScope(
      state: widget.a11yState,
      child: ListenableBuilder(
        listenable: widget.a11yState,
        builder: (context, _) {
          final a11y = widget.a11yState;

          // Apply content scale via MediaQuery size override
          final mq = MediaQuery.of(context);
          final scaledMq = a11y.contentScale != 1.0
              ? mq.copyWith(size: mq.size / a11y.contentScale)
              : mq;

          Widget content = MediaQuery(
            data: scaledMq,
            child: Transform.scale(
              scale: a11y.contentScale,
              alignment: Alignment.topLeft,
              child: RepaintBoundary(key: _boundaryKey, child: widget.child),
            ),
          );

          // Apply text alignment globally via DefaultTextStyle
          final baseTextStyle = DefaultTextStyle.of(context);
          if (a11y.textAlign != TextAlign.start) {
            content = DefaultTextStyle(
              style: baseTextStyle.style,
              textAlign: a11y.textAlign,
              child: content,
            );
          }

          return Stack(
            children: [
              content,

              // Reading mask
              if (a11y.readingMask) ReadingMaskOverlay(a11yState: a11y),

              // Text magnifier
              if (a11y.textMagnifier)
                TextMagnifierOverlay(boundaryKey: _boundaryKey),

              // Floating accessibility button — bottom-right, at the viewport
              // edge so it never covers primary reading content.
              Positioned(
                bottom: 20,
                right: 20,
                child: _FloatingA11yButton(
                  isOpen: _panelOpen,
                  hasChanges: a11y.hasAnyChange,
                  onTap: _togglePanel,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Positions the [AccessibilityPanel] as a dismissible popover anchored to the
/// bottom-right, kept inside the viewport via [SafeArea] + constraints, and
/// closable with the Escape key.
class _AccessibilityPanelHost extends StatelessWidget {
  final AccessibilityState a11y;
  final TtsController tts;
  final String Function() getPageText;

  const _AccessibilityPanelHost({
    required this.a11y,
    required this.tts,
    required this.getPageText,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Leave room for the floating button (bottom-right) and screen margins.
    final maxWidth = size.width < 360 ? size.width - 24.0 : 560.0;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(),
      },
      child: FocusScope(
        autofocus: true,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              // Keep clear of the floating button (bottom-right) and give
              // small margins on the other edges for narrow screens.
              padding: const EdgeInsets.only(
                left: 12,
                right: 20,
                top: 12,
                bottom: 80,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                // Rebuild the panel on any settings change so its controls and
                // its own colors (High Contrast) update live.
                child: ListenableBuilder(
                  listenable: a11y,
                  builder: (_, _) => AccessibilityPanel(
                    a11y: a11y,
                    tts: tts,
                    onClose: () => Navigator.of(context).pop(),
                    getPageText: getPageText,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingA11yButton extends StatefulWidget {
  final bool isOpen;
  final bool hasChanges;
  final VoidCallback onTap;

  const _FloatingA11yButton({
    required this.isOpen,
    required this.hasChanges,
    required this.onTap,
  });

  @override
  State<_FloatingA11yButton> createState() => _FloatingA11yButtonState();
}

class _FloatingA11yButtonState extends State<_FloatingA11yButton> {
  bool _focused = false;

  void _handleActivate() => widget.onTap();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.isOpen
          ? 'Close accessibility panel'
          : 'Open accessibility preferences',
      child: FocusableActionDetector(
        onShowFocusHighlight: (f) => setState(() => _focused = f),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleActivate();
              return null;
            },
          ),
        },
        mouseCursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: widget.isOpen
                  ? const Color(0xFF58A6FF)
                  : const Color(0xFF21262D),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: _focused
                    ? const Color(0xFF79C0FF)
                    : widget.hasChanges
                    ? const Color(0xFF58A6FF)
                    : const Color(0xFF30363D),
                width: _focused ? 3 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  widget.isOpen ? Icons.close : Icons.accessibility_new,
                  color: widget.isOpen
                      ? const Color(0xFF0D1117)
                      : const Color(0xFF58A6FF),
                  size: 22,
                ),
                if (widget.hasChanges && !widget.isOpen)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF58A6FF),
                        shape: BoxShape.circle,
                      ),
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
