import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// themeProvider를 이용해 다크모드 여부(bool)를 관리
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  // 초기값을 false로 주되, 실제 앱에서는 main.dart에서 override해줌
  return ThemeNotifier(false);
});

class ThemeNotifier extends StateNotifier<bool> {
  // 초기 생성 시 값을 받을 수 있도록 생성자 수정
  ThemeNotifier(bool initialDarkMode) : super(initialDarkMode);

  // 다크모드 상태 저장
  Future<void> setTheme(bool isDarkMode) async {
    state = isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // 다크모드 상태 토글
  Future<void> toggleTheme() async {
    final newTheme = !state;
    await setTheme(newTheme);
  }
}
