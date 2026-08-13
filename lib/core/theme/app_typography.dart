import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/core/theme/app_colors.dart';

/// Three type roles, three faces.
///
/// * **Display** — Bricolage Grotesque. A machined grotesque with visible ink
///   traps; carries the personality, used only for the name, section titles
///   and the hero statement.
/// * **Body** — IBM Plex Sans. Drawn for technical documentation, holds up at
///   16px with generous leading.
/// * **Utility** — IBM Plex Mono. Dates, versions, platform tags, node labels.
///   Same family voice as the body face, so the datasheet reads as one system.
abstract final class AppTypography {
  /// Utility face. Uppercase + tracked out at call sites that need a kicker.
  static TextStyle mono({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.inkMuted,
    double letterSpacing = 0.8,
    double? height,
  }) {
    return GoogleFonts.ibmPlexMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Display face, exposed for the few places that need a bespoke size.
  static TextStyle display({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.ink,
    double? height,
  }) {
    return GoogleFonts.bricolageGrotesque(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height ?? 1.04,
      letterSpacing: -fontSize * 0.022,
    );
  }

  static TextTheme textTheme() {
    final TextTheme body = GoogleFonts.ibmPlexSansTextTheme();

    return TextTheme(
      // ── Display: Bricolage Grotesque ──────────────────────────────────────
      displayLarge: display(fontSize: 60),
      displayMedium: display(fontSize: 44),
      displaySmall: display(fontSize: 34),
      headlineLarge: display(fontSize: 30, fontWeight: FontWeight.w600),
      headlineMedium: display(fontSize: 24, fontWeight: FontWeight.w600),
      headlineSmall: display(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: display(fontSize: 18, fontWeight: FontWeight.w600),

      // ── Body: IBM Plex Sans ───────────────────────────────────────────────
      titleMedium: body.titleMedium?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      titleSmall: body.titleSmall?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
      bodyLarge: body.bodyLarge?.copyWith(
        fontSize: 17,
        height: 1.6,
        color: AppColors.inkMuted,
      ),
      bodyMedium: body.bodyMedium?.copyWith(
        fontSize: 16,
        height: 1.6,
        color: AppColors.inkMuted,
      ),
      bodySmall: body.bodySmall?.copyWith(
        fontSize: 16,
        height: 1.5,
        color: AppColors.inkMuted,
      ),

      // ── Utility: IBM Plex Mono ────────────────────────────────────────────
      labelLarge: mono(fontSize: 13, color: AppColors.ink),
      labelMedium: mono(fontSize: 12),
      labelSmall: mono(fontSize: 11, letterSpacing: 1.1),
    );
  }
}
