import 'package:flutter/material.dart';
import 'package:portfolio/core/apps/portfolio_app.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/presentation/widgets/module_spotlight.dart';
import 'package:portfolio/presentation/widgets/project_tile.dart';
import 'package:portfolio/presentation/widgets/reuse_graph.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

/// Shipped work. Deliberately unnumbered — this is an index, not a sequence,
/// so nothing here implies an order the reader has to follow.
///
/// The OCR SDK leads as a [ModuleSpotlight] rather than as one tile among
/// seven: it is the only item whose claim is *reuse*, and the [ReuseGraph]
/// is the proof. It routes when the section scrolls into view, so the
/// diagram animates where the reader is actually looking.
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key, required this.isVisible});

  final bool isVisible;

  static const String _ocrCaption =
      'Built from scratch in one app. Now shipping in every ValU app.';

  List<Widget> _tiles() => <Widget>[
        ProjectTile(
          title: 'ValU Customer App',
          org: 'ValU',
          description:
              'Buy-now-pay-later super-app serving hundreds of thousands of users '
              'across Egypt. Contributed to the Marketplace, Shift, Loan, and Ultra '
              'features in a large multi-squad codebase.',
          tech: const <String>[
            'Flutter',
            'BLoC',
            'Clean Architecture',
            'Melos'
          ],
          googlePlayOnPressed: () => launchURLByURL(
            'https://play.google.com/store/apps/details?id=com.efgh.customer',
          ),
          appStoreOnPressed: () =>
              launchURLByURL('https://apps.apple.com/eg/app/valu/id1199345579'),
        ),
        const ProjectTile(
          title: 'Crowdin Localization SDK',
          org: 'ValU',
          badge: 'Internal SDK',
          description:
              'Over-the-air localization, packaged as a standalone SDK so every '
              'ValU app can consume live translation updates without a code change.',
          tech: <String>['Flutter', 'Crowdin', 'i18n', 'SDK design'],
          usedBy: <String>['Every ValU app'],
        ),
        const ProjectTile(
          title: 'Sales App — Jordan',
          org: 'ValU',
          badge: 'Internal',
          description:
              'Built from scratch: multi-flavor setup, the full CI/CD pipeline with '
              'Fastlane, and the OCR SDK wired in for document capture.',
          tech: <String>['Flutter', 'Fastlane', 'Flavors', 'CI/CD', 'OCR SDK'],
        ),
        ProjectTile(
          title: 'E& Cash',
          org: 'E& Egypt',
          description:
              'Large-scale financial super-app for payments, recharges, and money '
              'transfers. Led its modularization with Melos and integrated native '
              'Android and iOS modules.',
          tech: const <String>[
            'Flutter',
            'Melos',
            'Native integration',
            'BLoC',
          ],
          googlePlayOnPressed: () => launchURLByURL(
            'https://play.google.com/store/apps/details?id=com.etisalat.flous&pcampaignid=web_share',
          ),
          appStoreOnPressed: () => launchURLByURL(
            'https://apps.apple.com/eg/app/e-cash-%D8%A7%D9%8A-%D8%A7%D9%86%D8%AF-%D9%83%D8%A7%D8%B4/id1123428821',
          ),
        ),
        ProjectTile(
          title: 'EBP CRM',
          org: 'Egypt Best Properties',
          description:
              'Real estate CRM for iOS and Android, built from scratch with Clean '
              'Architecture. Led a team of 3 developers through the full product '
              'lifecycle.',
          tech: const <String>[
            'Flutter',
            'Firebase',
            'Clean Architecture',
            'Provider & GetX',
          ],
          googlePlayOnPressed: () => launchURLByURL(
            'https://play.google.com/store/apps/details?id=com.egyptbestproperties.ebp_crm&pcampaignid=web_share',
          ),
          appStoreOnPressed: () => launchURLByURL(
              'https://apps.apple.com/eg/app/ebp-erp/id1578873482'),
        ),
        ProjectTile(
          title: 'WafaPoints',
          org: 'Al Tijari Bank',
          description:
              'Loyalty rewards app for Al Tijari Bank, shipped to both stores.',
          tech: const <String>['Flutter', 'Clean Architecture', 'Provider'],
          googlePlayOnPressed: () => launchURLByURL(
            'https://play.google.com/store/apps/details?id=com.awb.wafapoints&pcampaignid=web_share',
          ),
          appStoreOnPressed: () => launchURLByURL(
              'https://apps.apple.com/eg/app/wafapoints/id1611953011'),
        ),
      ];

  /// The section's lead item: the module, and the apps that import it.
  Widget _spotlight() => ModuleSpotlight(
        title: 'OCR SDK',
        org: 'ValU',
        badge: 'Internal SDK',
        description:
            'Document scanning and data extraction, built from scratch. First '
            'integrated in the Sales Egypt app, then adopted company-wide '
            'across all ValU applications.',
        tech: const <String>['Flutter', 'Android', 'iOS'],
        caption: _ocrCaption,
        diagram: ReuseGraph(
          play: isVisible,
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
      );

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;
    final List<Widget> tiles = _tiles();

    // The spotlight lands first; the grid follows it in.
    final Widget lead = StaggeredGroup(
      play: isVisible,
      initialDelay: const Duration(milliseconds: 120),
      children: <Widget>[_spotlight()],
    );

    if (!isWide) {
      return SectionWrapper(
        title: 'Selected work',
        meta: '7 shipped',
        isVisible: isVisible,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            lead,
            const SizedBox(height: AppDimens.spaceLg),
            StaggeredGroup(
              play: isVisible,
              initialDelay: const Duration(milliseconds: 300),
              stagger: const Duration(milliseconds: 100),
              children: <Widget>[
                for (int i = 0; i < tiles.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i == tiles.length - 1 ? 0 : AppDimens.spaceMd,
                    ),
                    child: tiles[i],
                  ),
              ],
            ),
          ],
        ),
      );
    }

    // Two columns on wide, alternating, so the section reads as an index
    // rather than a scroll.
    final List<Widget> left = <Widget>[];
    final List<Widget> right = <Widget>[];
    for (int i = 0; i < tiles.length; i++) {
      (i.isEven ? left : right).add(
        Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spaceMd),
          child: tiles[i],
        ),
      );
    }

    return SectionWrapper(
      title: 'Selected work',
      meta: '7 shipped',
      isVisible: isVisible,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          lead,
          const SizedBox(height: AppDimens.spaceXl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: StaggeredGroup(
                  play: isVisible,
                  initialDelay: const Duration(milliseconds: 300),
                  stagger: const Duration(milliseconds: 100),
                  children: left,
                ),
              ),
              const SizedBox(width: AppDimens.spaceMd),
              Expanded(
                child: StaggeredGroup(
                  play: isVisible,
                  initialDelay: const Duration(milliseconds: 350),
                  stagger: const Duration(milliseconds: 100),
                  children: right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
