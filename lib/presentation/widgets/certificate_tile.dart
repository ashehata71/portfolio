import 'package:flutter/material.dart';

class CertificateTile extends StatefulWidget {
  final String issuer;
  final String img;

  const CertificateTile({
    super.key,
    required this.issuer,
    required this.img,
  });

  @override
  State<CertificateTile> createState() => _CertificateTileState();
}

class _CertificateTileState extends State<CertificateTile> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Card(
            color: const Color(0xFF112240),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(widget.img),
                  const SizedBox(height: 20),
                  Text(
                    widget.issuer,
                    style: const TextStyle(height: 1.5, color: Color(0xFF8892B0), fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
