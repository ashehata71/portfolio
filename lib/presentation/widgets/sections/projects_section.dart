import 'package:flutter/material.dart';
import 'package:portfolio/core/apps/portfolio_app.dart';
import 'package:portfolio/presentation/widgets/project_tile.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      title: 'Things I\'ve Built',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── ValU ─────────────────────────────────────────────────────────
          ProjectTile(
            title: 'ValU Customer App',
            description:
            'Buy-now-pay-later super-app serving hundreds of thousands of users across Egypt. '
                'Contributed to the Marketplace, Shift, Loan, and Ultra features, '
                'improving UX and delivering new capabilities in a large multi-squad codebase.',
            tech: const ['Flutter', 'BLoC', 'Clean Architecture', 'Melos'],
            googlePlayOnPressed: () => launchURLByURL(
                'https://play.google.com/store/apps/details?id=com.efgh.customer'),
            appStoreOnPressed: () => launchURLByURL(
                'https://apps.apple.com/eg/app/valu/id1199345579'),
          ),
          const Divider(height: 20, color: Color(0xFF112240)),
          ProjectTile(
            title: 'OCR SDK',
            badge: 'Internal SDK',
            description:
            'Built a reusable OCR SDK from scratch for document scanning and data extraction. '
                'First integrated in the ValU Sales Egypt app, then adopted company-wide across all ValU applications.',
            tech: const ['Flutter', 'Android', 'iOS'],
          ),
          const Divider(height: 20, color: Color(0xFF112240)),
          ProjectTile(
            title: 'Crowdin Localization SDK',
            badge: 'Internal SDK',
            description:
            'Integrated Crowdin for over-the-air localization and packaged the integration as a standalone SDK, '
                'enabling all ValU apps to consume live translation updates without code changes.',
            tech: const ['Flutter', 'Crowdin', 'i18n', 'SDK Design'],
          ),
          const Divider(height: 20, color: Color(0xFF112240)),
          ProjectTile(
            title: 'Sales App — Jordan',
            badge: 'Internal',
            description:
            'Built the ValU Sales Jordan app from scratch: configured multi-flavor setup, '
                'established the full CI/CD pipeline with Fastlane, and integrated the OCR SDK for document capture.',
            tech: const ['Flutter', 'Fastlane', 'Flavors', 'CI/CD', 'OCR SDK'],
          ),
          const Divider(height: 20, color: Color(0xFF112240)),

          // ── E& Egypt ─────────────────────────────────────────────────────
          ProjectTile(
            title: 'E& Cash',
            description:
            'Large-scale financial super-app for payments, recharges, and money transfers. '
                'Led modularization using Melos and integrated native Android & iOS modules.',
            tech: const ['Flutter', 'Melos', 'Native Integration', 'BLoC'],
            googlePlayOnPressed: () => launchURLByURL(
                'https://play.google.com/store/apps/details?id=com.etisalat.flous&pcampaignid=web_share'),
            appStoreOnPressed: () => launchURLByURL(
                'https://apps.apple.com/eg/app/e-cash-%D8%A7%D9%8A-%D8%A7%D9%86%D8%AF-%D9%83%D8%A7%D8%B4/id1123428821'),
          ),
          const Divider(height: 20, color: Color(0xFF112240)),

          // ── Egypt Best Properties ─────────────────────────────────────────
          ProjectTile(
            title: 'EBP CRM',
            description:
            'Real estate CRM app for iOS and Android, built from scratch with Clean Architecture. '
                'Led a team of 3 developers through the full product lifecycle.',
            tech: const ['Flutter', 'Firebase', 'Clean Architecture', 'Provider & GetX'],
            googlePlayOnPressed: () => launchURLByURL(
                'https://play.google.com/store/apps/details?id=com.egyptbestproperties.ebp_crm&pcampaignid=web_share'),
            appStoreOnPressed: () => launchURLByURL(
                'https://apps.apple.com/eg/app/ebp-erp/id1578873482'),
          ),
          const Divider(height: 20, color: Color(0xFF112240)),

          // ── Al Tijari Bank ────────────────────────────────────────────────
          ProjectTile(
            title: 'WafaPoints',
            description:
            'Loyalty rewards app for Al Tijari Bank, available on both platforms.',
            tech: const ['Flutter', 'Clean Architecture', 'Provider'],
            googlePlayOnPressed: () => launchURLByURL(
                'https://play.google.com/store/apps/details?id=com.awb.wafapoints&pcampaignid=web_share'),
            appStoreOnPressed: () => launchURLByURL(
                'https://apps.apple.com/eg/app/wafapoints/id1611953011'),
          ),
        ],
      ),
    );
  }
}