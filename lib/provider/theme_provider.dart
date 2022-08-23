import 'package:quickagrocourier/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDarkTheme = false;
  Color scaffoldColor = white;
  Color textColor = Color(0xFF0E0F19);

  void changeTheme(bool isDark) async {
    if (isDark) {
      scaffoldColor = Colors.black;
      textColor = Colors.white;
    } else {
      scaffoldColor = white;
      textColor = Color(0xFF0E0F19);
    }

    isDarkTheme = isDark;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isDarkTheme", isDark);
    notifyListeners();
  }

  void loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = (prefs.getBool("isDarkTheme") == null
        ? false
        : prefs.getBool("isDarkTheme"))!;

    changeTheme(isDarkTheme);
    notifyListeners();
  }
}
