import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/scroll_provider.dart';
import '../widgets/section_shell.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cols = width >= 980 ? 2 : 1;
    return Container(
      color: AppColors.bgAlt,
      padding: sectionPadding(width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(kicker: 'Skills', title: 'What I Work With'),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, c) {
              final gap = 22.0;
              final cardW = cols == 1 ? c.maxWidth : (c.maxWidth - gap) / 2;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (int i = 0; i < PortfolioData.skillGroups.length; i++)
                    SizedBox(
                      width: cardW,
                      child: RevealOnScroll(
                        delay: Duration(milliseconds: 80 * i),
                        child: _SkillCard(group: PortfolioData.skillGroups[i]),
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

class _SkillCard extends StatelessWidget {
  final SkillGroup group;
  const _SkillCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            group.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 20),
          for (final s in group.skills) _SkillBar(skill: s),
        ],
      ),
    );
  }
}

class _SkillBar extends StatefulWidget {
  final Skill skill;
  const _SkillBar({required this.skill});

  @override
  State<_SkillBar> createState() => _SkillBarState();
}

class _SkillBarState extends State<_SkillBar> {
  bool _animate = false;
  ScrollController? _controller;

  void _check() {
    if (_animate || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    if (dy < MediaQuery.of(context).size.height * 0.92) {
      setState(() => _animate = true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final c = ScrollProvider.of(context);
    if (c != _controller) {
      _controller?.removeListener(_check);
      _controller = c;
      _controller?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    _controller?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.skill.name,
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                '${(widget.skill.level * 100).round()}%',
                style: TextStyle(color: AppColors.textFaint, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(height: 8, color: AppColors.surfaceHi),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1100),
                  curve: Curves.easeOutCubic,
                  tween: Tween(
                    begin: 0,
                    end: _animate ? widget.skill.level : 0,
                  ),
                  builder: (context, v, _) => FractionallySizedBox(
                    widthFactor: v,
                    child: Container(
                      height: 8,
                      decoration: const BoxDecoration(
                        gradient: AppColors.accent,
                      ),
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
