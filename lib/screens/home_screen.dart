import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import '../widgets/site_navigation.dart';

class HomeScreen extends StatefulWidget {
  final GameState gameState;

  const HomeScreen({super.key, required this.gameState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _burnoutKey = GlobalKey();
  final GlobalKey _resourcesKey = GlobalKey();
  String _activeSection = AppRoutes.home;
  bool _ignoreScrollUpdates = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveFromScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateActiveFromScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Returns the screen-space Y coordinate of the widget identified by [key],
  // or null if the widget is not yet laid out.
  double? _getScreenY(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return null;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    return box.localToGlobal(Offset.zero).dy;
  }

  void _updateActiveFromScroll() {
    if (_ignoreScrollUpdates) return;
    const activationThreshold = 56.0 + 120.0;
    final burnoutY = _getScreenY(_burnoutKey);
    final resourcesY = _getScreenY(_resourcesKey);

    String next = AppRoutes.home;
    if (resourcesY != null && resourcesY <= activationThreshold) {
      next = 'resources';
    } else if (burnoutY != null && burnoutY <= activationThreshold) {
      next = 'burnout';
    }

    if (next != _activeSection) {
      setState(() => _activeSection = next);
    }
  }

  void _scrollTo(GlobalKey key, String section) {
    setState(() => _activeSection = section);
    _ignoreScrollUpdates = true;
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).whenComplete(() {
        if (mounted) _ignoreScrollUpdates = false;
      });
    } else {
      _ignoreScrollUpdates = false;
    }
  }

  void _startGame() {
    widget.gameState.reset();
    Navigator.pushNamed(context, AppRoutes.play);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: _activeSection,
            onScrollToBurnout: () => _scrollTo(_burnoutKey, 'burnout'),
            onScrollToResources: () => _scrollTo(_resourcesKey, 'resources'),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _HeroSection(isMobile: isMobile, onPlay: _startGame),
                  _AboutSection(isMobile: isMobile, onPlay: _startGame),
                  _FeaturesSection(isMobile: isMobile),
                  _HowBurnoutWorksSection(key: _burnoutKey, isMobile: isMobile),
                  _ResourcesSection(key: _resourcesKey, isMobile: isMobile),
                  _Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onPlay;

  const _HeroSection({required this.isMobile, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.background, AppColors.surface],
        ),
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 80,
          vertical: isMobile ? 40 : 64,
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _HeroText(onPlay: onPlay),
                  const SizedBox(height: 40),
                  A11yImage(
                    semanticLabel:
                        'Pixel art illustration of a student at a desk',
                    child: _PixelHeroScene(),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 5, child: _HeroText(onPlay: onPlay)),
                  const SizedBox(width: 60),
                  Expanded(
                    flex: 4,
                    child: A11yImage(
                      semanticLabel:
                          'Pixel art illustration of a student at a desk',
                      child: _PixelHeroScene(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final VoidCallback onPlay;

  const _HeroText({required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          color: AppColors.accent.withValues(alpha: 0.15),
          child: Text(
            'EDUCATIONAL SIMULATION',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        A11yHeading(
          'Project\nIgnite',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 42,
            fontWeight: FontWeight.w800,
            height: 1.1,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        ReadingText(
          'Work with your mind, protect your energy,\nand make it through the day.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Play Prototype'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.about),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              child: const Text('Learn More'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Free · No account required · Educational content',
          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }
}

class _PixelHeroScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0a0f1a),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: ClipRect(
          child: Stack(
            children: [
              // Night sky gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF050d1a), Color(0xFF1a0f2e)],
                  ),
                ),
              ),
              // Stars
              ..._buildStars(),
              // Moon
              Positioned(
                top: 24,
                right: 40,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFFe8d5a3),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Building 1 (tall)
              Positioned(
                bottom: 60,
                left: 20,
                child: _Building(
                  width: 55,
                  height: 120,
                  color: const Color(0xFF1c2a3a),
                  windowRows: 4,
                  windowCols: 2,
                ),
              ),
              // Building 2 (medium)
              Positioned(
                bottom: 60,
                left: 85,
                child: _Building(
                  width: 40,
                  height: 80,
                  color: const Color(0xFF162230),
                  windowRows: 3,
                  windowCols: 2,
                ),
              ),
              // Building 3 (right tall)
              Positioned(
                bottom: 60,
                right: 15,
                child: _Building(
                  width: 60,
                  height: 100,
                  color: const Color(0xFF1e2d3d),
                  windowRows: 3,
                  windowCols: 3,
                ),
              ),
              // Ground
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(height: 60, color: const Color(0xFF0d1520)),
              ),
              // Room window overlay (front building / room)
              Positioned(bottom: 60, left: 0, right: 0, child: _RoomScene()),
              // Pixel art label
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  color: AppColors.background.withValues(alpha: 0.7),
                  child: Text(
                    'PROTOTYPE',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 8,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStars() {
    final positions = [
      const Offset(30, 15),
      const Offset(80, 25),
      const Offset(140, 10),
      const Offset(200, 30),
      const Offset(260, 12),
      const Offset(310, 28),
      const Offset(55, 45),
      const Offset(175, 50),
      const Offset(230, 40),
      const Offset(280, 55),
      const Offset(110, 35),
      const Offset(350, 20),
    ];
    return positions
        .asMap()
        .entries
        .map(
          (e) => Positioned(
            left: e.value.dx,
            top: e.value.dy,
            child: Container(
              width: e.key % 3 == 0 ? 2 : 1,
              height: e.key % 3 == 0 ? 2 : 1,
              color: const Color(0xFFe6edf3).withValues(alpha: 0.6),
            ),
          ),
        )
        .toList();
  }
}

class _Building extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final int windowRows;
  final int windowCols;

  const _Building({
    required this.width,
    required this.height,
    required this.color,
    required this.windowRows,
    required this.windowCols,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            windowRows,
            (row) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                windowCols,
                (col) => Container(
                  width: 6,
                  height: 8,
                  color: (row + col) % 3 != 0
                      ? const Color(0xFFffd54f).withValues(alpha: 0.6)
                      : const Color(0xFF1a2030),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomScene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          // Desk surface
          Positioned(
            bottom: 0,
            left: 60,
            right: 60,
            child: Container(height: 8, color: const Color(0xFF3d2b1f)),
          ),
          // Monitor on desk
          Positioned(
            bottom: 8,
            left: 90,
            child: Column(
              children: [
                Container(
                  width: 36,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e1e1e),
                    border: Border.all(
                      color: const Color(0xFF58a6ff).withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 28,
                      height: 18,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF1e3a5f),
                            const Color(0xFF0d1117),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 4, height: 6, color: const Color(0xFF2d2d2d)),
              ],
            ),
          ),
          // Books on desk
          Positioned(
            bottom: 8,
            right: 75,
            child: Row(
              children: [
                Container(width: 8, height: 20, color: const Color(0xFFd29922)),
                Container(width: 8, height: 16, color: const Color(0xFF3fb950)),
                Container(width: 8, height: 22, color: const Color(0xFFf85149)),
              ],
            ),
          ),
          // Character (simple pixel figure at desk)
          Positioned(bottom: 14, left: 68, child: _PixelCharacter()),
        ],
      ),
    );
  }
}

class _PixelCharacter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hair
        Container(width: 16, height: 4, color: const Color(0xFF4a3728)),
        // Head
        Container(
          width: 14,
          height: 14,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          color: const Color(0xFFe8c99a),
        ),
        // Body
        Container(
          width: 18,
          height: 12,
          color: const Color(0xFF58a6ff).withValues(alpha: 0.8),
        ),
      ],
    );
  }
}

class _AboutSection extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onPlay;

  const _AboutSection({required this.isMobile, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(text: 'ABOUT THIS GAME'),
          const SizedBox(height: 20),
          A11yHeading(
            'About Project Ignite',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ReadingText(
              'Project Ignite is an educational simulation designed to help players understand neurodivergent burnout from the inside. You guide Alex — a fictional high school student — through a single day, making choices that affect energy, focus, stress, and motivation.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ReadingText(
              'As burnout builds, activities that Alex normally enjoys may become unavailable — not as punishment, but to illustrate a real experience: wanting to do something does not always mean having the capacity to do it. By the end of the day, players see how their choices shaped Alex\'s state and which strategies helped most.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: onPlay,
            child: const Text('Play the Prototype'),
          ),
        ],
      ),
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  final bool isMobile;

  const _FeaturesSection({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(text: 'WHAT TO EXPECT'),
          const SizedBox(height: 20),
          A11yHeading(
            'Key Features',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 32),
          _FeatureGrid(isMobile: isMobile),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final bool isMobile;

  const _FeatureGrid({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    const features = [
      _FeatureItem(
        icon: Icons.fork_right,
        title: 'Choices with lasting consequences',
        description:
            'Every decision affects Alex\'s energy, focus, stress, and motivation for the rest of the day.',
      ),
      _FeatureItem(
        icon: Icons.battery_alert,
        title: 'Burnout that affects available actions',
        description:
            'As burnout rises, some activities become unavailable — with clear explanations for why.',
      ),
      _FeatureItem(
        icon: Icons.star_outline,
        title: 'Strengths and accommodations',
        description:
            'Discover how aligning tasks with strengths and practicing self-advocacy changes outcomes.',
      ),
      _FeatureItem(
        icon: Icons.schedule,
        title: 'Time and energy tradeoffs',
        description:
            'Not everything can be finished in a day. Learning what to prioritize is part of the lesson.',
      ),
      _FeatureItem(
        icon: Icons.school_outlined,
        title: 'Educational explanations',
        description:
            'After each choice, learn what happened and why — framed in supportive, nonjudgmental language.',
      ),
      _FeatureItem(
        icon: Icons.people_outline,
        title: 'Different experiences planned',
        description:
            'Future versions will include ADHD, autism, and AuDHD characters with distinct profiles.',
      ),
    ];

    if (isMobile) {
      return Column(
        children: features
            .map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _FeatureCard(feature: f),
              ),
            )
            .toList(),
      );
    }

    return Column(
      children: [
        _FeatureRow(features: features.sublist(0, 3)),
        const SizedBox(height: 16),
        _FeatureRow(features: features.sublist(3, 6)),
      ],
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final List<_FeatureItem> features;

  const _FeatureRow({required this.features});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: features.asMap().entries.expand((e) {
          return [
            if (e.key > 0) const SizedBox(width: 16),
            Expanded(child: _FeatureCard(feature: e.value)),
          ];
        }).toList(),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _FeatureCard extends StatelessWidget {
  final _FeatureItem feature;

  const _FeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(feature.icon, color: AppColors.accent, size: 22),
          const SizedBox(height: 12),
          Text(
            feature.title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          ReadingText(
            feature.description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HowBurnoutWorksSection extends StatelessWidget {
  final bool isMobile;

  const _HowBurnoutWorksSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(text: 'EDUCATIONAL CONTEXT'),
          const SizedBox(height: 20),
          A11yHeading(
            'How Burnout Works',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BurnoutPoint(
                  icon: Icons.warning_amber_outlined,
                  title: 'Burnout is not laziness',
                  body:
                      'Burnout is a state that results from sustained demand exceeding available capacity. It accumulates over time and may not be immediately visible to others.',
                ),
                _BurnoutPoint(
                  icon: Icons.battery_0_bar,
                  title: 'Capacity changes with burnout',
                  body:
                      'When burnout is high, activities that are normally possible may become genuinely inaccessible — including activities the person enjoys and wants to do. This is not a choice or a character flaw.',
                ),
                _BurnoutPoint(
                  icon: Icons.self_improvement,
                  title: 'Recovery takes time',
                  body:
                      'Sustainable functioning requires adequate recovery. Choosing rest is not giving up — it is how capacity is restored for future demands.',
                ),
                _BurnoutPoint(
                  icon: Icons.diversity_3,
                  title: 'Experiences vary widely',
                  body:
                      'This simulation uses fictional examples. It does not diagnose, nor does it represent every autistic or ADHD experience. Players should not use this game to draw conclusions about themselves or others.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 1),
              borderRadius: BorderRadius.zero,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.accent, size: 18),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This prototype is an educational tool. It is not a clinical assessment, diagnostic tool, or substitute for mental health support.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BurnoutPoint extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _BurnoutPoint({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 16),
            color: AppColors.surfaceVariant,
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.accent, size: 18),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                A11yHeading(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                ReadingText(
                  body,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResourcesSection extends StatelessWidget {
  final bool isMobile;

  const _ResourcesSection({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(text: 'IMPORTANT NOTICE'),
          const SizedBox(height: 20),
          A11yHeading(
            'Resources & Disclaimer',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border.all(
                color: AppColors.accentAmber.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.health_and_safety_outlined,
                      color: AppColors.accentAmber,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Educational Prototype — Not Medical Advice',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Text(
                  'This prototype is an educational simulation intended for learning and discussion. It is not medical or mental health treatment, and does not replace professional support. If you or someone you know is experiencing burnout, please reach out to a trusted adult, school counselor, or mental health professional.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 14),
                Text(
                  'The character Alex and all scenarios in this prototype are fictional and created solely for educational purposes. They do not represent any real individuals or the full range of neurodivergent experiences.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Ignite — Educational Prototype for SNP-REACH 2026',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  'Fictional content · Not for diagnosis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Project Ignite — Educational Prototype for SNP-REACH 2026',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  'Fictional content · Not for diagnosis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      color: AppColors.accent.withValues(alpha: 0.1),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.accent,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}
