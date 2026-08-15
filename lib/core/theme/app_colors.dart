import 'package:flutter/painting.dart';

/// Raw palette values for the portfolio.
///
/// This is the **only** file in the app allowed to hold a color literal.
/// Everything else reads semantic colors from [PortfolioTokens] via the theme.
///
/// The direction is a technical datasheet: warm neutral paper, graphite ink,
/// and a single saturated indigo used as the "signal" — routed edges, links,
/// active state. One accent, spent rarely.
///
/// The dark set is not an inversion. It holds the same tonal *relationships* —
/// raised surfaces lighter than the page, wells darker, one accent carrying
/// every state — on a warm graphite ground, and every text pair was checked to
/// clear WCAG AA with margins comparable to the light set.
abstract final class AppColors {
  // ── Light ────────────────────────────────────────────────────────────────

  /// Page background. A warm neutral grey, deliberately not cream.
  static const Color paper = Color(0xFFE7E7E2);

  /// Inset areas that read as recessed into the page — chip fills, wells.
  static const Color paperSunken = Color(0xFFDEDED8);

  /// Raised surfaces: project cards, certificate tiles, spec blocks.
  static const Color card = Color(0xFFF5F5F2);

  /// Hairlines, dividers, idle diagram traces.
  static const Color rule = Color(0xFFC8C8C0);

  /// Headings and high-emphasis text. 14.5:1 on [paper].
  static const Color ink = Color(0xFF15151A);

  /// Body copy and utility text. 5.9:1 on [paper], 6.7:1 on [card].
  static const Color inkMuted = Color(0xFF55555F);

  /// The one accent. 6.6:1 on [paper], 7.5:1 on [card].
  static const Color signal = Color(0xFF3D2BD9);

  /// Tinted signal fill for chips and hover washes. 6.3:1 against [signal].
  static const Color signalSoft = Color(0xFFE2DEFA);

  /// Text and icons drawn on top of [signal].
  static const Color onSignal = Color(0xFFF7F6FF);

  /// Colour the raised-surface shadows are tinted with.
  static const Color shadow = Color(0xFF15151A);

  // ── Dark ─────────────────────────────────────────────────────────────────

  /// Page background. Warm graphite, deliberately not black.
  static const Color darkPaper = Color(0xFF16161A);

  /// Recessed areas — chip fills, wells, the diagram field. Darker than the
  /// page, exactly as in the light set.
  static const Color darkPaperSunken = Color(0xFF101014);

  /// Raised surfaces. Lighter than the page: light still comes from above.
  static const Color darkCard = Color(0xFF1E1E24);

  /// Hairlines, dividers, idle diagram traces.
  static const Color darkRule = Color(0xFF33333C);

  /// Headings and high-emphasis text. 15.4:1 on [darkPaper].
  static const Color darkInk = Color(0xFFEDEDE8);

  /// Body copy and utility text. 7.2:1 on [darkPaper], 6.6:1 on [darkCard].
  static const Color darkInkMuted = Color(0xFFA2A2AE);

  /// The one accent, lifted into a periwinkle so it clears AA on a dark
  /// ground — the light set's indigo sits at 1.6:1 here and is unreadable.
  /// 6.6:1 on [darkPaper], 6.0:1 on [darkCard].
  static const Color darkSignal = Color(0xFF9E8CFF);

  /// Tinted signal fill for chips and hover washes. 5.6:1 against
  /// [darkSignal].
  static const Color darkSignalSoft = Color(0xFF241F45);

  /// Text and icons drawn on top of [darkSignal] — dark, because the accent
  /// itself is now the lighter of the two. 6.8:1.
  static const Color darkOnSignal = Color(0xFF12101F);

  /// Shadows go black on dark; depth comes mostly from [darkCard] sitting
  /// lighter than [darkPaper], with the shadow only seating the edge.
  static const Color darkShadow = Color(0xFF000000);
}
