import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';

class ThemeModel {
  // 현재 테마에 따라 동적 색상 반환
  static Color background(bool isDarkMode) => isDarkMode ? grey100 : grey10;

  static Color surface(bool isDarkMode) => isDarkMode ? grey90 : white;

  static Color text(bool isDarkMode) => isDarkMode ? grey10 : grey100;

  static Color sub1(bool isDarkMode) => isDarkMode ? grey80 : grey20;

  static Color sub2(bool isDarkMode) => isDarkMode ? grey70 : grey30;

  static Color sub3(bool isDarkMode) => isDarkMode ? grey60 : grey40;

  static Color sub4(bool isDarkMode) => isDarkMode ? grey50 : grey50;

  static Color sub5(bool isDarkMode) => isDarkMode ? grey40 : grey60;

  static Color sub6(bool isDarkMode) => isDarkMode ? grey30 : grey70;

  static Color hintText(bool isDarkMode) => isDarkMode ? grey60 : grey40;

  static Color highlight(bool isDarkMode) => isDarkMode ? blue50 : blue60;

  static Color danger(bool isDarkMode) => isDarkMode ? red50 : red60;

  // 공통 설정
  static final baseTheme = ThemeData(
    fontFamily: 'Pretendard',
    useMaterial3: true,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      toolbarHeight: 64,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
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

  // 라이트 테마
  static final lightTheme = baseTheme.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: blue60),
    scaffoldBackgroundColor: grey10,
    appBarTheme: baseTheme.appBarTheme.copyWith(
      backgroundColor: grey10,
      titleTextStyle:
          baseTheme.appBarTheme.titleTextStyle?.copyWith(color: grey100),
      iconTheme: const IconThemeData(color: grey100),
    ),
    bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
      backgroundColor: grey10,
      selectedItemColor: grey100,
      unselectedItemColor: grey40,
    ),
  );

  // 다크 테마
  static final darkTheme = baseTheme.copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: blue50),
    scaffoldBackgroundColor: grey100,
    appBarTheme: baseTheme.appBarTheme.copyWith(
      backgroundColor: grey100,
      titleTextStyle:
          baseTheme.appBarTheme.titleTextStyle?.copyWith(color: grey10),
      iconTheme: const IconThemeData(color: white),
    ),
    bottomNavigationBarTheme: baseTheme.bottomNavigationBarTheme.copyWith(
      backgroundColor: grey100,
      selectedItemColor: grey10,
      unselectedItemColor: grey70,
    ),
  );
}
