import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_colors.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// Assembles the single theme the portfolio ships.
abstract final class AppTheme {
  static ThemeData build() {
    final TextTheme textTheme = AppTypography.textTheme();

    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      textTheme: textTheme,
      extensions: const <ThemeExtension<dynamic>>[PortfolioTokens.standard()],
      colorScheme: const ColorScheme.light(
        primary: AppColors.signal,
        onPrimary: AppColors.onSignal,
        secondary: AppColors.ink,
        onSecondary: AppColors.paper,
        surface: AppColors.card,
        onSurface: AppColors.ink,
        outline: AppColors.rule,
      ),
      // Material's default ink splash reads as a foreign flourish on a page
      // this quiet; interaction feedback is handled explicitly instead.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerTheme: const DividerThemeData(
        color: AppColors.rule,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.paper.withValues(alpha: 0.88),
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          side: const BorderSide(color: AppColors.rule),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        textStyle: AppTypography.mono(color: AppColors.paper, fontSize: 11),
      ),
    );
  }
}
