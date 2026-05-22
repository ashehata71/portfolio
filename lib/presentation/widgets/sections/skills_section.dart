import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';
import 'package:portfolio/presentation/widgets/skill_bar.dart';

class SkillsSection extends StatelessWidget {
  final bool isVisible;
  const SkillsSection({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    // Adjusted to realistic levels — 100% across the board looks flat and unconvincing
    final skills = {
      'Flutter & Dart': 0.95,
      'BLoC / Provider': 0.90,
      'Clean Architecture': 0.90,
      'Modular Design (Melos)': 0.85,
      'Firebase': 0.80,
      'CI/CD': 0.80,
      'Kotlin (Android)': 0.70,
      'Swift (iOS)': 0.50,
    };

    final isWideScreen = MediaQuery.of(context).size.width > 768;

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
              children: firstHalf
                  .map((e) => SkillBar(name: e.key, level: e.value, isVisible: isVisible))
                  .toList(),
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: secondHalf
                  .map((e) => SkillBar(name: e.key, level: e.value, isVisible: isVisible))
                  .toList(),
            ),
          ),
        ],
      );
    } else {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills.entries
            .map((e) => SkillBar(name: e.key, level: e.value, isVisible: isVisible))
            .toList(),
      );
    }

    return SectionWrapper(title: 'Skills', child: content);
  }
}