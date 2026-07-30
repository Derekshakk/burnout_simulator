import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../accessibility/accessibility_scope.dart';
import '../app/routes.dart';
import '../app/session_navigation.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import 'project_ignite_logo.dart';

class SiteNavigation extends StatefulWidget {
  final String activeSection;
  final GameState gameState;
  final VoidCallback? onScrollToResources;
  final VoidCallback? onScrollToContact;

  const SiteNavigation({
    super.key,
    required this.activeSection,
    required this.gameState,
    this.onScrollToResources,
    this.onScrollToContact,
  });

  @override
  State<SiteNavigation> createState() => _SiteNavigationState();
}

class _SiteNavigationState extends State<SiteNavigation> {
  bool _menuOpen = false;

  void _navigate(BuildContext context, String route) {
    setState(() => _menuOpen = false);
    switch (route) {
      case AppRoutes.home:
        SessionNavigation.goHome(context, widget.gameState);
      case AppRoutes.about:
        SessionNavigation.goAbout(context, widget.gameState);
      case AppRoutes.burnout:
        SessionNavigation.goHomeSection(
          context,
          widget.gameState,
          AppRoutes.burnout,
        );
      case AppRoutes.team:
        SessionNavigation.goHomeSection(
          context,
          widget.gameState,
          AppRoutes.team,
        );
      case AppRoutes.play:
      case AppRoutes.select:
        SessionNavigation.startNewGame(context, widget.gameState);
      default:
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
    }
  }

  void _handleResources(BuildContext context) {
    setState(() => _menuOpen = false);
    if (widget.onScrollToResources != null) {
      widget.onScrollToResources!();
    } else {
      SessionNavigation.goHomeSection(
        context,
        widget.gameState,
        AppRoutes.resources,
      );
    }
  }

  void _handleContact(BuildContext context) {
    setState(() => _menuOpen = false);
    if (widget.onScrollToContact != null) {
      widget.onScrollToContact!();
    } else {
      SessionNavigation.goHomeSection(
        context,
        widget.gameState,
        AppRoutes.contact,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 1100;
    // At larger mobile widths, keep the direct Play control. On narrower
    // layouts (including enlarged-text users), place it in the menu instead
    // so the header cannot overflow.
    final showMobilePlayButton = isMobile && width >= 500;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.publicNavigationBackground,
            border: Border(
              bottom: BorderSide(
                color: AppColors.textPrimary.withValues(alpha: 0.45),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
            child: Row(
              children: [
                _LogoWidget(isMobile: isMobile),
                const Spacer(),
                if (!isMobile) ...[
                  _NavLink(
                    label: 'Home',
                    route: AppRoutes.home,
                    activeSection: widget.activeSection,
                    onTap: () => _navigate(context, AppRoutes.home),
                  ),
                  _NavLink(
                    label: 'About the Game',
                    route: AppRoutes.about,
                    activeSection: widget.activeSection,
                    onTap: () => _navigate(context, AppRoutes.about),
                  ),
                  _NavLink(
                    label: 'How Burnout Works',
                    route: AppRoutes.burnout,
                    activeSection: widget.activeSection,
                    onTap: () => _navigate(context, AppRoutes.burnout),
                  ),
                  _NavLink(
                    label: 'Resources',
                    route: 'resources',
                    activeSection: widget.activeSection,
                    onTap: () => _handleResources(context),
                  ),
                  _NavLink(
                    label: 'Team',
                    route: AppRoutes.team,
                    activeSection: widget.activeSection,
                    onTap: () => _navigate(context, AppRoutes.team),
                  ),
                  _NavLink(
                    label: 'Contact',
                    route: 'contact',
                    activeSection: widget.activeSection,
                    onTap: () => _handleContact(context),
                  ),
                  const SizedBox(width: 16),
                  _PlayButton(
                    onTap: () => _navigate(context, AppRoutes.play),
                    isActive: widget.activeSection == AppRoutes.play,
                  ),
                ] else ...[
                  if (showMobilePlayButton &&
                      widget.activeSection != AppRoutes.play) ...[
                    _PlayButton(
                      onTap: () => _navigate(context, AppRoutes.play),
                      isActive: false,
                    ),
                    const SizedBox(width: 8),
                  ],
                  IconButton(
                    icon: Icon(
                      _menuOpen ? Icons.close : Icons.menu,
                      color: AppColors.textPrimary,
                    ),
                    tooltip: _menuOpen ? 'Close menu' : 'Open menu',
                    onPressed: () => setState(() => _menuOpen = !_menuOpen),
                  ),
                ],
              ],
            ),
          ),
        ),
        if (isMobile && _menuOpen)
          _MobileMenu(
            activeSection: widget.activeSection,
            onNavigate: (route) => _navigate(context, route),
            onResources: () => _handleResources(context),
            onContact: () => _handleContact(context),
            showPlayItem: !showMobilePlayButton,
          ),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  final bool isMobile;

  const _LogoWidget({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return ProjectIgniteLogo(height: isMobile ? 34 : 42);
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final String route;
  final String activeSection;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.route,
    required this.activeSection,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  bool get _isActive => widget.activeSection == widget.route;

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.textPrimary.withValues(
      alpha: _hovered || _isActive ? 1 : 0.82,
    );

    final highlightLinks =
        AccessibilityScope.maybeOf(context)?.highlightLinks ?? false;

    return Semantics(
      button: true,
      selected: _isActive,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: FocusableActionDetector(
          shortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _isActive || _hovered
                    ? AppColors.surface.withValues(
                        alpha: _isActive ? 0.55 : 0.3,
                      )
                    : null,
                border: Border(
                  bottom: BorderSide(
                    color: _isActive
                        ? AppColors.textPrimary
                        : Colors.transparent,
                    width: 2,
                  ),
                  top: highlightLinks && !_isActive
                      ? BorderSide(color: AppColors.borderBright, width: 1)
                      : BorderSide.none,
                  left: highlightLinks && !_isActive
                      ? BorderSide(color: AppColors.borderBright, width: 1)
                      : BorderSide.none,
                  right: highlightLinks && !_isActive
                      ? BorderSide(color: AppColors.borderBright, width: 1)
                      : BorderSide.none,
                ),
                borderRadius: AppTheme.compactButtonRadius,
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: _isActive ? FontWeight.w600 : FontWeight.w400,
                  decoration: highlightLinks && !_isActive
                      ? TextDecoration.underline
                      : null,
                  decorationColor: textColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isActive;

  const _PlayButton({required this.onTap, required this.isActive});

  @override
  State<_PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<_PlayButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final highlightLinks =
        AccessibilityScope.maybeOf(context)?.highlightLinks ?? false;
    return Semantics(
      button: true,
      label: 'Play Game',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: FocusableActionDetector(
          onShowFocusHighlight: (f) => setState(() => _focused = f),
          shortcuts: {
            SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
            SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          },
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                widget.onTap();
                return null;
              },
            ),
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _hovered || widget.isActive || _focused
                    ? AppColors.surface.withValues(alpha: 0.8)
                    : AppColors.surface.withValues(alpha: 0.55),
                border: Border.all(
                  color: AppColors.textPrimary,
                  width: highlightLinks ? 2 : 1,
                ),
                borderRadius: AppTheme.compactButtonRadius,
              ),
              child: Text(
                'Play Game',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  decoration: highlightLinks ? TextDecoration.underline : null,
                  decorationColor: widget.isActive || _hovered
                      ? AppColors.textPrimary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final String activeSection;
  final void Function(String route) onNavigate;
  final VoidCallback onResources;
  final VoidCallback onContact;
  final bool showPlayItem;

  const _MobileMenu({
    required this.activeSection,
    required this.onNavigate,
    required this.onResources,
    required this.onContact,
    required this.showPlayItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.publicNavigationBackground,
        border: Border(
          bottom: BorderSide(
            color: AppColors.textPrimary.withValues(alpha: 0.45),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showPlayItem)
            _MobileMenuItem(
              label: 'Play Game',
              isActive: activeSection == AppRoutes.play,
              onTap: () => onNavigate(AppRoutes.play),
            ),
          _MobileMenuItem(
            label: 'Home',
            isActive: activeSection == AppRoutes.home,
            onTap: () => onNavigate(AppRoutes.home),
          ),
          _MobileMenuItem(
            label: 'About the Game',
            isActive: activeSection == AppRoutes.about,
            onTap: () => onNavigate(AppRoutes.about),
          ),
          _MobileMenuItem(
            label: 'How Burnout Works',
            isActive: activeSection == AppRoutes.burnout,
            onTap: () => onNavigate(AppRoutes.burnout),
          ),
          _MobileMenuItem(
            label: 'Resources',
            isActive: activeSection == 'resources',
            onTap: onResources,
          ),
          _MobileMenuItem(
            label: 'Team',
            isActive: activeSection == AppRoutes.team,
            onTap: () => onNavigate(AppRoutes.team),
          ),
          _MobileMenuItem(
            label: 'Contact',
            isActive: activeSection == 'contact',
            onTap: onContact,
          ),
        ],
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _MobileMenuItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.compactButtonRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.surface.withValues(alpha: 0.55) : null,
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
          borderRadius: AppTheme.compactButtonRadius,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
