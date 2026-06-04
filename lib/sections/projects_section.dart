import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../utils/launch_url.dart';
import '../widgets/hover_lift.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_shell.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.bgAlt,
      padding: sectionPadding(width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(kicker: 'Work', title: 'Featured Projects'),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, c) {
              final cols = c.maxWidth >= 980
                  ? 3
                  : c.maxWidth >= 640
                  ? 2
                  : 1;
              const gap = 22.0;
              final cardW = (c.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (int i = 0; i < PortfolioData.projects.length; i++)
                    SizedBox(
                      width: cardW,
                      child: RevealOnScroll(
                        delay: Duration(milliseconds: 70 * i),
                        child: _ProjectCard(project: PortfolioData.projects[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      scale: 1.02,
      lift: 8,
      glow: project.accent,
      radius: BorderRadius.circular(22),
      child: GestureDetector(
        onTap: project.link == null ? null : () => openUrl(project.link!),
        child: Container(
          height: 320,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header strip with the project's accent.
              Container(
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      project.accent.withValues(alpha: 0.35),
                      project.accent.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: project.accent.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.phone_android,
                        color: project.accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            project.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          Text(
                            project.stack,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (project.store != null) _StoreBadge(project: project),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          project.description,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                            height: 1.55,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final t in project.tags)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceHi,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                t,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
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

/// Small "live on the store" pill shown on published apps.
class _StoreBadge extends StatelessWidget {
  final Project project;
  const _StoreBadge({required this.project});

  @override
  Widget build(BuildContext context) {
    final isApple = project.store == 'App Store';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: project.accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isApple ? Icons.apple : Icons.play_arrow_rounded,
            size: 14,
            color: project.accent,
          ),
          const SizedBox(width: 5),
          Text(
            project.store!,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: project.accent,
            ),
          ),
          const SizedBox(width: 3),
          Icon(Icons.north_east, size: 11, color: project.accent),
        ],
      ),
    );
  }
}
