import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';

class ThemeModel {
  // 현재 테마에 따라 동적 색상 반환
  static Color background(bool isDarkMode) => isDarkMode ? grey100 : grey10;

  static Color surface(bool isDarkMode) => isDarkMode ? grey90 : white;

  static Color text(bool isDarkMode) => isDarkMode ? grey10 : grey100;

  static Color sub1(bool isDarkMode) => isDarkMode ? grey90 : grey20;

  static Color sub2(bool isDarkMode) => isDarkMode ? grey80 : grey30;

  static Color sub3(bool isDarkMode) => isDarkMode ? grey60 : grey50;

  static Color sub4(bool isDarkMode) => isDarkMode ? grey50 : grey60;

  static Color sub5(bool isDarkMode) => isDarkMode ? grey20 : grey90;

  static Color hintText(bool isDarkMode) => isDarkMode ? grey70 : grey40;

  static Color highlight(bool isDarkMode) => isDarkMode ? blue50 : blue60;

  static Color danger(bool isDarkMode) => isDarkMode ? red50 : red60;

  static final lightTheme = ThemeData(
    fontFamily: 'Pretendard',
    colorScheme: ColorScheme.fromSeed(seedColor: blue60),
    useMaterial3: true,
    scaffoldBackgroundColor: grey10,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
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
      iconTheme: IconThemeData(
        color: grey100,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: grey10,
      elevation: 0,
      selectedItemColor: grey100,
      unselectedItemColor: grey40,
      type: BottomNavigationBarType.fixed,
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

  static final darkTheme = ThemeData(
    fontFamily: 'Pretendard',
    colorScheme: ColorScheme.fromSeed(seedColor: blue50),
    useMaterial3: true,
    scaffoldBackgroundColor: grey100,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: grey100,
      toolbarHeight: 80,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: grey10,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(
        color: white,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: grey100,
      elevation: 0,
      selectedItemColor: grey10,
      unselectedItemColor: grey70,
      type: BottomNavigationBarType.fixed,
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
}
