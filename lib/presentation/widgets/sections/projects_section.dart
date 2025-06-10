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
          ProjectTile(
            title: 'Etisalat Cash',
            description: 'Advanced e-wallet for payments, recharges, and transactions.',
            tech: const ['Flutter', 'Melos', 'Native Integration', 'Bloc'],
            googlePlayOnPressed: () {
              launchURLByURL(
                  'https://play.google.com/store/apps/details?id=com.etisalat.flous&pcampaignid=web_share');
            },
            appStoreOnPressed: () {
              launchURLByURL(
                  'https://apps.apple.com/eg/app/e-cash-%D8%A7%D9%8A-%D8%A7%D9%86%D8%AF-%D9%83%D8%A7%D8%B4/id1123428821');
            },
          ),
          const Divider(height: 20, color: Color(0xFF112240)),
          ProjectTile(
            title: 'EBP CRM',
            description: 'Real estate CRM app for both iOS and Android, built from scratch.',
            tech: const [
              'Flutter',
              'Firebase',
              'Clean Architecture',
              'Provider & GetX',
            ],
            googlePlayOnPressed: () {
              launchURLByURL(
                  'https://play.google.com/store/apps/details?id=com.egyptbestproperties.ebp_crm&pcampaignid=web_share');
            },
            appStoreOnPressed: () {
              launchURLByURL('https://apps.apple.com/eg/app/ebp-erp/id1578873482');
            },
          ),
          const Divider(height: 20, color: Color(0xFF112240)),
          ProjectTile(
            title: 'WafaPoints',
            description: 'Loyalty rewards app for Al Tijari Bank.',
            tech: const [
              'Flutter',
              'Firebase',
              'Clean Architecture',
              'Provider & GetX',
            ],
            googlePlayOnPressed: () {
              launchURLByURL(
                  'https://play.google.com/store/apps/details?id=com.awb.wafapoints&pcampaignid=web_share');
            },
            appStoreOnPressed: () {
              launchURLByURL('https://apps.apple.com/eg/app/wafapoints/id1611953011');
            },
          ),
        ],
      ),
    );
  }
}
