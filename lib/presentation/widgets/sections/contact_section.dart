import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/interactive_surface.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

/// The datasheet's contact block: every channel spelled out in mono, plus one
/// primary action. Nothing here is hidden behind an icon.
class ContactSection extends StatelessWidget {
  const ContactSection({
    super.key,
    required this.onLaunch,
    required this.isVisible,
  });

  final void Function(String url) onLaunch;
  final bool isVisible;

  static const String _body =
      'Open to senior Flutter roles, contract work, and a good conversation '
      'about modular mobile architecture. Email is fastest.';

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return SectionWrapper(
      title: 'Get in touch',
      meta: 'Cairo, Egypt',
      isVisible: isVisible,
      child: StaggeredGroup(
        play: isVisible,
        initialDelay: const Duration(milliseconds: 180),
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Text(
              _body,
              style: isWide ? context.type.bodyLarge : context.type.bodyMedium,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXl),
          _ContactRow(
            label: 'Email',
            value: 'ahmed.fcis2016@gmail.com',
            onTap: () => onLaunch('mailto:ahmed.fcis2016@gmail.com'),
          ),
          _ContactRow(
            label: 'WhatsApp',
            value: '+20 155 081 9605',
            onTap: () => onLaunch('https://wa.me/201550819605'),
          ),
          _ContactRow(
            label: 'GitHub',
            value: 'github.com/ashehata71',
            onTap: () => onLaunch('https://github.com/ashehata71'),
          ),
          _ContactRow(
            label: 'LinkedIn',
            value: 'linkedin.com/in/ahmed-shehata',
            onTap: () => onLaunch(
              'https://www.linkedin.com/in/ahmed-shehata-7a7a40160/',
            ),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

/// One channel. The value slides right and the rule goes signal-colored on
/// hover — the same "respond" idiom the cards use, at link scale.
class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return InteractiveSurface(
      onTap: onTap,
      semanticLabel: '$label: $value',
      enforceMinTapTarget: false,
      borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      builder: (BuildContext context, double hover) {
        return Container(
          constraints: const BoxConstraints(minHeight: AppDimens.minTapTarget),
          padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isLast
                    ? Colors.transparent
                    : Color.lerp(tokens.rule, tokens.signal, hover)!,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: isWide ? 140 : 96,
                child: Text(
                  label.toUpperCase(),
                  style: context.type.labelSmall,
                ),
              ),
              Expanded(
                child: Transform.translate(
                  offset: Offset(6 * hover, 0),
                  child: Text(
                    value,
                    style: AppTypography.display(
                      fontSize: isWide ? 22 : 17,
                      fontWeight: FontWeight.w500,
                      color: Color.lerp(tokens.ink, tokens.signal, hover)!,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(6 * hover, 0),
                child: Icon(
                  Icons.arrow_outward_rounded,
                  size: 18,
                  color: Color.lerp(tokens.rule, tokens.signal, hover),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
