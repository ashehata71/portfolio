import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';

/// How a [MonoTag] is weighted.
enum MonoTagTone {
  /// Default — a recessed chip. Tech stack, platforms, tools.
  quiet,

  /// Carries the accent. Reserved for the one fact worth marking per card.
  signal,
}

/// The datasheet's unit of metadata: a mono label in a chip.
///
/// Used for tech stack, platform availability and the single accent badge on a
/// project. Kept to one component so the page's smallest type reads as one
/// system.
class MonoTag extends StatelessWidget {
  const MonoTag(
      {super.key, required this.label, this.tone = MonoTagTone.quiet});

  final String label;
  final MonoTagTone tone;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isSignal = tone == MonoTagTone.signal;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm + 2,
        vertical: AppDimens.spaceXs + 1,
      ),
      decoration: BoxDecoration(
        color: isSignal ? tokens.signalSoft : tokens.paperSunken,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: isSignal ? tokens.signal : tokens.rule),
      ),
      child: Text(
        label,
        style: context.type.labelMedium?.copyWith(
          color: isSignal ? tokens.signal : tokens.inkMuted,
          fontSize: 11.5,
        ),
      ),
    );
  }
}
