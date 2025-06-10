import 'package:flutter/material.dart';

class ExperienceTile extends StatelessWidget {
  final String title;
  final String company;
  final String period;
  final String description;

  const ExperienceTile({
    super.key,
    required this.title,
    required this.company,
    required this.period,
    required this.description,
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
          style: const TextStyle(color: Color(0xFF8892B0), fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(height: 1.5, color: Color(0xFF8892B0)),
        ),
      ],
    );
  }
}
