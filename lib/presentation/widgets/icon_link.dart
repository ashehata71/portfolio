import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/interactive_surface.dart';

/// An icon-only outbound link — phone, WhatsApp, GitHub, LinkedIn, email, the
/// store badges.
///
/// Every one carries a [label] that a screen reader announces and a tooltip a
/// sighted visitor sees, because "button" is what four of these used to say.
class IconLink extends StatelessWidget {
  const IconLink({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.size = 18,
  });

  final FaIconData icon;

  /// Announced by assistive tech and shown as the tooltip.
  final String label;

  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return InteractiveSurface(
      onTap: onTap,
      semanticLabel: label,
      tooltip: label,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      builder: (BuildContext context, double hover) {
        return Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color.lerp(tokens.card, tokens.signalSoft, hover),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(
              color: Color.lerp(tokens.rule, tokens.signal, hover)!,
            ),
          ),
          child: Transform.translate(
            offset: Offset(0, -2 * hover),
            child: FaIcon(
              icon,
              size: size,
              color: Color.lerp(tokens.inkMuted, tokens.signal, hover),
            ),
          ),
        );
      },
    );
  }
}
