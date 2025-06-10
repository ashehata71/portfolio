import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectTile extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tech;
  final VoidCallback? googlePlayOnPressed;
  final VoidCallback? appStoreOnPressed;

  const ProjectTile({
    super.key,
    required this.title,
    required this.description,
    required this.tech,
    this.googlePlayOnPressed,
    this.appStoreOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const FaIcon(FontAwesomeIcons.folderOpen, color: Color(0xFF64FFDA)),
                    Row(
                      children: [
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.googlePlay,
                            size: 20,
                            color: Color(0xFF8892B0),
                          ),
                          onPressed: googlePlayOnPressed,
                          hoverColor: const Color(0xFF64FFDA).withOpacity(0.1),
                        ),
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.appStore,
                            color: Color(0xFF8892B0),
                          ),
                          onPressed: appStoreOnPressed,
                          hoverColor: const Color(0xFF64FFDA).withOpacity(0.1),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 22, color: const Color(0xFFCCD6F6))),
                const SizedBox(height: 10),
                Text(description, style: const TextStyle(height: 1.5, color: Color(0xFF8892B0))),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: tech
                      .map((t) => Text(t, style: const TextStyle(color: Color(0xFF8892B0), fontSize: 12)))
                      .toList(),
                )
              ],
            )));
  }
}
