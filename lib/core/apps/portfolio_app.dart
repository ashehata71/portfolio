import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/sections/about_section.dart';
import 'package:portfolio/presentation/widgets/sections/contact_section.dart';
import 'package:portfolio/presentation/widgets/sections/experience_section.dart';
import 'package:portfolio/presentation/widgets/sections/hero_section.dart';
import 'package:portfolio/presentation/widgets/sections/projects_section.dart';
import 'package:portfolio/presentation/widgets/sections/skills_section.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  // A map to hold the visibility state of each section
  final Map<String, bool> _sectionVisible = {};

  // A map to hold the GlobalKey for each section
  final Map<String, GlobalKey> _sectionKeys = {};
  final ScrollController _scrollController = ScrollController();

  final List<String> sectionNames = ['hero', 'about', 'skills', 'experience', 'projects', 'contact'];

  @override
  void initState() {
    super.initState();
    // Initialize all sections as not visible and create keys for them
    for (var sectionName in sectionNames) {
      _sectionVisible[sectionName] = false;
      _sectionKeys[sectionName] = GlobalKey();
    }

    // Trigger initial animations after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _sectionVisible['hero'] = true;
        });
      }
    });

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Logic to trigger animations on scroll
    for (var sectionName in sectionNames) {
      if (_sectionKeys[sectionName]?.currentContext != null) {
        final RenderBox box = _sectionKeys[sectionName]!.currentContext!.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        final scrollOffset = _scrollController.offset;
        final viewportHeight = _scrollController.position.viewportDimension;

        // Check if the section is within the viewport
        if (position.dy < (scrollOffset + viewportHeight) && position.dy > scrollOffset - box.size.height) {
          if (!_sectionVisible[sectionName]! && mounted) {
            // Add a slight delay for a staggered effect
            Future.delayed(const Duration(milliseconds: 200), () {
              if (mounted) {
                setState(() {
                  _sectionVisible[sectionName] = true;
                });
              }
            });
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A192F).withOpacity(0.85),
        elevation: 0,
        title: const Text('Ahmed Yasser', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.download_rounded, size: 18, color: Color(0xFF0A192F)),
              label: const Text(
                'Resume',
                style: TextStyle(
                  color: Color(0xFF0A192F),
                ),
              ),
              onPressed: () async {
                // For web, the best approach is to launch a direct URL to the resume.
                // Host your resume on a service like GitHub and provide the raw URL here.
                const String resumeUrl =
                    'https://drive.google.com/file/d/1ntxBV6yVNhYmbF5qo3VvAzPLqvcwAdwi/view?usp=sharing';

                try {
                  await launchURLByURL(resumeUrl);
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not open resume.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFFFFF),
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            _buildAnimatedSection(
              'hero',
              const HeroSection(
                onLaunch: launchURLByURL,
              ),
            ),
            _buildAnimatedSection(
              'about',
              const AboutSection(),
            ),
            _buildAnimatedSection('skills', SkillsSection(isVisible: _sectionVisible['skills'] ?? false)),
            _buildAnimatedSection(
              'experience',
              const ExperienceSection(),
            ),
            _buildAnimatedSection(
              'projects',
              const ProjectsSection(),
            ),
            _buildAnimatedSection(
              'contact',
              const ContactSection(onLaunch: launchURLByURL),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSection(String key, Widget child) {
    return AnimatedOpacity(
      opacity: _sectionVisible[key]! ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 600),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 600),
        padding: EdgeInsets.only(top: _sectionVisible[key]! ? 0 : 20),
        child: Container(key: _sectionKeys[key], child: child),
      ),
    );
  }
}

// Helper for launching URLs
Future<void> launchURLByURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
