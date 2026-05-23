import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProjectTile extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tech;

  /// Optional store links — if both are null, store icons are hidden.
  final VoidCallback? googlePlayOnPressed;
  final VoidCallback? appStoreOnPressed;

  /// Optional badge shown next to the title, e.g. "Internal" or "SDK".
  final String? badge;

  const ProjectTile({
    super.key,
    required this.title,
    required this.description,
    required this.tech,
    this.googlePlayOnPressed,
    this.appStoreOnPressed,
    this.badge,
  });

  bool get _hasStoreLinks =>
      googlePlayOnPressed != null || appStoreOnPressed != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: folder icon + store buttons (if any) ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const FaIcon(FontAwesomeIcons.folderOpen, color: Color(0xFF64FFDA)),
                if (_hasStoreLinks)
                  Row(
                    children: [
                      if (googlePlayOnPressed != null)
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.googlePlay.data,
                            size: 20,
                            color: Color(0xFF8892B0),
                          ),
                          onPressed: googlePlayOnPressed,
                          hoverColor: const Color(0xFF64FFDA).withValues(alpha: 0.1),
                          tooltip: 'Google Play',
                        ),
                      if (appStoreOnPressed != null)
                        IconButton(
                          icon: Icon(
                            FontAwesomeIcons.appStore.data,
                            color: Color(0xFF8892B0),
                          ),
                          onPressed: appStoreOnPressed,
                          hoverColor: const Color(0xFF64FFDA).withValues(alpha: 0.1),
                          tooltip: 'App Store',
                        ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Title + optional badge ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 22, color: const Color(0xFFCCD6F6)),
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF64FFDA)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Color(0xFF64FFDA),
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 10),

            // ── Description ──
            Text(
              description,
              style: const TextStyle(height: 1.6, color: Color(0xFF8892B0)),
            ),

            const SizedBox(height: 20),

            // ── Tech stack ──
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: tech
                  .map(
                    (t) => Text(
                  t,
                  style: const TextStyle(
                    color: Color(0xFF64FFDA),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}