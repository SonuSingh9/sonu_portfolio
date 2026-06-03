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

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sonu Kumar · Senior Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      scrollBehavior: const _WebScrollBehavior(),
      home: const HomePage(),
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
      if (s != _scrolled) setState(() => _scrolled = s);
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
          const Positioned.fill(child: AnimatedBackground()),
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
                    KeyedSubtree(key: _aboutKey, child: const AboutSection()),
                    KeyedSubtree(key: _skillsKey, child: const SkillsSection()),
                    KeyedSubtree(
                      key: _experienceKey,
                      child: const ExperienceSection(),
                    ),
                    KeyedSubtree(
                      key: _projectsKey,
                      child: const ProjectsSection(),
                    ),
                    KeyedSubtree(
                      key: _contactKey,
                      child: const ContactSection(),
                    ),
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
        ],
      ),
    );
  }
}
