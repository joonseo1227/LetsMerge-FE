import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';

class ThemeModel {
  static final lightTheme = ThemeData(
    fontFamily: 'Pretendard',
    colorScheme: ColorScheme.fromSeed(seedColor: blue60),
    useMaterial3: true,
    scaffoldBackgroundColor: grey10,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: grey10,
      toolbarHeight: 80,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: grey100,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: grey10,
      elevation: 0,
      selectedItemColor: grey100,
      unselectedItemColor: grey50,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  static final darkTheme = ThemeData();
}
