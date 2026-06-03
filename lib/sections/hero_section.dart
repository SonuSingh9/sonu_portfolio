import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_text.dart';
import '../widgets/hover_lift.dart';
import '../widgets/section_shell.dart';
import '../widgets/typewriter.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onViewWork;
  final VoidCallback onContact;
  const HeroSection({
    super.key,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final twoCol = width >= 960;
    return Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      padding: sectionPadding(width).copyWith(top: 130, bottom: 60),
      alignment: Alignment.center,
      child: twoCol
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 6, child: _text(context)),
                const SizedBox(width: 40),
                Expanded(flex: 5, child: _FloatingIllustration()),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _text(context),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                  child: SizedBox(
                    height: 300,
                    child: SvgPicture.asset(
                      'assets/svg/hero_device.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _text(BuildContext context) {
    final mobile = isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _availabilityPill(),
        const SizedBox(height: 26),
        Text(
          "Hi, I'm",
          style: TextStyle(
            fontSize: mobile ? 19 : 24,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        GradientText(
          PortfolioData.name,
          gradient: AppColors.accentDiagonal,
          style: AppTheme.display(mobile ? 48 : 78),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              '> ',
              style: TextStyle(
                fontSize: mobile ? 20 : 30,
                color: AppColors.secondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            Flexible(
              child: Typewriter(
                phrases: PortfolioData.roles,
                style: TextStyle(
                  fontSize: mobile ? 20 : 30,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            PortfolioData.tagline,
            style: TextStyle(
              fontSize: mobile ? 16 : 18,
              height: 1.65,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _PrimaryButton(label: 'View My Work', onTap: onViewWork),
            _GhostButton(onTap: onContact),
          ],
        ),
        const SizedBox(height: 48),
        _scrollHint(),
      ],
    );
  }

  Widget _availabilityPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow(y: 6, blur: 16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF22C55E),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          const Text(
            'Available for new opportunities',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _scrollHint() {
    return Row(
      children: [
        const Icon(Icons.mouse_outlined, color: AppColors.textFaint, size: 18),
        const SizedBox(width: 8),
        const Text(
          'Scroll to explore',
          style: TextStyle(color: AppColors.textFaint, fontSize: 13),
        ),
      ],
    );
  }
}

/// Gently bobs the hero SVG up and down for a lively feel.
class _FloatingIllustration extends StatefulWidget {
  @override
  State<_FloatingIllustration> createState() => _FloatingIllustrationState();
}

class _FloatingIllustrationState extends State<_FloatingIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final dy = (Curves.easeInOut.transform(_c.value) - 0.5) * 18;
        return Transform.translate(offset: Offset(0, dy), child: child);
      },
      child: SvgPicture.asset('assets/svg/hero_device.svg', height: 520),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      scale: 1.04,
      glow: AppColors.primary,
      radius: BorderRadius.circular(14),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: AppColors.accent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.32),
                blurRadius: 24,
                spreadRadius: -6,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatelessWidget {
  final VoidCallback onTap;
  const _GhostButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return HoverLift(
      scale: 1.04,
      radius: BorderRadius.circular(14),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
            boxShadow: AppColors.softShadow(y: 8, blur: 20),
          ),
          child: const Text(
            'Get In Touch',
            style: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
