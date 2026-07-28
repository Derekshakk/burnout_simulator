import 'package:flutter/material.dart';
import '../accessibility/accessibility_scope.dart';
import '../app/routes.dart';
import '../app/theme.dart';

class SiteNavigation extends StatefulWidget {
  final String activeSection;
  final VoidCallback? onScrollToBurnout;
  final VoidCallback? onScrollToResources;

  const SiteNavigation({
    super.key,
    required this.activeSection,
    this.onScrollToBurnout,
    this.onScrollToResources,
  });

  @override
  State<SiteNavigation> createState() => _SiteNavigationState();
}

class _SiteNavigationState extends State<SiteNavigation> {
  bool _menuOpen = false;

  void _navigate(BuildContext context, String route) {
    setState(() => _menuOpen = false);
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }

  void _handleBurnout(BuildContext context) {
    setState(() => _menuOpen = false);
    if (widget.onScrollToBurnout != null) {
      widget.onScrollToBurnout!();
    } else {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  void _handleResources(BuildContext context) {
    setState(() => _menuOpen = false);
    if (widget.onScrollToResources != null) {
      widget.onScrollToResources!();
    } else {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 960;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
            child: Row(
              children: [
                _LogoWidget(),
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
                    route: 'burnout',
                    activeSection: widget.activeSection,
                    onTap: () => _handleBurnout(context),
                  ),
                  _NavLink(
                    label: 'Resources',
                    route: 'resources',
                    activeSection: widget.activeSection,
                    onTap: () => _handleResources(context),
                  ),
                  const SizedBox(width: 16),
                  _PlayButton(
                    onTap: () => _navigate(context, AppRoutes.play),
                    isActive: widget.activeSection == AppRoutes.play,
                  ),
                ] else ...[
                  if (widget.activeSection != AppRoutes.play)
                    _PlayButton(
                      onTap: () => _navigate(context, AppRoutes.play),
                      isActive: false,
                    ),
                  const SizedBox(width: 8),
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
            onBurnout: () => _handleBurnout(context),
            onResources: () => _handleResources(context),
          ),
      ],
    );
  }
}

class _LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          color: AppColors.accent,
          alignment: Alignment.center,
          child: Icon(Icons.psychology, color: AppColors.background, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          'PROJECT IGNITE',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
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
    final textColor = _isActive
        ? AppColors.accent
        : _hovered
        ? AppColors.textPrimary
        : AppColors.textSecondary;

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
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: _isActive ? AppColors.accent : Colors.transparent,
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
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
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

  @override
  Widget build(BuildContext context) {
    final highlightLinks =
        AccessibilityScope.maybeOf(context)?.highlightLinks ?? false;
    return Semantics(
      button: true,
      label: 'Play Prototype',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: widget.isActive
                  ? AppColors.accent
                  : _hovered
                  ? AppColors.accent.withValues(alpha: 0.9)
                  : AppColors.accent.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.accent,
                width: highlightLinks ? 2 : 1,
              ),
            ),
            child: Text(
              'Play Prototype',
              style: TextStyle(
                color: widget.isActive || _hovered
                    ? AppColors.background
                    : AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                decoration: highlightLinks ? TextDecoration.underline : null,
                decorationColor: widget.isActive || _hovered
                    ? AppColors.background
                    : AppColors.accent,
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
  final VoidCallback onBurnout;
  final VoidCallback onResources;

  const _MobileMenu({
    required this.activeSection,
    required this.onNavigate,
    required this.onBurnout,
    required this.onResources,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            isActive: activeSection == 'burnout',
            onTap: onBurnout,
          ),
          _MobileMenuItem(
            label: 'Resources',
            isActive: activeSection == 'resources',
            onTap: onResources,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.accent : AppColors.textPrimary,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
