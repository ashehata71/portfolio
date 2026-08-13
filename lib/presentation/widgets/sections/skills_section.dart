import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/mono_tag.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

/// The stack, grouped exactly as the CV groups it.
///
/// This replaced a set of percentage bars. Percentages were the one piece of
/// invented data on the page — no CV claims 85% Melos — and a bar chart of
/// self-assessed skill is the most templated component in the genre. Named
/// groups of mono tags are honest and read as a manifest, which is the
/// vocabulary the rest of the page speaks.
class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key, required this.isVisible});

  final bool isVisible;

  static const Map<String, List<String>> _groups = <String, List<String>>{
    'Languages & frameworks': <String>[
      'Flutter',
      'Dart',
      'Kotlin (Android)',
      'Swift (iOS)',
    ],
    'Architecture & state': <String>[
      'Clean Architecture',
      'BLoC',
      'Provider',
      'GetX',
      'Modular design (Melos)',
    ],
    'Tools & platforms': <String>[
      'Firebase',
      'CI/CD (Fastlane)',
      'Git',
      'Crowdin',
      'OCR SDK integration',
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, List<String>>> entries =
        _groups.entries.toList(growable: false);

    return SectionWrapper(
      title: 'Stack',
      isVisible: isVisible,
      child: StaggeredGroup(
        play: isVisible,
        initialDelay: const Duration(milliseconds: 180),
        stagger: const Duration(milliseconds: 120),
        children: <Widget>[
          for (final MapEntry<String, List<String>> group in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spaceXl),
              child: _StackGroup(
                label: group.key,
                items: group.value,
                isVisible: isVisible,
              ),
            ),
        ],
      ),
    );
  }
}

class _StackGroup extends StatelessWidget {
  const _StackGroup({
    required this.label,
    required this.items,
    required this.isVisible,
  });

  final String label;
  final List<String> items;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    final Widget heading = Text(
      label.toUpperCase(),
      style: context.type.labelSmall?.copyWith(color: tokens.ink),
    );

    // Tags assemble one at a time — the same stagger idiom as everything else,
    // applied to a wrap instead of a column.
    final Widget tags = StaggeredGroup(
      play: isVisible,
      initialDelay: const Duration(milliseconds: 260),
      itemDuration: Motion.base,
      stagger: const Duration(milliseconds: 45),
      rise: 10,
      layout: (List<Widget> children) => Wrap(
        spacing: AppDimens.spaceSm,
        runSpacing: AppDimens.spaceSm,
        children: children,
      ),
      children: <Widget>[
        for (final String item in items) MonoTag(label: item),
      ],
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          heading,
          const SizedBox(height: AppDimens.spaceMd),
          tags,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 220, child: heading),
        const SizedBox(width: AppDimens.spaceLg),
        Expanded(child: tags),
      ],
    );
  }
}
