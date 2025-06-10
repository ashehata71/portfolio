import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HeroSection extends StatefulWidget {
  final Function(String) onLaunch;

  const HeroSection({
    super.key,
    required this.onLaunch,
  });

  @override
  _HeroSectionState createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  static const String _title = "I build things for mobile.";
  String _displayedTitle = "";
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  void _startTypingAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_currentIndex < _title.length) {
        setState(() {
          _displayedTitle += _title[_currentIndex];
          _currentIndex++;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isWideScreen = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80.0),
      constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 100),
      child: Center(
        child: isWideScreen
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(isWideScreen),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContent(isWideScreen),
              ),
      ),
    );
  }

  List<Widget> _buildContent(bool isWideScreen) {
    return [
      Expanded(
        flex: isWideScreen ? 2 : 0,
        child: Column(
          crossAxisAlignment: isWideScreen ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hi, my name is',
              style: TextStyle(color: Color(0xFF64FFDA), fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Ahmed Yasser.',
              textAlign: isWideScreen ? TextAlign.start : TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: isWideScreen ? 60 : 40,
                    color: const Color(0xFFCCD6F6),
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_displayedTitle▌',
              textAlign: isWideScreen ? TextAlign.start : TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: isWideScreen ? 50 : 30,
                    color: const Color(0xFF8892B0),
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'I\'m a Flutter Developer with 4+ years of experience, specializing in building exceptional and high-performance mobile applications.',
              textAlign: isWideScreen ? TextAlign.start : TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF8892B0),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: isWideScreen ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.phone, color: Color(0xFF8892B0)),
                  onPressed: () => widget.onLaunch('tel:+201550819605'),
                  hoverColor: const Color(0xFF64FFDA).withOpacity(0.1),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.github, color: Color(0xFF8892B0)),
                  onPressed: () => widget.onLaunch('https://github.com/ashehata71'),
                  hoverColor: const Color(0xFF64FFDA).withOpacity(0.1),
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.linkedinIn, color: Color(0xFF8892B0)),
                  onPressed: () => widget.onLaunch('https://www.linkedin.com/in/ahmed-shehata-7a7a40160'),
                  hoverColor: const Color(0xFF64FFDA).withOpacity(0.1),
                ),
              ],
            )
          ],
        ),
      ),
    ];
  }
}
