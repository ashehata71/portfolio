import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/presentation/widgets/experience_tile.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      title: 'Experience',
      meta: '2021 — present',
      isVisible: isVisible,
      child: StaggeredGroup(
        play: isVisible,
        initialDelay: const Duration(milliseconds: 180),
        stagger: const Duration(milliseconds: 130),
        children: const <Widget>[
          ExperienceTile(
            isCurrent: true,
            title: 'Flutter Developer',
            company: 'ValU',
            period: 'Aug 2025 – Present',
            bullets: <String>[
              'Contributed to the ValU customer app — implemented changes across the Marketplace, Shift, Loan, and Ultra features.',
              'Built an OCR SDK integration from scratch in the Sales Egypt app; the SDK is now adopted across all ValU applications company-wide.',
              'Integrated Crowdin for online localization and extracted the integration into a standalone SDK reusable by all apps in the organization.',
              'Built the Sales Jordan app from scratch: configured Flavors, set up the full CI/CD pipeline using Fastlane, and integrated the OCR SDK.',
            ],
          ),
          ExperienceTile(
            title: 'Flutter Developer',
            company: 'E& Egypt',
            period: 'Jun 2023 – Aug 2025',
            bullets: <String>[
              'Worked on E& Cash, a large-scale financial super-app, leading its modularization using Melos.',
              'Integrated native Android & iOS modules and improved build performance across packages.',
              'Collaborated with design and QA teams to deliver features on schedule.',
              'Contributed to a codebase shared across multiple squads with a focus on stability and maintainability.',
            ],
          ),
          ExperienceTile(
            isLast: true,
            title: 'Flutter Developer & Team Lead',
            company: 'Egypt Best Properties',
            period: 'Jun 2021 – Jun 2023',
            bullets: <String>[
              'Built the EBP ERP app from scratch for iOS and Android using Flutter and Clean Architecture.',
              'Led a team of 3 developers: delegated tasks, conducted code reviews, and mentored junior members.',
              'Integrated Firebase for real-time data, push notifications, and analytics.',
              'Managed releases on the App Store and Google Play throughout the product lifecycle.',
            ],
          ),
        ],
      ),
    );
  }
}
