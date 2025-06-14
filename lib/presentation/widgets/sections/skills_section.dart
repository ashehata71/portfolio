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
      'BLOC/Provider/GetX': 0.85,
      'Clean Architecture': 0.9,
      'Kotlin (Android)': 0.7,
      'Swift (iOS)': 0.6,
      'Firebase': 0.8,
      'CI/CD (Jenkins/GitHub Actions)': 0.75,
    };

    bool isWideScreen = MediaQuery.of(context).size.width > 768;

    Widget content;

    if (isWideScreen) {
      final half = (skills.length / 2).ceil();
      final firstHalf = skills.entries.take(half);
      final secondHalf = skills.entries.skip(half);

      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: firstHalf.map((entry) {
                return SkillBar(name: entry.key, level: entry.value, isVisible: isVisible);
              }).toList(),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: secondHalf.map((entry) {
                return SkillBar(name: entry.key, level: entry.value, isVisible: isVisible);
              }).toList(),
            ),
          ),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.entries.map((entry) {
          return SkillBar(name: entry.key, level: entry.value, isVisible: isVisible);
        }).toList(),
      );
    }

    return SectionWrapper(
      title: 'Skills',
      child: content,
    );
  }
}