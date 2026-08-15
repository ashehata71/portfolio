import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// Assembles the two themes the portfolio ships.
///
/// Both come out of [_build], off a [PortfolioTokens] set — there is no
/// second copy of the widget theming to keep in sync, so the only thing that
/// differs between light and dark is the palette itself.
abstract final class AppTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        tokens: const PortfolioTokens.standard(),
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        tokens: const PortfolioTokens.dark(),
      );

  static ThemeData _build({
    required Brightness brightness,
    required PortfolioTokens tokens,
  }) {
    final TextTheme textTheme = AppTypography.textTheme(
      ink: tokens.ink,
      inkMuted: tokens.inkMuted,
    );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: tokens.paper,
      textTheme: textTheme,
      extensions: <ThemeExtension<dynamic>>[tokens],
      // Built off the Material base for this brightness so the roles nothing
      // on the page names — error, and the ink/focus colours Material derives
      // from them — stay sane without inventing literals for them here.
      colorScheme: (brightness == Brightness.light
              ? const ColorScheme.light()
              : const ColorScheme.dark())
          .copyWith(
        primary: tokens.signal,
        onPrimary: tokens.onSignal,
        secondary: tokens.ink,
        onSecondary: tokens.paper,
        surface: tokens.card,
        onSurface: tokens.ink,
        outline: tokens.rule,
      ),
      // Material's default ink splash reads as a foreign flourish on a page
      // this quiet; interaction feedback is handled explicitly instead.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerTheme: DividerThemeData(
        color: tokens.rule,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.paper.withValues(alpha: 0.88),
        surfaceTintColor: Colors.transparent,
        foregroundColor: tokens.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: tokens.card,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      cardTheme: CardThemeData(
        color: tokens.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          side: BorderSide(color: tokens.rule),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: tokens.ink,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        textStyle: AppTypography.mono(color: tokens.paper, fontSize: 11),
      ),
    );
  }
}
