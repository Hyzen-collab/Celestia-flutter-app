import 'package:flutter/material.dart';

// ThemeProvider manages global app state related to:
// - Theme mode (light/dark)
// - Text scaling (font size)
class ThemeProvider extends ChangeNotifier {
  /*
    Private state variables (encapsulation):
    - _themeMode controls light/dark theme
    - _textScale controls UI font scaling
  */
  ThemeMode _themeMode = ThemeMode.light;

  double _textScale = 1.0;

  /*
    Getters allow read-only access to private variables
  */
  ThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;

  /*
    Toggle between light and dark theme

    - isDark = true → Dark mode
    - isDark = false → Light mode
    - notifyListeners() updates all listening widgets
  */
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    // Notify UI to rebuild with updated theme
    notifyListeners();
  }

  /*
    Change font size based on selected option

    Possible values:
    - "Small"  → 0.8
    - "Medium" → 1.0
    - "Large"  → 1.3

    This affects global text scaling across the app
  */
  void changeFontSize(String size) {
    if (size == "Small") {
      _textScale = 0.8;
    } else if (size == "Medium") {
      _textScale = 1.0;
    } else if (size == "Large") {
      _textScale = 1.3;
    }

    // Notify UI to rebuild with updated text scale
    notifyListeners();
  }
}
