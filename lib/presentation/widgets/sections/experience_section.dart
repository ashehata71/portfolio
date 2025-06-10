import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/experience_tile.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionWrapper(
      title: 'Where I\'ve Worked',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExperienceTile(
            title: 'Flutter Developer',
            company: 'E& Egypt',
            period: 'Jun 2023 - Present',
            description:
                'Worked on E& Cash modularization using Melos; enhanced code maintainability and integrated native modules; collaborated with design and QA teams for feature delivery.',
          ),
          SizedBox(height: 24),
          ExperienceTile(
            title: 'Flutter Developer & Team Lead',
            company: 'Egypt Best Properties',
            period: 'Jun 2021 - Jun 2023',
            description: 'Developed EBP ERP app with Clean Architecture',
          ),
        ],
      ),
    );
  }
}
