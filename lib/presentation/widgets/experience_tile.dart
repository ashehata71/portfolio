import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// One role on the timeline.
///
/// Chronology is real information here, so it is expressed structurally: a
/// rail down the left, a node per role, and the current role marked with a
/// filled node and a ring. That is the one place structure is allowed to
/// encode order on this page — the projects list is not a sequence and is not
/// numbered.
class ExperienceTile extends StatelessWidget {
  const ExperienceTile({
    super.key,
    required this.title,
    required this.company,
    required this.period,
    required this.bullets,
    this.isCurrent = false,
    this.isLast = false,
  });

  final String title;
  final String company;
  final String period;

  /// Each string renders as its own bullet.
  final List<String> bullets;

  /// Marks the role Ahmed holds now.
  final bool isCurrent;

  /// Stops the rail at the last node.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _TimelineRail(isCurrent: isCurrent, isLast: isLast),
          const SizedBox(width: AppDimens.spaceLg),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isLast ? 0 : AppDimens.spaceXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          company,
                          style: isWide
                              ? context.type.headlineSmall
                              : context.type.titleLarge,
                        ),
                      ),
                      if (isCurrent) ...<Widget>[
                        const SizedBox(width: AppDimens.spaceSm),
                        Text(
                          'CURRENT',
                          style: context.type.labelSmall?.copyWith(
                            color: tokens.signal,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppDimens.spaceXs),
                  Text(
                    '$title · $period',
                    style: context.type.labelMedium,
                  ),
                  const SizedBox(height: AppDimens.spaceMd),
                  for (final String point in bullets)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.spaceSm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10, right: 12),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: tokens.rule,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(point, style: context.type.bodyMedium),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRail extends StatelessWidget {
  const _TimelineRail({required this.isCurrent, required this.isLast});

  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return SizedBox(
      width: 14,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 6),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: isCurrent ? tokens.signal : tokens.paper,
              shape: BoxShape.circle,
              border: Border.all(
                color: isCurrent ? tokens.signal : tokens.rule,
                width: 2,
              ),
            ),
          ),
          if (!isLast)
            Expanded(
              child: Container(width: 2, color: tokens.rule),
            ),
        ],
      ),
    );
  }
}
