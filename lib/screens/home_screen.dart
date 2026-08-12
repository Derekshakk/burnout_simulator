import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import '../services/external_action_service.dart';
import '../widgets/site_navigation.dart';
import '../widgets/project_ignite_logo.dart';
import '../widgets/section_label.dart';

class HomeScreen extends StatefulWidget {
  final GameState gameState;
  final String? initialSection;

  const HomeScreen({super.key, required this.gameState, this.initialSection});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _resourcesKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  String _activeSection = AppRoutes.home;
  bool _ignoreScrollUpdates = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateActiveFromScroll);
    final section = widget.initialSection;
    if (section != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollTo(_keyForSection(section), section);
      });
    }
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
    final resourcesY = _getScreenY(_resourcesKey);
    final contactY = _getScreenY(_contactKey);

    String next = AppRoutes.home;
    if (resourcesY != null && resourcesY <= activationThreshold) {
      next = 'resources';
    } else if (contactY != null && contactY <= activationThreshold) {
      next = 'contact';
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

  GlobalKey _keyForSection(String section) {
    switch (section) {
      case 'resources':
        return _resourcesKey;
      case 'contact':
        return _contactKey;
      default:
        return _resourcesKey;
    }
  }

  void _startGame() {
    widget.gameState.reset();
    Navigator.pushNamed(context, AppRoutes.select);
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
            gameState: widget.gameState,
            onScrollToResources: () => _scrollTo(_resourcesKey, 'resources'),
            onScrollToContact: () => _scrollTo(_contactKey, 'contact'),
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
                  _ExplorePreviewSection(isMobile: isMobile),
                  _ContactSection(key: _contactKey, isMobile: isMobile),
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
        // The peach page color remains visible if the image cannot be loaded.
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/home/home.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (context, error, stackTrace) =>
                  ColoredBox(color: AppColors.background),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 80,
              vertical: isMobile ? 40 : 64,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isMobile ? 520 : 640),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.surface.withValues(alpha: 0.84),
                      AppColors.surface.withValues(alpha: 0.62),
                    ],
                  ),
                  border: Border.all(
                    color: AppColors.surface.withValues(alpha: 0.75),
                  ),
                  borderRadius: AppTheme.buttonRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _HeroText(onPlay: onPlay, isMobile: isMobile),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final VoidCallback onPlay;
  final bool isMobile;

  const _HeroText({required this.onPlay, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabel(
          text: 'EDUCATIONAL SIMULATION',
          backgroundColor: AppColors.background.withValues(alpha: 0.92),
          textColor: AppColors.textPrimary,
        ),
        const SizedBox(height: 16),
        ProjectIgniteLogo(height: isMobile ? 112 : 156),
        const SizedBox(height: 16),
        ReadingText(
          'Work with your mind, protect your energy,\nand make it through the day.',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            ElevatedButton.icon(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Play Game'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: AppTheme.buttonRadius,
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
                  borderRadius: AppTheme.buttonRadius,
                ),
              ),
              child: const Text('Learn More'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Free · No account required · Educational content',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
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
          const SectionLabel(text: 'ABOUT THIS GAME'),
          const SizedBox(height: 20),
          A11yHeading(
            'About Project Ignite',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ReadingText(
              'Project Ignite is an educational simulation designed to help players understand neurodivergent burnout from the inside. You guide a fictional high school student through a single day, making choices that affect energy, focus, stress, and motivation.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ReadingText(
              'As burnout builds, activities a student normally enjoys may become unavailable — not as punishment, but to illustrate a real experience: wanting to do something does not always mean having the capacity to do it. By the end of the day, players see how their choices shaped the student\'s state and which strategies helped most.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(onPressed: onPlay, child: const Text('Play the Game')),
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
          const SectionLabel(text: 'WHAT TO EXPECT'),
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
            'Every decision affects the student\'s energy, focus, stress, and motivation for the rest of the day.',
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
        title: 'Three characters to explore',
        description:
            'Choose from fictional students with distinct strengths, triggers, and recovery strategies that shape the day differently.',
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 8),
          ReadingText(
            feature.description,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExplorePreviewSection extends StatelessWidget {
  final bool isMobile;

  const _ExplorePreviewSection({required this.isMobile});

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
          const SectionLabel(text: 'LEARN MORE'),
          const SizedBox(height: 20),
          A11yHeading(
            'Explore the Project',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 32),
          if (isMobile)
            Column(
              children: [
                _ExploreCard(
                  icon: Icons.psychology_outlined,
                  title: 'How Burnout Works',
                  body:
                      'Understand what neurodivergent burnout is, why masking adds to the load, and how recovery and coping take many forms.',
                  buttonLabel: 'Learn How Burnout Works',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.burnout),
                ),
                const SizedBox(height: 16),
                _ExploreCard(
                  icon: Icons.people_outline,
                  title: 'Meet the Team',
                  body:
                      'Project Ignite is a student-built game developed for SNP-REACH 2026. Meet the people behind the project.',
                  buttonLabel: 'Meet the Team',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.team),
                ),
              ],
            )
          else
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _ExploreCard(
                      icon: Icons.psychology_outlined,
                      title: 'How Burnout Works',
                      body:
                          'Understand what neurodivergent burnout is, why masking adds to the load, and how recovery and coping take many forms.',
                      buttonLabel: 'Learn How Burnout Works',
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.burnout),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _ExploreCard(
                      icon: Icons.people_outline,
                      title: 'Meet the Team',
                      body:
                          'Project Ignite is a student-built game developed for SNP-REACH 2026. Meet the people behind the project.',
                      buttonLabel: 'Meet the Team',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.team),
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

class _ExploreCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String buttonLabel;
  final VoidCallback onTap;

  const _ExploreCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.accent, size: 28),
          const SizedBox(height: 16),
          A11yHeading(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ReadingText(
            body,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onTap, child: Text(buttonLabel)),
        ],
      ),
    );
  }
}

// ── Contact / Feedback ────────────────────────────────────────────────────────

class _ContactSection extends StatefulWidget {
  final bool isMobile;

  const _ContactSection({super.key, required this.isMobile});

  @override
  State<_ContactSection> createState() => _ContactSectionState();
}

enum _ContactState { form, launched, failed }

class _ContactSectionState extends State<_ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _messageController = TextEditingController();

  _ContactState _state = _ContactState.form;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final role = _roleController.text.trim();
    final message = _messageController.text.trim();

    final uri = ExternalActionService.contactEmailUri(
      name: name,
      email: email,
      role: role,
      message: message,
    );
    final launched = await ExternalActionService.openEmail(uri);
    if (mounted) {
      setState(
        () => _state = launched ? _ContactState.launched : _ContactState.failed,
      );
    }
  }

  Future<void> _openFeedbackForm() async {
    final opened = await ExternalActionService.openWebsite(
      ExternalActionService.feedbackUrl,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not open the feedback form. Please try again later.',
          ),
        ),
      );
    }
  }

  void _reset() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _emailController.clear();
    _roleController.clear();
    _messageController.clear();
    setState(() => _state = _ContactState.form);
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(2),
        borderSide: BorderSide(color: AppColors.accent, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 20 : 80,
        vertical: 56,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: 'CONTACT / FEEDBACK'),
          const SizedBox(height: 20),
          A11yHeading(
            'Get in touch',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReadingText(
                  'Questions about the simulation, its educational content, or the project? We\'d love to hear from you.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _openFeedbackForm,
                  icon: const Icon(Icons.feedback_outlined, size: 16),
                  label: const Text('Share Feedback or Suggestions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navBackground,
                    foregroundColor: AppColors.textOnDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (_state == _ContactState.form) ...[
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: _fieldDecoration('Full Name *'),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _emailController,
                          decoration: _fieldDecoration('Email address *'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!v.contains('@') || !v.contains('.')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _roleController,
                          decoration: _fieldDecoration(
                            'Role or reason for contacting (optional)',
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _messageController,
                          decoration: _fieldDecoration('Message *'),
                          maxLines: 5,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Please enter a message'
                              : null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Send via Email'),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Tapping 'Send via Email' opens your email app with a prefilled message. Your submission is only complete once you send the email from your app.",
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            height: 1.55,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else if (_state == _ContactState.launched) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber.withValues(alpha: 0.08),
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
                              Icons.mail_outline,
                              color: AppColors.accentAmber,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Email app opened',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your email app should have opened with a prefilled message addressed to Dereksha2008@gmail.com. Please review the message and press Send in your email app to complete your submission. Your message has not been sent yet.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _reset,
                          child: const Text('Fill out again'),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accentRed.withValues(alpha: 0.08),
                      border: Border.all(
                        color: AppColors.accentRed.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: AppColors.accentRed,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Could not open email app',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your email app could not be opened automatically. You can contact us directly at Dereksha2008@gmail.com.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: _reset,
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Resources ─────────────────────────────────────────────────────────────────

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
          const SectionLabel(text: 'IMPORTANT NOTICE'),
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Educational Game — Not Medical Advice',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'This game is an educational simulation intended for learning and discussion. It is not medical or mental health treatment, and does not replace professional support. If you or someone you know is experiencing burnout, please reach out to a trusted adult, school counselor, or mental health professional.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'The characters and scenarios in this game are fictional and created solely for educational purposes. They do not represent any real individuals or the full range of neurodivergent experiences.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    height: 1.65,
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
                  'Project Ignite — Educational Game for SNP-REACH 2026',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fictional content · Not for diagnosis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Project Ignite — Educational Game for SNP-REACH 2026',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Fictional content · Not for diagnosis',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ],
            ),
    );
  }
}
