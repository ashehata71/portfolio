import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/mono_tag.dart';

/// One piece of work, given the width of the whole section.
///
/// Same card family as `ProjectTile` — `card` surface, `rule` hairline, the
/// shared radius — but it runs full width and pairs the spec copy with a
/// [diagram] sitting in a sunken well. Reserved for the item the section is
/// really arguing about; a second one would flatten the first.
///
/// Wide: copy left, diagram right. Narrow: copy stacked over a diagram well
/// that runs to the card's inner edges, because the diagram needs every pixel
/// of a 360px screen to read as routing.
class ModuleSpotlight extends StatelessWidget {
  const ModuleSpotlight({
    super.key,
    required this.title,
    required this.org,
    required this.description,
    required this.tech,
    required this.diagram,
    required this.caption,
    this.badge,
  });

  final String title;

  /// Who it was built for. The card's mono kicker.
  final String org;

  final String description;
  final List<String> tech;

  /// The evidence. Sits in the well, captioned.
  final Widget diagram;

  /// Reads the diagram in one line for anyone who skims past it.
  final String caption;

  /// The one accent per card, e.g. "Internal SDK".
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return Container(
      // Clipped so the narrow well can square its corners against the card.
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
        border: Border.all(color: tokens.rule),
        boxShadow: tokens.restShadow,
      ),
      child: isWide
          ? Padding(
              padding: const EdgeInsets.all(AppDimens.spaceLg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: _SpotlightCopy(
                      title: title,
                      org: org,
                      description: description,
                      tech: tech,
                      badge: badge,
                      isWide: true,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceLg),
                  Expanded(
                    flex: 6,
                    child: _DiagramWell(
                      padding: const EdgeInsets.all(AppDimens.spaceLg),
                      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                      caption: caption,
                      child: diagram,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(AppDimens.spaceLg),
                  child: _SpotlightCopy(
                    title: title,
                    org: org,
                    description: description,
                    tech: tech,
                    badge: badge,
                    isWide: false,
                  ),
                ),
                _DiagramWell(
                  padding: const EdgeInsets.all(AppDimens.spaceMd),
                  border: Border(top: BorderSide(color: tokens.rule)),
                  caption: caption,
                  child: diagram,
                ),
              ],
            ),
    );
  }
}

class _SpotlightCopy extends StatelessWidget {
  const _SpotlightCopy({
    required this.title,
    required this.org,
    required this.description,
    required this.tech,
    required this.badge,
    required this.isWide,
  });

  final String title;
  final String org;
  final String description;
  final List<String> tech;
  final String? badge;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: AppDimens.spaceXs + 2),
                child: Text(org.toUpperCase(), style: context.type.labelSmall),
              ),
            ),
            if (badge != null) MonoTag(label: badge!, tone: MonoTagTone.signal),
          ],
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Text(
          title,
          style:
              isWide ? context.type.headlineLarge : context.type.headlineMedium,
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Text(description, style: context.type.bodyMedium),
        const SizedBox(height: AppDimens.spaceMd),
        Wrap(
          spacing: AppDimens.spaceSm,
          runSpacing: AppDimens.spaceSm,
          children: <Widget>[
            for (final String item in tech) MonoTag(label: item),
          ],
        ),
      ],
    );
  }
}

/// The recessed field the diagram is drawn on, with its caption beneath.
class _DiagramWell extends StatelessWidget {
  const _DiagramWell({
    required this.padding,
    required this.caption,
    required this.child,
    this.borderRadius,
    this.border,
  });

  final EdgeInsets padding;
  final String caption;
  final Widget child;
  final BorderRadius? borderRadius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: tokens.paperSunken,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          child,
          const SizedBox(height: AppDimens.spaceLg),
          Text(caption, style: context.type.labelMedium),
        ],
      ),
    );
  }
}
