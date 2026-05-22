import 'package:flutter/material.dart';

class ExperienceTile extends StatelessWidget {
  final String title;
  final String company;
  final String period;

  /// Each string in this list renders as a separate bullet point.
  final List<String> bullets;

  const ExperienceTile({
    super.key,
    required this.title,
    required this.company,
    required this.period,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title @ $company',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontSize: 20, color: const Color(0xFFCCD6F6)),
        ),
        const SizedBox(height: 4),
        Text(
          period,
          style: const TextStyle(
            color: Color(0xFF8892B0),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),
        ...bullets.map(
              (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '▹ ',
                  style: TextStyle(
                    color: Color(0xFF64FFDA),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(
                      height: 1.6,
                      color: Color(0xFF8892B0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}