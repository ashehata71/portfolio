import 'package:flutter/material.dart';

class SectionWrapper extends StatelessWidget {
  final String title;
  final Widget child;

  const SectionWrapper({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 24, color: const Color(0xFFCCD6F6)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  height: 1,
                  color: const Color(0xFF233554),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          child,
        ],
      ),
    );
  }
}
