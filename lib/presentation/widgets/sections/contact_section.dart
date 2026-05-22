import 'package:flutter/material.dart';

class ContactSection extends StatelessWidget {
  final Function(String) onLaunch;

  const ContactSection({super.key, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            const Text(
              'What\'s Next?',
              style: TextStyle(color: Color(0xFF64FFDA), fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Get In Touch',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(color: const Color(0xFFCCD6F6)),
            ),
            const SizedBox(height: 16),
            const Text(
              'I\'m always open to new opportunities, collaborations, or just a good conversation about mobile development. '
                  'Whether you have a project in mind or want to say hi — my inbox is open!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF8892B0)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => onLaunch('mailto:ahmed.fcis2016@gmail.com'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                side: const BorderSide(color: Color(0xFF64FFDA), width: 1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Say Hello', style: TextStyle(color: Color(0xFF64FFDA))),
            ),
          ],
        ),
      ),
    );
  }
}