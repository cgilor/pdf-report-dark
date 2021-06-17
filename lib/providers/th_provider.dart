import 'package:flutter/material.dart';

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.shade900,
  accentColor: Colors.blue,

  // Define the default font family.
  //fontFamily: 'Georgia',
);
var lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  accentColor: Colors.black,
);
late bool isDarkMode;

class ThemeChanger extends ChangeNotifier {
  ThemeData _themeData;
  ThemeChanger(this._themeData);

  get getTheme => _themeData;
  void setTheme(ThemeData theme) {
    _themeData = theme;
    notifyListeners();
  }
}
