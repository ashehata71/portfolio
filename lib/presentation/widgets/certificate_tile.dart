import 'package:flutter/material.dart';

class CertificateTile extends StatelessWidget {
  final String issuer;
  final String img;

  const CertificateTile({
    super.key,
    required this.issuer,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF112240),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(img),
            const SizedBox(height: 20),
            Text(
              issuer,
              style: const TextStyle(height: 1.5, color: Color(0xFF8892B0), fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
