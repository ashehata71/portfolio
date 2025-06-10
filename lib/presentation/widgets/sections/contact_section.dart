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
            Text('What\'s Next?', style: TextStyle(color: Color(0xFF64FFDA), fontSize: 16)),
            const SizedBox(height: 16),
            Text('Get In Touch',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xFFCCD6F6))),
            const SizedBox(height: 16),
            Text(
              'Although I’m not currently looking for any new opportunities, my inbox is always open. Whether you have a question or just want to say hi, I’ll try my best to get back to you!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF8892B0)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('Say Hello', style: TextStyle(color: Color(0xFF64FFDA))),
              onPressed: () => onLaunch('mailto:ahmed.fcis2016@gmail.com'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  side: BorderSide(color: Color(0xFF64FFDA), width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            )
          ],
        ),
      ),
    );
  }
}