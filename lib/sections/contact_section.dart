import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';
import '../widgets/hover_lift.dart';
import '../widgets/reveal_on_scroll.dart';
import '../widgets/section_shell.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final mobile = isMobile(context);
    return Padding(
      padding: sectionPadding(width),
      child: Column(
        children: [
          RevealOnScroll(
            child: Column(
              children: [
                GradientText(
                  "Let's build something great.",
                  align: TextAlign.center,
                  gradient: AppColors.accentDiagonal,
                  style: AppTheme.display(mobile ? 30 : 46),
                ),
                const SizedBox(height: 18),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: const Text(
                    "Have a project in mind or a role to fill? "
                    "I'm always open to discussing new opportunities.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                HoverLift(
                  scale: 1.04,
                  glow: AppColors.primary,
                  radius: BorderRadius.circular(14),
                  child: GestureDetector(
                    onTap: () => openUrl('mailto:${PortfolioData.email}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.accent,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mail_outline,
                            color: Colors.white,
                            size: 19,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Email Me',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          RevealOnScroll(
            delay: const Duration(milliseconds: 120),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _ContactChip(
                  icon: Icons.code,
                  label: 'GitHub',
                  onTap: () => openUrl(PortfolioData.github),
                ),
                _ContactChip(
                  icon: Icons.work_outline,
                  label: 'LinkedIn',
                  onTap: () => openUrl(PortfolioData.linkedin),
                ),
                _ContactChip(
                  icon: Icons.terminal,
                  label: 'LeetCode',
                  onTap: () => openUrl(PortfolioData.leetcode),
                ),
                _ContactChip(
                  icon: Icons.phone_outlined,
                  label: PortfolioData.phone,
                  onTap: () => openUrl('tel:${PortfolioData.phone}'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 72),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 24),
          Text(
            '© 2026 ${PortfolioData.name}  ·  Built with Flutter 💙',
            style: const TextStyle(color: AppColors.textFaint, fontSize: 13),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      scale: 1.05,
      lift: 4,
      radius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow(y: 8, blur: 20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.secondary),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
