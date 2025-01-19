import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false) {
    _loadThemePreference(); // 앱 시작 시 저장된 다크모드 상태를 불러옴
  }

  // 다크모드 상태 저장
  Future<void> setTheme(bool isDarkMode) async {
    state = isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // 다크모드 상태 불러오기
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  // 다크모드 상태 토글
  Future<void> toggleTheme() async {
    final newTheme = !state;
    await setTheme(newTheme);
  }
}
