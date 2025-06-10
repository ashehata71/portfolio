import 'package:flutter/material.dart';

class SkillBar extends StatelessWidget {
  final String name;
  final double level; // 0.0 to 1.0
  final bool isVisible;

  const SkillBar({
    super.key,
    required this.name,
    required this.level,
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(color: Color(0xFFCCD6F6))),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF233554),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    width: isVisible ? constraints.maxWidth * level : 0,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF64FFDA),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
