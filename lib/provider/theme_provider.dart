import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences에 사용되는 키 상수들
const String _prefKeyThemeModeIndex = 'themeModeIndex';
const String _prefKeyIsDarkMode = 'isDarkMode';

/// 현재 테마 상태(밝은 테마: false, 어두운 테마: true)를 관리하는 Riverpod Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier(false);
});

/// Theme 모드를 관리하는 클래스
class ThemeNotifier extends StateNotifier<bool> {
  /// 테마 모드 인덱스:
  /// 0: 기기 테마 연동, 1: 밝은 테마, 2: 어두운 테마
  int _themeModeIndex = 0;

  /// 생성자
  /// [initialDarkMode]: 초기 테마 상태(어두운 모드 여부)
  /// 초기 상태는 prefs를 불러오기 전까지 임시로 사용됩니다.
  ThemeNotifier(bool initialDarkMode) : super(initialDarkMode) {
    _loadThemeModeFromPrefs();
    // 시스템의 테마(밝기) 변경 이벤트에 대한 콜백 등록
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        _handlePlatformBrightnessChanged;
  }

  /// 시스템 테마 변경 시 호출되는 콜백
  void _handlePlatformBrightnessChanged() {
    // 기기 테마 연동 모드(인덱스 0)일 때만 업데이트 수행
    if (_themeModeIndex == 0) {
      _updateState();
    }
  }

  /// SharedPreferences에서 저장된 테마 모드 인덱스를 불러와 상태를 업데이트합니다.
  Future<void> _loadThemeModeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _themeModeIndex = prefs.getInt(_prefKeyThemeModeIndex) ?? 0;
    _updateState();
  }

  /// 테마 모드 인덱스를 변경하고, 그에 따라 상태를 업데이트하며 SharedPreferences에 저장합니다.
  Future<void> setMode(int index) async {
    _themeModeIndex = index;
    _updateState();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKeyThemeModeIndex, _themeModeIndex);
  }

  /// 현재 _themeModeIndex 값을 기반으로 다크 모드 여부를 계산합니다.
  bool _calculateIsDark() {
    switch (_themeModeIndex) {
      case 1: // 밝은 테마 선택
        return false;
      case 2: // 어두운 테마 선택
        return true;
      case 0: // 기기 테마 연동
      default:
        return SchedulerBinding
                .instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    }
  }

  /// _themeModeIndex에 따라 상태를 업데이트합니다.
  void _updateState() {
    state = _calculateIsDark();
  }

  /// 다크 모드 여부를 직접 설정하고, 해당 설정을 SharedPreferences에 저장합니다.
  /// 이때 다크 모드 여부에 따라 테마 모드 인덱스를 2(어두운 테마) 또는 1(밝은 테마)로 업데이트합니다.
  Future<void> setTheme(bool isDarkMode) async {
    state = isDarkMode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKeyIsDarkMode, isDarkMode);

    _themeModeIndex = isDarkMode ? 2 : 1;
    await prefs.setInt(_prefKeyThemeModeIndex, _themeModeIndex);
  }

  /// 현재 테마 상태를 반전시켜 토글합니다.
  Future<void> toggleTheme() async {
    await setTheme(!state);
  }

  /// 현재 테마 모드 인덱스를 반환하는 getter
  int get currentModeIndex => _themeModeIndex;

  @override
  void dispose() {
    // ThemeNotifier가 dispose될 때 시스템 테마 변경 콜백을 해제합니다.
    SchedulerBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        null;
    super.dispose();
  }
}
