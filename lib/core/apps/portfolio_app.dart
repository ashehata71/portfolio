import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/core/theme/theme_controller.dart';
import 'package:portfolio/presentation/widgets/nav_rail.dart';
import 'package:portfolio/presentation/widgets/sections/about_section.dart';
import 'package:portfolio/presentation/widgets/sections/certificates_section.dart';
import 'package:portfolio/presentation/widgets/sections/contact_section.dart';
import 'package:portfolio/presentation/widgets/sections/experience_section.dart';
import 'package:portfolio/presentation/widgets/sections/hero_section.dart';
import 'package:portfolio/presentation/widgets/sections/projects_section.dart';
import 'package:portfolio/presentation/widgets/sections/skills_section.dart';
import 'package:portfolio/presentation/widgets/theme_toggle.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── App entry widget ───────────────────────────────────────────────────────

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key, this.themeController});

  /// Owns the light/dark choice. Optional so a test can pump the page without
  /// standing up platform storage; `main` injects one that persists.
  final ThemeController? themeController;

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  late final ThemeController _controller =
      widget.themeController ?? ThemeController(store: InMemoryThemeStore());

  /// Only a controller this widget made is a controller this widget may
  /// dispose.
  bool get _ownsController => widget.themeController == null;

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, _) => MaterialApp(
        title: 'Ahmed Yasser — Senior Flutter Developer',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: _controller.mode,
        home: PortfolioHomePage(themeController: _controller),
      ),
    );
  }
}

// ─── Home page ───────────────────────────────────────────────────────────────

/// Section identifiers. Adding a section means adding it here, to [_navItems],
/// and to the column in `build` — all three, or the nav silently breaks.
abstract final class SectionKeys {
  static const String hero = 'hero';
  static const String about = 'about';
  static const String stack = 'stack';
  static const String experience = 'experience';
  static const String work = 'work';
  static const String recognition = 'recognition';
  static const String contact = 'contact';

  static const List<String> all = <String>[
    hero,
    about,
    stack,
    experience,
    work,
    recognition,
    contact,
  ];
}

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key, required this.themeController});

  final ThemeController themeController;

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final Map<String, bool> _sectionVisible = <String, bool>{};
  final Map<String, GlobalKey> _sectionKeys = <String, GlobalKey>{};
  final ScrollController _scrollController = ScrollController();

  String _activeSection = SectionKeys.hero;

  static const List<NavItem> _navItems = <NavItem>[
    NavItem(label: 'About', sectionKey: SectionKeys.about),
    NavItem(label: 'Stack', sectionKey: SectionKeys.stack),
    NavItem(label: 'Experience', sectionKey: SectionKeys.experience),
    NavItem(label: 'Work', sectionKey: SectionKeys.work),
    NavItem(label: 'Recognition', sectionKey: SectionKeys.recognition),
    NavItem(label: 'Contact', sectionKey: SectionKeys.contact),
  ];

  @override
  void initState() {
    super.initState();
    for (final String name in SectionKeys.all) {
      _sectionVisible[name] = false;
      _sectionKeys[name] = GlobalKey();
    }
    _sectionVisible[SectionKeys.hero] = true;
    _scrollController.addListener(_onScroll);
    // Sections already inside the first viewport would otherwise sit at zero
    // opacity until the visitor happens to scroll.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScroll();
    });
  }

  /// Marks sections visible as they enter the viewport, and tracks which one
  /// the reader is on. Reveal is one-way — sections never re-hide.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    // `localToGlobal` already reports viewport-relative positions, so the
    // scroll offset never needs to be subtracted by hand.
    final double viewportHeight = _scrollController.position.viewportDimension;

    String active = _activeSection;
    final Map<String, bool> newlyVisible = <String, bool>{};

    for (final String name in SectionKeys.all) {
      final BuildContext? ctx = _sectionKeys[name]?.currentContext;
      if (ctx == null) continue;
      final RenderObject? renderObject = ctx.findRenderObject();
      if (renderObject is! RenderBox || !renderObject.hasSize) continue;

      final double top = renderObject.localToGlobal(Offset.zero).dy;
      final double height = renderObject.size.height;

      // Trigger the reveal a little before the section reaches the fold, so
      // the stagger has room to run.
      if (top < viewportHeight * 0.88 &&
          top + height > 0 &&
          !(_sectionVisible[name] ?? false)) {
        newlyVisible[name] = true;
      }
      if (top <= viewportHeight * 0.4 && top + height > viewportHeight * 0.2) {
        active = name;
      }
    }

    if (newlyVisible.isEmpty && active == _activeSection) return;
    setState(() {
      _sectionVisible.addAll(newlyVisible);
      _activeSection = active;
    });
  }

  void _scrollToSection(String key) {
    final BuildContext? ctx = _sectionKeys[key]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: Motion.resolve(context, const Duration(milliseconds: 600)),
      curve: Motion.emphasized,
      alignment: 0.05,
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool _visible(String key) => _sectionVisible[key] ?? false;

  Widget _anchored(String key, Widget child) =>
      KeyedSubtree(key: _sectionKeys[key], child: child);

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: AppDimens.spaceLg,
        title: Text(
          'Ahmed Yasser',
          style: context.type.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: tokens.ink,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: tokens.rule),
        ),
        actions: <Widget>[
          if (isWide)
            NavRail(
              items: _navItems,
              activeKey: _activeSection,
              onSelect: _scrollToSection,
            ),
          // Present at both widths: on narrow the nav hides behind the drawer,
          // but the theme is a property of the page, not of the navigation.
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimens.spaceMd,
              right: AppDimens.spaceMd,
            ),
            child: ThemeToggle(
              isDark: widget.themeController.showsDark(
                MediaQuery.platformBrightnessOf(context),
              ),
              onToggle: () => widget.themeController.toggle(
                MediaQuery.platformBrightnessOf(context),
              ),
            ),
          ),
        ],
      ),
      drawer: isWide
          ? null
          : _NavDrawer(
              items: _navItems,
              activeKey: _activeSection,
              onSelect: _scrollToSection,
            ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimens.maxContentWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.gutter,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _anchored(
                    SectionKeys.hero,
                    HeroSection(onLaunch: launchURLByURL),
                  ),
                  _anchored(
                    SectionKeys.about,
                    AboutSection(isVisible: _visible(SectionKeys.about)),
                  ),
                  _anchored(
                    SectionKeys.stack,
                    SkillsSection(isVisible: _visible(SectionKeys.stack)),
                  ),
                  _anchored(
                    SectionKeys.experience,
                    ExperienceSection(
                      isVisible: _visible(SectionKeys.experience),
                    ),
                  ),
                  _anchored(
                    SectionKeys.work,
                    ProjectsSection(isVisible: _visible(SectionKeys.work)),
                  ),
                  _anchored(
                    SectionKeys.recognition,
                    CertificatesSection(
                      isVisible: _visible(SectionKeys.recognition),
                    ),
                  ),
                  _anchored(
                    SectionKeys.contact,
                    ContactSection(
                      onLaunch: launchURLByURL,
                      isVisible: _visible(SectionKeys.contact),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXxl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDrawer extends StatelessWidget {
  const _NavDrawer({
    required this.items,
    required this.activeKey,
    required this.onSelect,
  });

  final List<NavItem> items;
  final String activeKey;
  final void Function(String sectionKey) onSelect;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXl),
          children: <Widget>[
            for (final NavItem item in items)
              ListTile(
                minTileHeight: AppDimens.minTapTarget,
                leading: Container(
                  width: 3,
                  height: 20,
                  color: item.sectionKey == activeKey
                      ? tokens.signal
                      : Colors.transparent,
                ),
                horizontalTitleGap: AppDimens.spaceMd,
                title: Text(
                  item.label.toUpperCase(),
                  style: context.type.labelMedium?.copyWith(
                    color: item.sectionKey == activeKey
                        ? tokens.signal
                        : tokens.ink,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onSelect(item.sectionKey);
                },
              ),
          ],
        ),
      ),
    );
  }
}

// ─── URL helper ──────────────────────────────────────────────────────────────

Future<void> launchURLByURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw 'Could not launch $url';
  }
}
