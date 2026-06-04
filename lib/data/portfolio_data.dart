import 'package:flutter/material.dart';

/// All content for the portfolio lives here so it is easy to update.
class PortfolioData {
  static const String name = 'Sonu Kumar';
  static const String role = 'Senior Flutter Developer';
  static const List<String> roles = [
    'Senior Flutter Developer',
    'Cross-Platform Engineer',
    'UI / UX Developer',
    'Mobile App Architect',
  ];

  static const String tagline =
      'I build scalable, beautiful cross-platform apps with clean '
      'architecture, smooth animations, and pixel-perfect UI.';

  static const String about =
      'Computer Science graduate and Senior App Developer with hands-on '
      'experience building production Flutter applications. I specialise in '
      'clean architecture, API-driven dynamic UIs, multi-role workflows and '
      'performance optimisation across Android and iOS. From fintech loan '
      'platforms to AI-powered marketplaces, I turn complex requirements into '
      'maintainable, delightful product experiences.';

  static const String email = 'mr.sonukumar470@gmail.com';
  static const String phone = '+91 9608655547';
  static const String location = 'Greater Noida, India';
  static const String github = 'https://github.com/SonuSingh9';
  static const String linkedin =
      'https://www.linkedin.com/in/sonu-kumar-a89227247/';
  static const String leetcode = 'https://leetcode.com/u/sonusngh100/';
  static const String resume =
      'https://drive.google.com/file/d/1sUSqlt9s1whnHEKpRZqWcRDiLPPnfYli/view?usp=sharing';

  static const List<Stat> stats = [
    Stat('2+', 'Years Experience'),
    Stat('6+', 'Apps Shipped'),
    Stat('35%', 'Avg. Scalability Gain'),
    Stat('3', 'Companies'),
  ];

  static const List<Experience> experiences = [
    Experience(
      company: 'Unjob.ai',
      title: 'Senior App Developer',
      period: 'Nov 2025 — Present',
      location: 'Greater Noida',
      points: [
        'Built and scaled a cross-platform Flutter application supporting multi-role user workflows.',
        'Designed a modular architecture using clean-architecture principles for scalable development.',
        'Integrated RESTful APIs and optimised data handling to improve performance and load times.',
        'Led technical execution with a focus on code quality and stability.',
      ],
    ),
    Experience(
      company: 'Electronica Finance Limited',
      title: 'Flutter Developer',
      period: 'Aug 2024 — Oct 2025',
      location: 'Pune',
      points: [
        'Developed a lead-management system using Flutter with a clean, responsive UI.',
        'Contributed to React Native modules including API integration and push notifications.',
        'Optimised UI performance and API handling across the product.',
      ],
    ),
    Experience(
      company: 'HikmaSpark',
      title: 'Flutter Developer',
      period: 'May 2024 — Aug 2024',
      location: 'Indore',
      points: [
        'Integrated REST APIs to fetch and display product listings and details.',
        'Optimised UI performance and reduced screen load time by 20%.',
      ],
    ),
  ];

  static const List<Project> projects = [
    Project(
      name: 'Unjob AI',
      stack: 'Flutter • Clean Architecture',
      description:
          'A scalable cross-platform Flutter app with multi-role workflows, '
          'secure auth and dynamic API-driven screens. Improved maintainability '
          'by 35% and cut onboarding friction by 30%.',
      tags: ['Flutter', 'REST API', 'Auth', 'Clean Arch'],
      accent: Color(0xFF7C3AED),
      link: 'https://play.google.com/store/apps/details?id=com.unjob.app',
    ),
    Project(
      name: 'FlexiRentor',
      stack: 'Flutter • BLoC',
      description:
          'A rental marketplace — "Rent Anything, From Anywhere". Browse '
          'furniture, appliances, bikes & electronics near you, book with just '
          '₹99 and pay the rest before delivery. Features location-based '
          'discovery, vendor listings (150+ vendors, 1000+ items), secure '
          'payments and an earnings dashboard for owners.',
      tags: ['Flutter', 'BLoC', 'Marketplace', 'Payments'],
      accent: Color(0xFF2E7D32),
      link: 'https://play.google.com/store/apps/details?id=com.app.flexirentor',
    ),
    Project(
      name: 'EFL clik',
      stack: 'Flutter • REST APIs',
      description:
          'A business-loan management app with real-time EMI schedules, secure '
          'authentication and document verification — reducing manual processing '
          'by 25% and load time by 20%.',
      tags: ['Flutter', 'Fintech', 'Security'],
      accent: Color(0xFF06B6D4),
      link: 'https://apps.apple.com/in/app/efl-clik/id6449164257',
    ),
    Project(
      name: 'Raftaarr App',
      stack: 'React Native',
      description:
          'A social-commerce app letting businesses explore products, post '
          'requirements and manage services with real-time updates. Boosted user '
          'engagement by 25%.',
      tags: ['React Native', 'Real-time', 'Commerce'],
      accent: Color(0xFFF472B6),
      link: 'https://apps.apple.com/in/app/raftaarr/id6443399745',
    ),
    Project(
      name: 'Blog App',
      stack: 'Flutter • BLoC • Supabase',
      description:
          'Clean-architecture blog app with Supabase auth/DB/storage, offline '
          'caching via Hive and connectivity-aware fetching — 40% faster loads '
          'and seamless offline access.',
      tags: ['Flutter', 'BLoC', 'Supabase', 'Hive'],
      accent: Color(0xFF22C55E),
    ),
    Project(
      name: 'Expense Tracker',
      stack: 'Flutter • SQLite',
      description:
          'A cross-platform expense tracker with local persistence and '
          'categorised transactions, improving data-retrieval speed by 20%.',
      tags: ['Flutter', 'SQLite', 'Local DB'],
      accent: Color(0xFFF59E0B),
    ),
  ];

  static const List<SkillGroup> skillGroups = [
    SkillGroup('Languages', [
      Skill('Dart', 0.95),
      Skill('Java', 0.80),
      Skill('JavaScript', 0.75),
    ]),
    SkillGroup('Frameworks', [
      Skill('Flutter', 0.95),
      Skill('React Native', 0.70),
      Skill('Node.js', 0.65),
    ]),
    SkillGroup('State & Architecture', [
      Skill('Clean Architecture', 0.90),
      Skill('BLoC', 0.88),
      Skill('MVVM', 0.85),
    ]),
    SkillGroup('Data & Tools', [
      Skill('Firebase', 0.85),
      Skill('SQLite / Hive', 0.85),
      Skill('Git & CI', 0.82),
    ]),
  ];
}

class Stat {
  final String value;
  final String label;
  const Stat(this.value, this.label);
}

class Experience {
  final String company;
  final String title;
  final String period;
  final String location;
  final List<String> points;
  const Experience({
    required this.company,
    required this.title,
    required this.period,
    required this.location,
    required this.points,
  });
}

class Project {
  final String name;
  final String stack;
  final String description;
  final List<String> tags;
  final Color accent;
  final String? link;
  const Project({
    required this.name,
    required this.stack,
    required this.description,
    required this.tags,
    required this.accent,
    this.link,
  });

  /// Human label for the store the [link] points to, or null.
  String? get store {
    if (link == null) return null;
    if (link!.contains('play.google')) return 'Play Store';
    if (link!.contains('apple.com')) return 'App Store';
    return 'Live';
  }
}

class Skill {
  final String name;
  final double level;
  const Skill(this.name, this.level);
}

class SkillGroup {
  final String title;
  final List<Skill> skills;
  const SkillGroup(this.title, this.skills);
}
