import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const SectionWrapper(
      title: 'About Me',
      child: Text(
        'Flutter Developer with a strong foundation in Clean Architecture, modular design using Melos, and native Android/iOS development. I have a history of leadership as a former team lead, where I delegated tasks and mentored junior developers. Currently, I am contributing to large-scale financial applications with a focus on performance, modularity, and cross-platform integration.',
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: Color(0xFF8892B0),
        ),
      ),
    );
  }
}
