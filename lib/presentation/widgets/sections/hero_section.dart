import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/core/theme/app_typography.dart';
import 'package:portfolio/core/theme/portfolio_tokens.dart';
import 'package:portfolio/presentation/widgets/icon_link.dart';
import 'package:portfolio/presentation/widgets/reuse_graph.dart';

/// The page's thesis: Ahmed's code is a dependency other apps import.
///
/// The left column states it; the [ReuseGraph] on the right proves it by
/// routing itself outward on load. Both start on the first frame after mount,
/// so the copy and the diagram arrive on one rhythm.
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
  static const String _graphCaption =
      'Built from scratch in one app. Now shipping in every ValU app.';

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

    final Widget copy = _HeroCopy(
      play: _play,
      isWide: isWide,
      onLaunch: widget.onLaunch,
    );
    final Widget graph = _HeroGraph(play: _play, caption: _graphCaption);

    return Padding(
      padding: EdgeInsets.only(
        top: isWide ? 96 : 56,
        bottom: isWide ? AppDimens.spaceXxl : AppDimens.spaceXl,
      ),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 6, child: copy),
                const SizedBox(width: AppDimens.spaceXxl),
                Expanded(flex: 5, child: graph),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                copy,
                const SizedBox(height: AppDimens.spaceXxl),
                graph,
              ],
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
            fontSize: isWide ? 54 : 32,
            color: tokens.ink,
            height: 1.06,
          ),
        ),
        const SizedBox(height: AppDimens.spaceLg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
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
            'https://www.linkedin.com/in/ahmed-yasser-7a7a40160/',
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

class _HeroGraph extends StatelessWidget {
  const _HeroGraph({required this.play, required this.caption});

  final bool play;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ReuseGraph(
          play: play,
          source: 'OCR SDK',
          sourceKicker: 'Built once',
          consumers: const <String>[
            'ValU Customer',
            'Sales Egypt',
            'Sales Jordan',
            'Every ValU app',
          ],
          description:
              'Diagram: the OCR SDK Ahmed built from scratch in the ValU Sales '
              'Egypt app is now imported by the ValU Customer app, Sales '
              'Egypt, Sales Jordan, and every other ValU application.',
        ),
        const SizedBox(height: AppDimens.spaceLg),
        Text(caption, style: context.type.labelMedium),
      ],
    );
  }
}
