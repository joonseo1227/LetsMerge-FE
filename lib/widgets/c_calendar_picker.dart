import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

/// [CCalendarPicker] 위젯
///
/// Parameters:
/// - [initialDate]: 달력의 초기 선택 날짜
/// - [firstDate]: 선택 가능한 첫 날짜
/// - [lastDate]: 선택 가능한 마지막 날짜
/// - [onDateChanged]: 사용자가 날짜를 선택했을 때 호출되는 콜백
class CCalendarPicker extends ConsumerWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateChanged;

  const CCalendarPicker({
    Key? key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
  }) : super(key: key);

  ThemeData _getCalendarTheme(bool isDarkMode) {
    return (isDarkMode ? ThemeModel.darkTheme : ThemeModel.lightTheme).copyWith(
      datePickerTheme: DatePickerThemeData(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.selected)
              ? ThemeModel.highlight(isDarkMode)
              : ThemeModel.surface(isDarkMode);
        }),
        dayShape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        ),
        weekdayStyle: TextStyle(
          color: ThemeModel.text(isDarkMode),
          fontWeight: FontWeight.bold,
        ),
        headerForegroundColor: ThemeModel.text(isDarkMode),
        headerBackgroundColor: ThemeModel.surface(isDarkMode),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return Theme(
      data: _getCalendarTheme(isDarkMode),
      child: CalendarDatePicker(
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        onDateChanged: onDateChanged,
      ),
    );
  }
}
