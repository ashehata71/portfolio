import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';
import 'package:portfolio/presentation/widgets/skill_bar.dart';

class SkillsSection extends StatelessWidget {
  final bool isVisible;

  const SkillsSection({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    final skills = {
      'Flutter & Dart': 0.9,
      'BLOC/Provider/GetX': 0.9,
      'Clean Architecture': 0.9,
      'Kotlin (Android)': 0.7,
      'Swift (iOS)': 0.3,
      'Firebase': 0.8,
      'CI/CD (Jenkins/GitHub Actions)': 0.6,
    };

    return SectionWrapper(
      title: 'Skills',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.entries.map((entry) {
          return SkillBar(name: entry.key, level: entry.value, isVisible: isVisible);
        }).toList(),
      ),
    );
  }
}