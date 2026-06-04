import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'sections/about_section.dart';
import 'sections/contact_section.dart';
import 'sections/experience_section.dart';
import 'sections/hero_section.dart';
import 'sections/projects_section.dart';
import 'sections/skills_section.dart';
import 'theme/app_theme.dart';
import 'widgets/animated_background.dart';
import 'widgets/nav_bar.dart';
import 'widgets/scroll_provider.dart';
import 'widgets/splash_screen.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, _) {
        AppColors.isDark = isDark;
        return MaterialApp(
          title: 'Sonu Kumar · Senior Flutter Developer',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.themed(isDark),
          scrollBehavior: const _WebScrollBehavior(),
          // Outermost opaque background — guarantees the page bg matches the
          // theme even behind everything else.
          builder: (context, child) =>
              ColoredBox(color: AppColors.bg, child: child),
          home: const SplashGate(),
        );
      },
    );
  }
}

/// Shows the animated [SplashScreen] on top of [HomePage], then lifts it away
/// like a curtain to reveal the site.
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate>
    with SingleTickerProviderStateMixin {
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  );
  bool _removed = false;

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  void _startReveal() {
    _reveal.forward().whenComplete(() {
      if (mounted) setState(() => _removed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HomePage(),
        if (!_removed)
          AnimatedBuilder(
            animation: _reveal,
            builder: (context, child) {
              final curve = Curves.easeInOutCubic.transform(_reveal.value);
              final h = MediaQuery.of(context).size.height;
              return Transform.translate(
                offset: Offset(0, -curve * h),
                child: Opacity(
                  opacity: (1 - _reveal.value * 1.1).clamp(0.0, 1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(curve * 48),
                    ),
                    child: child,
                  ),
                ),
              );
            },
            child: SplashScreen(onGreetingsDone: _startReveal),
          ),
      ],
    );
  }
}

/// Lets the page be dragged with mouse / touch / trackpad on web.
class _WebScrollBehavior extends MaterialScrollBehavior {
  const _WebScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scroll = ScrollController();
  bool _scrolled = false;
  double _progress = 0;

  final _aboutKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final s = _scroll.offset > 40;
      final max = _scroll.position.maxScrollExtent;
      final p = max <= 0 ? 0.0 : (_scroll.offset / max).clamp(0.0, 1.0);
      if (s != _scrolled || (p - _progress).abs() > 0.002) {
        setState(() {
          _scrolled = s;
          _progress = p;
        });
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollTop() {
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild the whole page when the theme toggles (bypasses const ancestors).
    return ValueListenableBuilder<bool>(
      valueListenable: themeNotifier,
      builder: (context, isDark, child) => _scaffold(context),
    );
  }

  Widget _scaffold(BuildContext context) {
    final navItems = [
      NavItem('About', () => _scrollTo(_aboutKey)),
      NavItem('Skills', () => _scrollTo(_skillsKey)),
      NavItem('Experience', () => _scrollTo(_experienceKey)),
      NavItem('Projects', () => _scrollTo(_projectsKey)),
      NavItem('Contact', () => _scrollTo(_contactKey)),
    ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: AnimatedBackground()),
          // Scrollable content.
          Positioned.fill(
            child: ScrollProvider(
              controller: _scroll,
              child: SingleChildScrollView(
                controller: _scroll,
                child: Column(
                  children: [
                    HeroSection(
                      onViewWork: () => _scrollTo(_projectsKey),
                      onContact: () => _scrollTo(_contactKey),
                    ),
                    KeyedSubtree(key: _aboutKey, child: AboutSection()),
                    KeyedSubtree(key: _skillsKey, child: SkillsSection()),
                    KeyedSubtree(
                      key: _experienceKey,
                      child: ExperienceSection(),
                    ),
                    KeyedSubtree(key: _projectsKey, child: ProjectsSection()),
                    KeyedSubtree(key: _contactKey, child: ContactSection()),
                  ],
                ),
              ),
            ),
          ),
          // Sticky nav on top.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavBar(
              scrolled: _scrolled,
              items: navItems,
              onLogoTap: _scrollTop,
            ),
          ),
          // Scroll-progress gradient bar.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _progress,
                  child: Container(
                    decoration: const BoxDecoration(gradient: AppColors.accent),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
