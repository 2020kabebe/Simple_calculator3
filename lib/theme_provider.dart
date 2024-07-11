import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;
  static const String _themeKey = 'theme_mode';

  ThemeProvider(SharedPreferences prefs)
      : _themeMode = _getThemeModeFromPrefs(prefs) ?? ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _saveThemeModeToPrefs();
    notifyListeners();
  }

  void _saveThemeModeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, _themeMode.index);
  }

  static ThemeMode? _getThemeModeFromPrefs(SharedPreferences prefs) {
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      return ThemeMode.values[themeIndex];
    }
    return null;
  }

  static Future<ThemeProvider> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeProvider(prefs);
  }
}
