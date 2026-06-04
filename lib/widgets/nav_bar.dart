import 'dart:ui';
import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../utils/launch_url.dart';
import '../widgets/gradient_text.dart';

class NavItem {
  final String label;
  final VoidCallback onTap;
  const NavItem(this.label, this.onTap);
}

/// Top navigation. Becomes a frosted bar once the user scrolls, and collapses
/// to a menu button on small screens.
class NavBar extends StatelessWidget {
  final bool scrolled;
  final List<NavItem> items;
  final VoidCallback onLogoTap;
  const NavBar({
    super.key,
    required this.scrolled,
    required this.items,
    required this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final compact = width < 820;
    final hPad = width >= 1100 ? (width - 1100) / 2 + 24 : 22.0;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: scrolled ? 14 : 0,
          sigmaY: scrolled ? 14 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.symmetric(
            horizontal: hPad,
            vertical: scrolled ? 12 : 20,
          ),
          decoration: BoxDecoration(
            color: scrolled
                ? AppColors.bg.withValues(alpha: 0.72)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: scrolled ? AppColors.border : Colors.transparent,
              ),
            ),
            boxShadow: scrolled
                ? [
                    BoxShadow(
                      color: const Color(0xFF1B1240).withValues(alpha: 0.05),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: onLogoTap,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GradientText(
                    'SK.',
                    gradient: AppColors.accent,
                    style: AppTheme.display(26),
                  ),
                ),
              ),
              if (compact)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _ThemeToggle(),
                    const SizedBox(width: 2),
                    PopupMenuButton<int>(
                      color: AppColors.surface,
                      icon: Icon(Icons.menu, color: AppColors.text),
                      onSelected: (i) => i == items.length
                          ? openUrl(PortfolioData.resume)
                          : items[i].onTap(),
                      itemBuilder: (context) => [
                        for (int i = 0; i < items.length; i++)
                          PopupMenuItem(
                            value: i,
                            child: Text(
                              items[i].label,
                              style: TextStyle(color: AppColors.text),
                            ),
                          ),
                        PopupMenuItem(
                          value: items.length,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.description_outlined,
                                size: 16,
                                color: AppColors.secondary,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Resume',
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Row(
                  children: [
                    for (final item in items) _NavLink(item: item),
                    const SizedBox(width: 6),
                    const _ThemeToggle(),
                    const SizedBox(width: 10),
                    _ResumeButton(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final NavItem item;
  const _NavLink({required this.item});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            widget.item.label,
            style: TextStyle(
              color: _hover ? AppColors.text : AppColors.textMuted,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _ResumeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openUrl(PortfolioData.resume),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.secondary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                size: 15,
                color: AppColors.secondary,
              ),
              SizedBox(width: 6),
              Text(
                'Resume',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w600,
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

/// Sun / moon button that flips the app between dark and light mode with a
/// smooth icon transition.
class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final dark = themeNotifier.value;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: dark ? 'Switch to light mode' : 'Switch to dark mode',
        child: GestureDetector(
          onTap: () => themeNotifier.value = !themeNotifier.value,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: Tween(begin: 0.6, end: 1.0).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: Icon(
                dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(dark),
                size: 19,
                color: AppColors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Static labels used to build the nav; kept here so [PortfolioData] stays
/// content-only.
const navLabels = ['About', 'Skills', 'Experience', 'Projects', 'Contact'];
