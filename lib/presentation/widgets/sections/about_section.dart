import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key, required this.isVisible});

  final bool isVisible;

  static const String _body =
      'Mobile application developer with 5+ years of experience building '
      'exceptional, high-performance mobile applications. Strong foundation in '
      'Clean Architecture, modular design using Melos, and native Android and '
      'iOS development.';
  static const String _body2 =
      'A former team lead — I delegated work and mentored juniors — now '
      'contributing to large-scale financial and enterprise applications with '
      'a focus on performance, modularity, and cross-platform integration.';
  static const String _education =
      'B.Sc. Computer Science — Faculty of Computers and Information, '
      'Ain Shams University, Cairo';

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return SectionWrapper(
      title: 'About',
      meta: '5+ years',
      isVisible: isVisible,
      child: StaggeredGroup(
        play: isVisible,
        initialDelay: const Duration(milliseconds: 180),
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              _body,
              style: isWide ? context.type.bodyLarge : context.type.bodyMedium,
            ),
          ),
          const SizedBox(height: AppDimens.spaceMd),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(_body2, style: context.type.bodyMedium),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          // Education sits as a datasheet footnote rather than its own section
          // — it is one true line, and one line does not need a heading.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 2,
                height: 34,
                color: tokens.signal,
                margin: const EdgeInsets.only(right: AppDimens.spaceMd),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('EDUCATION', style: context.type.labelSmall),
                    const SizedBox(height: AppDimens.spaceXs),
                    Text(
                      _education,
                      style: context.type.labelMedium?.copyWith(
                        color: tokens.ink,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
