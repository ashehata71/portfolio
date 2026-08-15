import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Semantic design tokens, delivered through [ThemeData.extensions].
///
/// Widgets read colors from here (`context.tokens.signal`) instead of naming a
/// hex value. [AppColors] is the only place a literal exists.
@immutable
class PortfolioTokens extends ThemeExtension<PortfolioTokens> {
  const PortfolioTokens({
    required this.paper,
    required this.paperSunken,
    required this.card,
    required this.rule,
    required this.ink,
    required this.inkMuted,
    required this.signal,
    required this.signalSoft,
    required this.onSignal,
    required this.shadow,
  });

  /// The light set. Kept as the default so a widget built without a theme
  /// still renders something legible.
  const PortfolioTokens.standard()
      : paper = AppColors.paper,
        paperSunken = AppColors.paperSunken,
        card = AppColors.card,
        rule = AppColors.rule,
        ink = AppColors.ink,
        inkMuted = AppColors.inkMuted,
        signal = AppColors.signal,
        signalSoft = AppColors.signalSoft,
        onSignal = AppColors.onSignal,
        shadow = AppColors.shadow;

  /// The dark set. Same semantics, same relationships, different ground.
  const PortfolioTokens.dark()
      : paper = AppColors.darkPaper,
        paperSunken = AppColors.darkPaperSunken,
        card = AppColors.darkCard,
        rule = AppColors.darkRule,
        ink = AppColors.darkInk,
        inkMuted = AppColors.darkInkMuted,
        signal = AppColors.darkSignal,
        signalSoft = AppColors.darkSignalSoft,
        onSignal = AppColors.darkOnSignal,
        shadow = AppColors.darkShadow;

  /// Page background.
  final Color paper;

  /// Recessed fills — chips, wells, the diagram field.
  final Color paperSunken;

  /// Raised surfaces — cards and tiles.
  final Color card;

  /// Hairlines, borders, idle traces.
  final Color rule;

  /// Headings and high-emphasis text.
  final Color ink;

  /// Body copy and utility text.
  final Color inkMuted;

  /// The single accent.
  final Color signal;

  /// Tinted accent fill.
  final Color signalSoft;

  /// Foreground on top of [signal].
  final Color onSignal;

  /// What raised-surface shadows are tinted with. Never [ink] — that inverts
  /// to near-white in the dark theme and haloes every card.
  final Color shadow;

  /// Resting shadow for raised surfaces.
  List<BoxShadow> get restShadow => <BoxShadow>[
        BoxShadow(
          color: shadow.withValues(alpha: 0.05),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ];

  /// Shadow at full hover lift. Lerp between this and [restShadow].
  List<BoxShadow> get liftShadow => <BoxShadow>[
        BoxShadow(
          color: shadow.withValues(alpha: 0.13),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ];

  /// Shadow for a surface lifted [t] of the way from rest to full hover.
  /// Shared so tiles don't each re-derive the ramp.
  List<BoxShadow> liftShadowAt(double t) => <BoxShadow>[
        BoxShadow(
          color: shadow.withValues(alpha: 0.05 + 0.08 * t),
          blurRadius: 12 + 16 * t,
          offset: Offset(0, 3 + 9 * t),
        ),
      ];

  @override
  PortfolioTokens copyWith({
    Color? paper,
    Color? paperSunken,
    Color? card,
    Color? rule,
    Color? ink,
    Color? inkMuted,
    Color? signal,
    Color? signalSoft,
    Color? onSignal,
    Color? shadow,
  }) {
    return PortfolioTokens(
      paper: paper ?? this.paper,
      paperSunken: paperSunken ?? this.paperSunken,
      card: card ?? this.card,
      rule: rule ?? this.rule,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      signal: signal ?? this.signal,
      signalSoft: signalSoft ?? this.signalSoft,
      onSignal: onSignal ?? this.onSignal,
      shadow: shadow ?? this.shadow,
    );
  }

  @override
  PortfolioTokens lerp(covariant PortfolioTokens? other, double t) {
    if (other == null) return this;
    return PortfolioTokens(
      paper: Color.lerp(paper, other.paper, t)!,
      paperSunken: Color.lerp(paperSunken, other.paperSunken, t)!,
      card: Color.lerp(card, other.card, t)!,
      rule: Color.lerp(rule, other.rule, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      signal: Color.lerp(signal, other.signal, t)!,
      signalSoft: Color.lerp(signalSoft, other.signalSoft, t)!,
      onSignal: Color.lerp(onSignal, other.onSignal, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Ergonomic access to the tokens and the type scale.
extension PortfolioThemeX on BuildContext {
  /// Semantic colors for the current theme.
  PortfolioTokens get tokens =>
      Theme.of(this).extension<PortfolioTokens>() ??
      const PortfolioTokens.standard();

  /// The type scale. Display roles are Bricolage Grotesque, body roles are
  /// IBM Plex Sans, `label*` roles are IBM Plex Mono.
  TextTheme get type => Theme.of(this).textTheme;
}
