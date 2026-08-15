import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/apps/portfolio_app.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/core/theme/theme_controller.dart';
import 'package:portfolio/presentation/widgets/reuse_graph.dart';
import 'package:portfolio/presentation/widgets/sections/hero_section.dart';
import 'package:portfolio/presentation/widgets/sections/projects_section.dart';
import 'package:portfolio/presentation/widgets/theme_toggle.dart';

/// Pumps the page at [size], optionally with animations disabled.
Future<void> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
  bool disableAnimations = false,
  Brightness platformBrightness = Brightness.light,
  ThemeController? themeController,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: size,
        disableAnimations: disableAnimations,
        platformBrightness: platformBrightness,
      ),
      child: PortfolioApp(themeController: themeController),
    ),
  );
}

/// The brightness the page actually resolved to.
Brightness renderedBrightness(WidgetTester tester) {
  return Theme.of(tester.element(find.byType(PortfolioHomePage))).brightness;
}

/// The palette the page is actually painting with.
PortfolioTokens renderedTokens(WidgetTester tester) {
  return Theme.of(tester.element(find.byType(PortfolioHomePage)))
      .extension<PortfolioTokens>()!;
}

void main() {
  setUpAll(() {
    // Keep tests offline and deterministic; the app still fetches at runtime.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('hero', () {
    testWidgets('states the title the CV gives, not the old one', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester);
      await tester.pump();

      expect(
        find.textContaining('SENIOR FLUTTER DEVELOPER'),
        findsOneWidget,
        reason: 'the hero must carry the CV role',
      );
      expect(find.textContaining('Mobile Application Developer'), findsNothing);
    });

    testWidgets(
        'carries the copy alone — the diagram moved to the work '
        'section', (WidgetTester tester) async {
      await pumpPortfolio(tester);
      await tester.pump();

      expect(find.textContaining('I build the code'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(HeroSection),
          matching: find.byType(ReuseGraph),
        ),
        findsNothing,
        reason: 'the reuse graph now belongs to the work section',
      );
    });
  });

  group('work', () {
    testWidgets('leads with the reuse graph as the signature element', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester);
      await tester.pump();

      expect(
        find.descendant(
          of: find.byType(ProjectsSection),
          matching: find.byType(ReuseGraph),
        ),
        findsOneWidget,
      );
      expect(find.text('OCR SDK'), findsWidgets);
    });

    testWidgets('states the OCR SDK once, not twice', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester);
      await tester.pump();

      // The spotlight replaced the tile it used to duplicate. (The name still
      // appears as a tech chip on the Sales Jordan tile, which is a different
      // claim — that app consumes it.)
      expect(
        find.textContaining('Document scanning and data extraction'),
        findsOneWidget,
      );
    });
  });

  group('accessibility floor', () {
    testWidgets('every contact link in the hero is labelled', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester);
      await tester.pump();

      // The four social icons used to announce nothing at all.
      for (final String label in <String>[
        'Ahmed on GitHub',
        'Ahmed on LinkedIn',
        'Message Ahmed on WhatsApp',
        'Call Ahmed on +20 155 081 9605',
      ]) {
        expect(
          find.bySemanticsLabel(label),
          findsOneWidget,
          reason: '"$label" must be announced by a screen reader',
        );
      }
    });

    testWidgets('the reuse graph describes itself in words', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester);
      await tester.pump();

      expect(
        find.bySemanticsLabel(RegExp('Diagram: the OCR SDK')),
        findsOneWidget,
      );
    });
  });

  group('reduced motion', () {
    testWidgets('settles immediately with no frames left scheduled', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester, disableAnimations: true);
      // One frame to run the post-frame callback that starts the sequence,
      // one more to let every controller jump to its end value.
      await tester.pump();
      await tester.pump();

      expect(
        tester.binding.hasScheduledFrame,
        isFalse,
        reason: 'nothing may still be animating when motion is reduced',
      );
    });

    testWidgets('still renders the full hero content', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester, disableAnimations: true);
      await tester.pump();

      expect(find.textContaining('I build the code'), findsOneWidget);
      expect(find.byType(ReuseGraph), findsOneWidget);
    });
  });

  group('OCR SDK spotlight', () {
    testWidgets('keeps the graph subtext with the graph', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester, disableAnimations: true);
      await tester.pump();
      await tester.pump();

      expect(
        find.textContaining('Now shipping in every ValU app'),
        findsOneWidget,
      );
      expect(find.text('Built once'.toUpperCase()), findsOneWidget);
    });
  });

  group('theme', () {
    testWidgets('follows the OS when the visitor has said nothing', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester, platformBrightness: Brightness.dark);
      await tester.pump();

      expect(renderedBrightness(tester), Brightness.dark);
      expect(renderedTokens(tester).paper, AppColors.darkPaper);
    });

    testWidgets('the toggle flips the page and survives the OS setting', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester, platformBrightness: Brightness.light);
      await tester.pump();
      expect(renderedBrightness(tester), Brightness.light);

      await tester.tap(find.byType(ThemeToggle));
      await tester.pumpAndSettle();

      expect(
        renderedBrightness(tester),
        Brightness.dark,
        reason: 'the visitor overrode a light OS setting',
      );
      expect(renderedTokens(tester).signal, AppColors.darkSignal);
    });

    testWidgets('restores the choice stored from a previous visit', (
      WidgetTester tester,
    ) async {
      final ThemeController controller = ThemeController(
        store: InMemoryThemeStore(ThemeMode.dark),
      );
      addTearDown(controller.dispose);
      await controller.load();

      // The OS says light; the visitor said dark last time and wins.
      await pumpPortfolio(
        tester,
        platformBrightness: Brightness.light,
        themeController: controller,
      );
      await tester.pump();

      expect(renderedBrightness(tester), Brightness.dark);
    });

    testWidgets('the toggle is reachable and labelled at both widths', (
      WidgetTester tester,
    ) async {
      for (final Size size in <Size>[
        const Size(1440, 900),
        const Size(360, 800),
      ]) {
        await pumpPortfolio(tester, size: size, disableAnimations: true);
        await tester.pump();

        expect(
          find.byType(ThemeToggle),
          findsOneWidget,
          reason: 'the theme is a property of the page at ${size.width}px',
        );
        expect(
          find.bySemanticsLabel('Switch to the dark theme'),
          findsOneWidget,
        );
      }
    });

    testWidgets('renders the whole page in dark without overflowing', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(
        tester,
        size: const Size(360, 800),
        platformBrightness: Brightness.dark,
        disableAnimations: true,
      );
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(renderedTokens(tester).paper, AppColors.darkPaper);
    });
  });

  group('theme controller', () {
    test('starts on the OS setting and reports what it is showing', () {
      final ThemeController controller =
          ThemeController(store: InMemoryThemeStore());
      addTearDown(controller.dispose);

      expect(controller.mode, ThemeMode.system);
      expect(controller.isOverridden, isFalse);
      expect(controller.showsDark(Brightness.dark), isTrue);
      expect(controller.showsDark(Brightness.light), isFalse);
    });

    test('toggling from system flips away from the OS setting', () {
      final ThemeController controller =
          ThemeController(store: InMemoryThemeStore());
      addTearDown(controller.dispose);

      controller.toggle(Brightness.dark);

      expect(controller.mode, ThemeMode.light);
      expect(controller.isOverridden, isTrue);
    });

    test('persists the choice for the next visit', () async {
      final InMemoryThemeStore store = InMemoryThemeStore();
      final ThemeController controller = ThemeController(store: store);
      addTearDown(controller.dispose);

      controller.toggle(Brightness.light);
      await Future<void>.delayed(Duration.zero);

      expect(await store.read(), ThemeMode.dark);
    });

    test('survives a store that throws', () async {
      final ThemeController controller =
          ThemeController(store: _BrokenThemeStore());
      addTearDown(controller.dispose);

      await controller.load();

      expect(controller.mode, ThemeMode.system);
    });
  });

  group('narrow layout', () {
    testWidgets('lays out at 360px without overflowing', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(
        tester,
        size: const Size(360, 800),
        disableAnimations: true,
      );
      await tester.pump();
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('swaps the desktop nav for a drawer', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(
        tester,
        size: const Size(360, 800),
        disableAnimations: true,
      );
      await tester.pump();

      expect(find.byType(Drawer), findsNothing);
      expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    });
  });
}

/// A store whose reads fail, standing in for storage the browser has blocked.
class _BrokenThemeStore implements ThemePreferenceStore {
  @override
  Future<ThemeMode?> read() async => throw Exception('storage unavailable');

  @override
  Future<void> write(ThemeMode mode) async => throw Exception('unavailable');
}
