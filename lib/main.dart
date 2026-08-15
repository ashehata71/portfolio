import 'package:flutter/material.dart';
import 'package:portfolio/core/apps/portfolio_app.dart';
import 'package:portfolio/core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restored before the first frame so a visitor who chose dark last time
  // never sees the light theme flash past on the way in.
  final ThemeController themeController = ThemeController(
    store: const SharedPreferencesThemeStore(),
  );
  await themeController.load();

  runApp(PortfolioApp(themeController: themeController));
}
