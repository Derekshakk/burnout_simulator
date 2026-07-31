import 'package:flutter/material.dart';
import '../accessibility/a11y_widgets.dart';
import '../app/routes.dart';
import '../app/theme.dart';
import '../data/team_loader.dart';
import '../models/game_state.dart';
import '../widgets/section_label.dart';
import '../widgets/site_navigation.dart';

class TeamScreen extends StatefulWidget {
  final GameState gameState;

  const TeamScreen({super.key, required this.gameState});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  late Future<List<TeamMember>> _future;

  @override
  void initState() {
    super.initState();
    _future = loadTeamMembers();
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
            activeSection: AppRoutes.team,
            gameState: widget.gameState,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _PageHeader(isMobile: isMobile),
                  _TeamGrid(isMobile: isMobile, future: _future),
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
          const SectionLabel(text: 'MEET THE TEAM'),
          const SizedBox(height: 20),
          A11yHeading(
            'The people behind Project Ignite',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: ReadingText(
              'Project Ignite is a student-built game developed for SNP-REACH 2026.',
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

class _TeamGrid extends StatelessWidget {
  final bool isMobile;
  final Future<List<TeamMember>> future;

  const _TeamGrid({required this.isMobile, required this.future});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 64,
      ),
      color: AppColors.surfaceVariant,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<TeamMember>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              final members = snapshot.data ?? [];
              if (members.isEmpty) {
                return Text(
                  'Team information will appear here once assets/team/ files are added.',
                  style: TextStyle(
                    color: AppColors.accentAmber,
                    fontSize: 14,
                    height: 1.5,
                  ),
                );
              }
              if (isMobile) {
                return Column(
                  children: members
                      .map(
                        (m) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _TeamCard(member: m),
                        ),
                      )
                      .toList(),
                );
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 20) / 2;
                  return Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: members
                        .map(
                          (m) => SizedBox(
                            width: cardWidth,
                            child: _TeamCard(member: m),
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: AppColors.accentAmber.withValues(alpha: 0.12),
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: AppColors.accentAmber,
                  size: 13,
                ),
                const SizedBox(width: 6),
                Text(
                  'PLACEHOLDER — Replace names and roles before publishing',
                  style: TextStyle(
                    color: AppColors.accentAmber,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
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

class _TeamCard extends StatelessWidget {
  final TeamMember member;

  const _TeamCard({required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (member.hasPhoto)
              Image.asset(
                member.imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: 80,
                height: 80,
                color: AppColors.surfaceVariant,
                alignment: Alignment.center,
                child: Icon(Icons.person, color: AppColors.accent, size: 36),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.role,
                    style: TextStyle(color: AppColors.accent, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  ReadingText(
                    member.bio,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
