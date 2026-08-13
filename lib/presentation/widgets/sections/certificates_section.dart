import 'package:flutter/material.dart';
import 'package:portfolio/core/motion/motion.dart';
import 'package:portfolio/core/theme/app_dimens.dart';
import 'package:portfolio/presentation/widgets/certificate_tile.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class CertificatesSection extends StatelessWidget {
  const CertificatesSection({super.key, required this.isVisible});

  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.sizeOf(context).width > AppDimens.breakpoint;

    const CertificateTile first = CertificateTile(
      title: 'Excellence Award', // ← غيّر ده لاسم الشهادة الحقيقي
      issuer: 'Etisalat Egypt — 2024',
      img: 'asset/images/c2.jpeg',
    );
    const CertificateTile second = CertificateTile(
      title: 'Performance Recognition', // ← غيّر ده لاسم الشهادة الحقيقي
      issuer: 'Etisalat Egypt — 2023',
      img: 'asset/images/c1.jpeg',
    );

    return SectionWrapper(
      title: 'Recognition',
      isVisible: isVisible,
      child: StaggeredGroup(
        play: isVisible,
        initialDelay: const Duration(milliseconds: 180),
        stagger: const Duration(milliseconds: 120),
        layout: isWide
            ? (List<Widget> children) => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(child: children.first),
                    const SizedBox(width: AppDimens.spaceMd),
                    Expanded(child: children.last),
                  ],
                )
            : null,
        children: isWide
            ? const <Widget>[first, second]
            : const <Widget>[
                first,
                SizedBox(height: AppDimens.spaceMd),
                second,
              ],
      ),
    );
  }
}
