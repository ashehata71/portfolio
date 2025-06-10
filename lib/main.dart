import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/apps/portfolio_app.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ahmed Yasser - Portfolio',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A192F),
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF1E1E28),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF50C878), // Emerald Green
          secondary: Color(0xFFFF69B4),
          surface: Color(0xFF2C2C3A),
        ),
        textTheme: GoogleFonts.montagaTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white, displayColor: Colors.white),
      ),
      home: const PortfolioHomePage(),
    );
  }
}