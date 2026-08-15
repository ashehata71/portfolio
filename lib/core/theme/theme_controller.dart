import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Where the visitor's theme choice is kept between visits.
///
/// An interface so the controller can be tested against a fake instead of
/// real platform storage.
abstract interface class ThemePreferenceStore {
  /// The stored choice, or null if the visitor has never overridden the OS.
  Future<ThemeMode?> read();

  Future<void> write(ThemeMode mode);
}

/// Backed by `shared_preferences`, which is `localStorage` on the web.
class SharedPreferencesThemeStore implements ThemePreferenceStore {
  const SharedPreferencesThemeStore();

  static const String _key = 'portfolio.themeMode';

  @override
  Future<ThemeMode?> read() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return switch (prefs.getString(_key)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => null,
    };
  }

  @override
  Future<void> write(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mode == ThemeMode.system) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
    }
  }
}

/// Remembers nothing. The default when no store is supplied, and what tests
/// run against.
class InMemoryThemeStore implements ThemePreferenceStore {
  InMemoryThemeStore([this._mode]);

  ThemeMode? _mode;

  @override
  Future<ThemeMode?> read() async => _mode;

  @override
  Future<void> write(ThemeMode mode) async => _mode = mode;
}

/// Owns which theme the page is wearing.
///
/// Starts on [ThemeMode.system] — the visitor's OS preference is the right
/// default and costs them nothing — and stays there until they say otherwise,
/// at which point the choice is written to [store] and survives a reload.
class ThemeController extends ChangeNotifier {
  ThemeController({required this.store});

  final ThemePreferenceStore store;

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  /// True once the visitor has overridden the OS setting.
  bool get isOverridden => _mode != ThemeMode.system;

  /// Restores a previous choice. Failure is not worth breaking a page over —
  /// the OS default is a perfectly good outcome.
  Future<void> load() async {
    try {
      final ThemeMode? stored = await store.read();
      if (stored == null || stored == _mode) return;
      _mode = stored;
      notifyListeners();
    } on Exception {
      // Keep ThemeMode.system.
    }
  }

  /// Flips to the opposite of what is on screen right now. [platform] is the
  /// OS brightness, which decides the direction while the mode is still
  /// [ThemeMode.system].
  void toggle(Brightness platform) {
    final bool showingDark = switch (_mode) {
      ThemeMode.dark => true,
      ThemeMode.light => false,
      ThemeMode.system => platform == Brightness.dark,
    };
    _set(showingDark ? ThemeMode.light : ThemeMode.dark);
  }

  void _set(ThemeMode mode) {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    // Persisting is a side effect of the choice, not a precondition for it —
    // the UI has already moved, and a storage failure must not surface as an
    // unhandled error on a page whose only state is a colour.
    unawaited(store.write(mode).catchError((Object _) {}));
  }

  /// Whether the dark theme is what the visitor is currently seeing, given the
  /// OS [platform] brightness.
  bool showsDark(Brightness platform) => switch (_mode) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system => platform == Brightness.dark,
      };
}
