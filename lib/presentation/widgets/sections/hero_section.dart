import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/icon_link.dart';

/// The page's thesis: Ahmed's code is a dependency other apps import.
///
/// One left-aligned column on the page's own axis — the same axis every
/// section rule below it draws from — held to [AppDimens.heroMeasure] and set
/// at a size that fills that measure. The proof lives in the work section,
/// where the reuse diagram now sits beside the module it describes.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key, required this.onLaunch});

  final void Function(String url) onLaunch;

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  static const String _kicker = 'Senior Flutter Developer · Cairo, Egypt';
  static const String _name = 'Ahmed Yasser';
  // Hard-broken on purpose: "import" is the verb the diagram beside it draws,
  // and the two lines are set to stay two lines at every width.
  static const String _statement = 'I build the code\nother apps import.';
  static const String _summary =
      'Five-plus years shipping Flutter to production — buy-now-pay-later and '
      'financial super-apps used by hundreds of thousands of people, plus the '
      'internal SDKs their teams now build on. Clean Architecture, Melos '
      'modules, and native Android and iOS where it counts.';

  bool _play = false;

  @override
  void initState() {
    super.initState();
    // One frame after mount, so first layout has settled before the sequence
    // starts. Reduced motion is handled inside the animated widgets.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _play = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    return Padding(
      padding: EdgeInsets.only(
        top: isWide ? 112 : 56,
        bottom: isWide ? AppDimens.spaceXxl : AppDimens.spaceXl,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.heroMeasure),
          child: _HeroCopy(
            play: _play,
            isWide: isWide,
            onLaunch: widget.onLaunch,
          ),
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.play,
    required this.isWide,
    required this.onLaunch,
  });

  final bool play;
  final bool isWide;
  final void Function(String url) onLaunch;

  @override
  Widget build(BuildContext context) {
    final PortfolioTokens tokens = context.tokens;

    return StaggeredGroup(
      play: play,
      stagger: const Duration(milliseconds: 110),
      children: <Widget>[
        Text(
          _HeroSectionState._kicker.toUpperCase(),
          style: context.type.labelSmall?.copyWith(color: tokens.signal),
        ),
        const SizedBox(height: AppDimens.spaceLg),
        Text(
          _HeroSectionState._name,
          style: AppTypography.display(
            fontSize: isWide ? 32 : 26,
            fontWeight: FontWeight.w500,
            color: tokens.inkMuted,
          ),
        ),
        const SizedBox(height: AppDimens.spaceSm),
        Text(
          _HeroSectionState._statement,
          style: AppTypography.display(
            // Sized to fill the hero measure now that nothing faces it.
            fontSize: isWide ? 64 : 32,
            color: tokens.ink,
            height: 1.06,
          ),
        ),
        const SizedBox(height: AppDimens.spaceLg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppDimens.proseMeasure),
          child:
              Text(_HeroSectionState._summary, style: context.type.bodyMedium),
        ),
        const SizedBox(height: AppDimens.spaceXl),
        _HeroLinks(onLaunch: onLaunch),
      ],
    );
  }
}

class _HeroLinks extends StatelessWidget {
  const _HeroLinks({required this.onLaunch});

  final void Function(String url) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.spaceSm,
      runSpacing: AppDimens.spaceSm,
      children: <Widget>[
        IconLink(
          icon: FontAwesomeIcons.solidEnvelope,
          label: 'Email Ahmed at ahmed.fcis2016@gmail.com',
          onTap: () => onLaunch('mailto:ahmed.fcis2016@gmail.com'),
        ),
        IconLink(
          icon: FontAwesomeIcons.github,
          label: 'Ahmed on GitHub',
          onTap: () => onLaunch('https://github.com/ashehata71'),
        ),
        IconLink(
          icon: FontAwesomeIcons.linkedinIn,
          label: 'Ahmed on LinkedIn',
          onTap: () => onLaunch(
            'https://www.linkedin.com/in/ahmed-shehata-7a7a40160/',
          ),
        ),
        IconLink(
          icon: FontAwesomeIcons.whatsapp,
          label: 'Message Ahmed on WhatsApp',
          onTap: () => onLaunch('https://wa.me/201550819605'),
        ),
        IconLink(
          icon: FontAwesomeIcons.phone,
          label: 'Call Ahmed on +20 155 081 9605',
          onTap: () => onLaunch('tel:+201550819605'),
        ),
      ],
    );
  }
}
