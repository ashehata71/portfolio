import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/interactive_surface.dart';

/// Switches the page between the light and dark palettes.
///
/// Shows the theme it will switch *to*, which is the convention every visitor
/// already knows from every other site: a moon while the page is light. The
/// icon crossfades and rotates a quarter turn on change, borrowing the
/// "respond" idiom rather than introducing a new one.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key, required this.isDark, required this.onToggle});

  /// What the page is wearing right now.
  final bool isDark;

  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final String label =
        isDark ? 'Switch to the light theme' : 'Switch to the dark theme';

    return InteractiveSurface(
      onTap: onToggle,
      semanticLabel: label,
      tooltip: label,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      builder: (BuildContext context, double hover) {
        return Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.lerp(tokens.paper, tokens.signalSoft, hover),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(
              color: Color.lerp(tokens.rule, tokens.signal, hover)!,
            ),
          ),
          child: AnimatedSwitcher(
            duration: Motion.resolve(context, Motion.base),
            switchInCurve: Motion.emphasized,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: RotationTransition(
                  turns: Tween<double>(begin: 0.75, end: 1).animate(animation),
                  child: child,
                ),
              );
            },
            child: FaIcon(
              isDark ? FontAwesomeIcons.solidSun : FontAwesomeIcons.solidMoon,
              // Keyed so the switcher treats a changed icon as a new child.
              key: ValueKey<bool>(isDark),
              // Below ~17 the sun's rays read as a cog at a glance.
              size: 17,
              color: Color.lerp(tokens.inkMuted, tokens.signal, hover),
            ),
          ),
        );
      },
    );
  }
}
