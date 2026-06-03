import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_shell.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: sectionPadding(width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            kicker: 'Career',
            title: 'Professional Experience',
          ),
          const SizedBox(height: 44),
          for (int i = 0; i < PortfolioData.experiences.length; i++)
            RevealOnScroll(
              delay: Duration(milliseconds: 90 * i),
              child: _TimelineItem(
                exp: PortfolioData.experiences[i],
                isLast: i == PortfolioData.experiences.length - 1,
              ),
            ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final Experience exp;
  final bool isLast;
  const _TimelineItem({required this.exp, required this.isLast});

  Widget _titleBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          exp.title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          exp.company,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.secondary,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  gradient: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bg, width: 3),
                ),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: AppColors.border)),
            ],
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 36),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppColors.softShadow(y: 12, blur: 30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (mobile)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _titleBlock(),
                          const SizedBox(height: 10),
                          _Badge(
                            icon: Icons.calendar_today_outlined,
                            label: exp.period,
                          ),
                        ],
                      )
                    else
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _titleBlock()),
                          const SizedBox(width: 12),
                          _Badge(
                            icon: Icons.calendar_today_outlined,
                            label: exp.period,
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.place_outlined,
                          size: 15,
                          color: AppColors.textFaint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          exp.location,
                          style: const TextStyle(
                            color: AppColors.textFaint,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (final p in exp.points)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 7, right: 12),
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                gradient: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                p,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 15,
                                  height: 1.55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceHi,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
