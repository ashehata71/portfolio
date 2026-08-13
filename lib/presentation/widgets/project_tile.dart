import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/icon_link.dart';
import 'package:portfolio/presentation/widgets/mono_tag.dart';

/// A shipped product, as a spec card.
///
/// The card lifts on hover to bring its store links forward; the links
/// themselves are the interactive elements, so the card never claims to be a
/// button it isn't.
class ProjectTile extends StatefulWidget {
  const ProjectTile({
    super.key,
    required this.title,
    required this.org,
    required this.description,
    required this.tech,
    this.googlePlayOnPressed,
    this.appStoreOnPressed,
    this.badge,
    this.usedBy = const <String>[],
  });

  final String title;

  /// Who it was built for. Shown as the card's mono kicker.
  final String org;

  final String description;
  final List<String> tech;

  /// Store links. When both are null the store row is hidden.
  final VoidCallback? googlePlayOnPressed;
  final VoidCallback? appStoreOnPressed;

  /// The one accent per card, e.g. "Internal SDK".
  final String? badge;

  /// Apps that import this module. The page's central claim, stated per item.
  final List<String> usedBy;

  @override
  State<ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<ProjectTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hover = AnimationController(
    vsync: this,
    duration: Motion.fast,
  );
  late final CurvedAnimation _eased = CurvedAnimation(
    parent: _hover,
    curve: Motion.emphasized,
  );

  bool get _hasStoreLinks =>
      widget.googlePlayOnPressed != null || widget.appStoreOnPressed != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hover.duration = Motion.resolve(context, Motion.fast);
  }

  @override
  void dispose() {
    _eased.dispose();
    _hover.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return MouseRegion(
      onEnter: (_) => _hover.forward(),
      onExit: (_) => _hover.reverse(),
      child: AnimatedBuilder(
        animation: _eased,
        child: _ProjectBody(
          title: widget.title,
          org: widget.org,
          description: widget.description,
          tech: widget.tech,
          badge: widget.badge,
          usedBy: widget.usedBy,
          googlePlayOnPressed: widget.googlePlayOnPressed,
          appStoreOnPressed: widget.appStoreOnPressed,
          hasStoreLinks: _hasStoreLinks,
        ),
        builder: (BuildContext context, Widget? child) {
          final double t = _eased.value;
          return Transform.translate(
            offset: Offset(0, -6 * t),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.card,
                borderRadius: BorderRadius.circular(AppDimens.radiusMd),
                border: Border.all(
                  color: Color.lerp(tokens.rule, tokens.signal, t)!,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: tokens.ink.withValues(alpha: 0.05 + 0.08 * t),
                    blurRadius: 12 + 16 * t,
                    offset: Offset(0, 3 + 9 * t),
                  ),
                ],
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _ProjectBody extends StatelessWidget {
  const _ProjectBody({
    required this.title,
    required this.org,
    required this.description,
    required this.tech,
    required this.badge,
    required this.usedBy,
    required this.googlePlayOnPressed,
    required this.appStoreOnPressed,
    required this.hasStoreLinks,
  });

  final String title;
  final String org;
  final String description;
  final List<String> tech;
  final String? badge;
  final List<String> usedBy;
  final VoidCallback? googlePlayOnPressed;
  final VoidCallback? appStoreOnPressed;
  final bool hasStoreLinks;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child:
                      Text(org.toUpperCase(), style: context.type.labelSmall),
                ),
              ),
              // Badge and store links share the header row — the two never
              // co-occur, and keeping both out of the title row lets the title
              // use the full card width at 360px.
              if (badge != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppDimens.spaceSm),
                  child: MonoTag(label: badge!, tone: MonoTagTone.signal),
                ),
              if (hasStoreLinks) ...<Widget>[
                if (googlePlayOnPressed != null)
                  IconLink(
                    icon: FontAwesomeIcons.googlePlay,
                    label: '$title on Google Play',
                    onTap: googlePlayOnPressed!,
                    size: 16,
                  ),
                if (appStoreOnPressed != null)
                  IconLink(
                    icon: FontAwesomeIcons.appStoreIos,
                    label: '$title on the App Store',
                    onTap: appStoreOnPressed!,
                    size: 16,
                  ),
              ],
            ],
          ),
          const SizedBox(height: AppDimens.spaceSm),
          Text(title, style: context.type.headlineSmall),
          const SizedBox(height: AppDimens.spaceSm),
          Text(description, style: context.type.bodyMedium),
          if (usedBy.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppDimens.spaceMd),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimens.spaceSm + 2),
              decoration: BoxDecoration(
                color: tokens.paperSunken,
                borderRadius: BorderRadius.circular(AppDimens.radiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('IMPORTED BY', style: context.type.labelSmall),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    usedBy.join('  ·  '),
                    style: context.type.labelMedium?.copyWith(
                      color: tokens.ink,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppDimens.spaceMd),
          Wrap(
            spacing: AppDimens.spaceSm,
            runSpacing: AppDimens.spaceSm,
            children: <Widget>[
              for (final String item in tech) MonoTag(label: item),
            ],
          ),
        ],
      ),
    );
  }
}
