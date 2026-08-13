import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/apps/portfolio_app.dart';
import 'package:portfolio/presentation/widgets/reuse_graph.dart';

/// Pumps the page at [size], optionally with animations disabled.
Future<void> pumpPortfolio(
  WidgetTester tester, {
  Size size = const Size(1440, 900),
  bool disableAnimations = false,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size, disableAnimations: disableAnimations),
      child: const PortfolioApp(),
    ),
  );
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

    testWidgets('renders the reuse graph as the signature element', (
      WidgetTester tester,
    ) async {
      await pumpPortfolio(tester);
      await tester.pump();

      expect(find.byType(ReuseGraph), findsOneWidget);
      expect(find.text('OCR SDK'), findsWidgets);
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
