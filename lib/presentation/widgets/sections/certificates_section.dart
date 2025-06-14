import 'package:flutter/material.dart';
import 'package:portfolio/presentation/widgets/certificate_tile.dart';
import 'package:portfolio/presentation/widgets/section_wrapper.dart';

class CertificatesSection extends StatelessWidget {
  const CertificatesSection({super.key});


  @override
  Widget build(BuildContext context) {
    return const SectionWrapper(
      title: 'Certificates & Awards',
      child: Column(
        children: [
          CertificateTile(
            issuer: 'Issued by Etisalat Egypt - 2024',
            img: 'asset/images/c2.jpeg',
          ),
          SizedBox(height: 20),
          CertificateTile(
            img: 'asset/images/c1.jpeg',
            issuer: 'Issued by Etisalat Egypt - 2023',
          ),
        ],
      ),
    );
  }
}