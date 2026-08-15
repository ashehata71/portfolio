import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// A certificate, in the same card family as [ProjectTile] — same radius, same
/// hairline, same hover weight — so the two read as one system.
class CertificateTile extends StatefulWidget {
  const CertificateTile({
    super.key,
    required this.title,
    required this.issuer,
    required this.img,
  });

  final String title;
  final String issuer;
  final String img;

  @override
  State<CertificateTile> createState() => _CertificateTileState();
}

class _CertificateTileState extends State<CertificateTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hover = AnimationController(
    vsync: this,
    duration: Motion.fast,
  );
  late final CurvedAnimation _eased = CurvedAnimation(
    parent: _hover,
    curve: Motion.emphasized,
  );

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
        child: _CertificateBody(
          title: widget.title,
          issuer: widget.issuer,
          img: widget.img,
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
                boxShadow: tokens.liftShadowAt(t),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _CertificateBody extends StatelessWidget {
  const _CertificateBody({
    required this.title,
    required this.issuer,
    required this.img,
  });

  final String title;
  final String issuer;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(issuer.toUpperCase(), style: context.type.labelSmall),
          const SizedBox(height: AppDimens.spaceSm),
          Text(title, style: context.type.headlineSmall),
          const SizedBox(height: AppDimens.spaceMd),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusSm),
            child: Image.asset(
              img,
              semanticLabel: '$title, $issuer',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
