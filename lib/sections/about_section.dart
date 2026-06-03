import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_shell.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mobile = isMobile(context);
    return Padding(
      padding: sectionPadding(width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(kicker: 'About', title: 'Who I Am'),
          const SizedBox(height: 32),
          RevealOnScroll(
            delay: const Duration(milliseconds: 120),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Text(
                PortfolioData.about,
                style: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
          const SizedBox(height: 56),
          RevealOnScroll(
            delay: const Duration(milliseconds: 200),
            child: Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                for (final s in PortfolioData.stats)
                  SizedBox(
                    width: mobile ? 150 : 200,
                    child: _StatCard(stat: s),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final Stat stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow(y: 12, blur: 30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (b) => AppColors.accent.createShader(
              Rect.fromLTWH(0, 0, b.width, b.height),
            ),
            child: Text(
              stat.value,
              style: AppTheme.display(40).copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            stat.label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
