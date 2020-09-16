import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:check_it_off/models/themes.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;

  String currentTheme;

  ThemeNotifier(this._themeData, this.currentTheme) {
    if (currentTheme == 'system') {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool darkModeOn = brightness == Brightness.dark;
      setTheme(darkModeOn ? darkTheme : lightTheme);
      currentTheme = (darkModeOn ? 'dark' : 'light');
    } else {
      setTheme(_themeData);
    }
  }

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  String getCurrentTheme() {
    return currentTheme;
  }
}
