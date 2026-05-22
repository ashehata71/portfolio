import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/presentation/widgets/sections/about_section.dart';
import 'package:portfolio/presentation/widgets/sections/certificates_section.dart';
import 'package:portfolio/presentation/widgets/sections/contact_section.dart';
import 'package:portfolio/presentation/widgets/sections/experience_section.dart';
import 'package:portfolio/presentation/widgets/sections/hero_section.dart';
import 'package:portfolio/presentation/widgets/sections/projects_section.dart';
import 'package:portfolio/presentation/widgets/sections/skills_section.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── App entry widget ───────────────────────────────────────────────────────

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmed Yasser - Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF50C878),
          secondary: Color(0xFFFF69B4),
          surface: Color(0xFF2C2C3A),
        ),
        textTheme: GoogleFonts.montagaTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const PortfolioHomePage(),
    );
  }
}

// ─── Home page ───────────────────────────────────────────────────────────────

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final Map<String, bool> _sectionVisible = {};
  final Map<String, GlobalKey> _sectionKeys = {};
  final ScrollController _scrollController = ScrollController();

  final List<String> sectionNames = [
    'hero',
    'about',
    'skills',
    'experience',
    'projects',
    'certificates',
    'contact',
  ];

  // Nav labels shown in the AppBar
  final List<Map<String, String>> _navItems = const [
    {'label': 'About',        'key': 'about'},
    {'label': 'Skills',       'key': 'skills'},
    {'label': 'Experience',   'key': 'experience'},
    {'label': 'Projects',     'key': 'projects'},
    {'label': 'Certificates', 'key': 'certificates'},
    {'label': 'Contact',      'key': 'contact'},
  ];

  @override
  void initState() {
    super.initState();
    for (final name in sectionNames) {
      _sectionVisible[name] = false;
      _sectionKeys[name] = GlobalKey();
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _sectionVisible['hero'] = true);
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    for (final name in sectionNames) {
      final ctx = _sectionKeys[name]?.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);
      final viewportHeight = _scrollController.position.viewportDimension;
      final scrollOffset = _scrollController.offset;
      final inView = position.dy < (scrollOffset + viewportHeight) &&
          position.dy > scrollOffset - box.size.height;
      if (inView && !(_sectionVisible[name]!)) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) setState(() => _sectionVisible[name] = true);
        });
      }
    }
  }

  /// Scrolls the page so the given section is visible.
  void _scrollToSection(String key) {
    final ctx = _sectionKeys[key]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F).withValues(alpha: 0.92),
        elevation: 0,
        title: const Text(
          'Ahmed Yasser',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Section nav links — only on wide screens
          if (isWide)
            ...(_navItems.map(
                  (item) => TextButton(
                onPressed: () => _scrollToSection(item['key']!),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF8892B0),
                ),
                child: Text(item['label']!),
              ),
            )),

          // Resume button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF0A192F)),
              label: const Text('Resume', style: TextStyle(color: Color(0xFF0A192F))),
              onPressed: () async {
                const resumeUrl =
                    'https://drive.google.com/file/d/1ntxBV6yVNhYmbF5qo3VvAzPLqvcwAdwi/view?usp=sharing';
                try {
                  await launchURLByURL(resumeUrl);
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open resume.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      // Hamburger drawer on narrow screens
      drawer: isWide
          ? null
          : Drawer(
        backgroundColor: const Color(0xFF0A192F),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 60),
          children: _navItems.map((item) {
            return ListTile(
              title: Text(item['label']!, style: const TextStyle(color: Color(0xFF8892B0))),
              onTap: () {
                Navigator.pop(context);
                Future.delayed(
                  const Duration(milliseconds: 300),
                      () => _scrollToSection(item['key']!),
                );
              },
            );
          }).toList(),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildAnimatedSection(
              'hero',
              HeroSection(onLaunch: launchURLByURL),
            ),
            _buildAnimatedSection('about', const AboutSection()),
            _buildAnimatedSection(
              'skills',
              SkillsSection(isVisible: _sectionVisible['skills'] ?? false),
            ),
            _buildAnimatedSection('experience', const ExperienceSection()),
            _buildAnimatedSection('projects', const ProjectsSection()),
            _buildAnimatedSection('certificates', const CertificatesSection()),
            _buildAnimatedSection(
              'contact',
              ContactSection(onLaunch: launchURLByURL),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(String key, Widget child) {
    final visible = _sectionVisible[key] ?? false;
    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 600),
        padding: EdgeInsets.only(top: visible ? 0 : 20),
        child: Container(key: _sectionKeys[key], child: child),
      ),
    );
  }
}

// ─── URL helper ──────────────────────────────────────────────────────────────

Future<void> launchURLByURL(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}