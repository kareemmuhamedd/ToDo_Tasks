import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';

  // to save current theme in the box
  _saveThemeToBox(isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  // to fetch current theme from the box
  bool _loadThemeFromBox() {
    return _box.read<bool>(_key) ?? false;
    // i will return true if I was ''DarkTheme''
    // otherwise I will return ''LightTheme''
  }

  // this getter to control the theme in the main class
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
     // i will send for this function ---> Get.changeThemeMode()
     // the current theme for change it to the new theme
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    // after change the state of current Theme i will save the new Theme in the box again
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
