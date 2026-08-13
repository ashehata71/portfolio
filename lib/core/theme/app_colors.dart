import 'package:flutter/painting.dart';

/// Raw palette values for the portfolio.
///
/// This is the **only** file in the app allowed to hold a color literal.
/// Everything else reads semantic colors from [PortfolioTokens] via the theme.
///
/// The direction is a technical datasheet: warm neutral paper, graphite ink,
/// and a single saturated indigo used as the "signal" — routed edges, links,
/// active state. One accent, spent rarely.
abstract final class AppColors {
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
}
