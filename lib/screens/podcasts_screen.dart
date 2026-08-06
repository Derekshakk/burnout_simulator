import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../models/game_state.dart';
import '../widgets/section_label.dart';
import '../widgets/site_navigation.dart';

const _episodes = [
  (
    title: 'A Conversation With Charlotte',
    youtubeId: '88TJ-HQA_qk',
    watchUrl: 'https://youtu.be/88TJ-HQA_qk?si=q-zWk6W--GXo0qV-',
  ),
];

class PodcastsScreen extends StatelessWidget {
  final GameState gameState;

  const PodcastsScreen({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SiteNavigation(
            activeSection: AppRoutes.podcasts,
            gameState: gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(isMobile: isMobile),
                  _PodcastsBody(isMobile: isMobile),
                  _PageFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  final bool isMobile;

  const _PageHeader({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 56,
      ),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel(text: 'PODCASTS'),
          const SizedBox(height: 20),
          A11yHeading(
            'Listen and learn',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ReadingText(
              'Podcast episodes related to neurodivergence, burnout, and the work behind Project Ignite.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 17,
                height: 1.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PodcastsBody extends StatelessWidget {
  final bool isMobile;

  const _PodcastsBody({required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _episodes
            .map(
              (ep) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _EpisodeCard(
                  title: ep.title,
                  youtubeId: ep.youtubeId,
                  watchUrl: ep.watchUrl,
                  isMobile: isMobile,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _EpisodeCard extends StatefulWidget {
  final String title;
  final String youtubeId;
  final String watchUrl;
  final bool isMobile;

  const _EpisodeCard({
    required this.title,
    required this.youtubeId,
    required this.watchUrl,
    required this.isMobile,
  });

  @override
  State<_EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<_EpisodeCard> {
  bool _hovered = false;

  String get _thumbnailUrl =>
      'https://img.youtube.com/vi/${widget.youtubeId}/maxresdefault.jpg';

  Future<void> _open() async {
    await launchUrl(
      Uri.parse(widget.watchUrl),
      mode: LaunchMode.platformDefault,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 720),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: widget.isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Thumbnail(
                    url: _thumbnailUrl,
                    hovered: _hovered,
                    onTap: _open,
                    onHover: (v) => setState(() => _hovered = v),
                  ),
                  _EpisodeInfo(title: widget.title, onWatch: _open),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 280,
                    child: _Thumbnail(
                      url: _thumbnailUrl,
                      hovered: _hovered,
                      onTap: _open,
                      onHover: (v) => setState(() => _hovered = v),
                    ),
                  ),
                  Expanded(
                    child: _EpisodeInfo(title: widget.title, onWatch: _open),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String url;
  final bool hovered;
  final VoidCallback onTap;
  final ValueChanged<bool> onHover;

  const _Thumbnail({
    required this.url,
    required this.hovered,
    required this.onTap,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, err, stack) => ColoredBox(
                  color: AppColors.surfaceVariant,
                  child: Icon(
                    Icons.play_circle_outline,
                    color: AppColors.textMuted,
                    size: 48,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: Colors.black.withValues(alpha: hovered ? 0.25 : 0.1),
              ),
              Center(
                child: AnimatedScale(
                  scale: hovered ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
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
}

class _EpisodeInfo extends StatelessWidget {
  final String title;
  final VoidCallback onWatch;

  const _EpisodeInfo({required this.title, required this.onWatch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smart_display_outlined,
                color: AppColors.accentRed,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                'YouTube',
                style: TextStyle(
                  color: AppColors.accentRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onWatch,
            icon: const Icon(Icons.play_arrow_rounded, size: 18),
            label: const Text('Watch on YouTube'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navBackground,
              foregroundColor: AppColors.textOnDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageFooter extends StatelessWidget {
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
