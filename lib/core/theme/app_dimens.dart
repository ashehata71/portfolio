/// Spacing, radii and layout constants.
///
/// One breakpoint, one spacing scale, one radius family — the datasheet
/// direction lives or dies on consistent measure.
abstract final class AppDimens {
  /// The single layout breakpoint. Above: side-by-side rows and the desktop
  /// nav rail. Below: stacked columns and the drawer.
  static const double breakpoint = 768;

  /// Content is capped and centred so line length stays readable on large
  /// monitors.
  static const double maxContentWidth = 1080;

  /// Horizontal page gutter.
  static const double gutter = 24;

  /// Measure for the hero statement column. The hero runs as a single
  /// left-aligned block, so the display type is capped here rather than by a
  /// facing column.
  static const double heroMeasure = 780;

  /// Comfortable reading measure for a paragraph of body copy.
  static const double proseMeasure = 620;

  // ── Spacing scale ────────────────────────────────────────────────────────
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 16;
  static const double spaceLg = 24;
  static const double spaceXl = 40;
  static const double spaceXxl = 64;

  /// Vertical rhythm between sections.
  static const double sectionGap = 88;
  static const double sectionGapNarrow = 56;

  // ── Radii ────────────────────────────────────────────────────────────────
  static const double radiusSm = 4;
  static const double radiusMd = 10;
  static const double radiusLg = 16;

  /// Minimum interactive target, per the accessibility floor.
  static const double minTapTarget = 48;
}
