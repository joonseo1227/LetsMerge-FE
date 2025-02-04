import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class CDateTimePicker extends ConsumerStatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const CDateTimePicker({super.key, required this.onDateTimeSelected});

  @override
  ConsumerState<CDateTimePicker> createState() => _CDateTimePickerState();
}

class _CDateTimePickerState extends ConsumerState<CDateTimePicker> {
  DateTime? _selectedDateTime;

  DatePickerThemeData getDatePickerTheme(bool isDarkMode) {
    return DatePickerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      dayBackgroundColor: WidgetStateProperty.resolveWith(
        (states) {
          return states.contains(WidgetState.selected)
              ? ThemeModel.highlight(isDarkMode)
              : ThemeModel.surface(isDarkMode);
        },
      ),
      dayShape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      weekdayStyle: TextStyle(
        color: ThemeModel.text(isDarkMode),
        fontWeight: FontWeight.bold,
      ),
      headerForegroundColor: ThemeModel.text(isDarkMode),
      headerBackgroundColor: ThemeModel.surface(isDarkMode),
    );
  }

  TimePickerThemeData getTimePickerTheme(bool isDarkMode) {
    return TimePickerThemeData(
      backgroundColor: ThemeModel.surface(isDarkMode),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      hourMinuteColor: ThemeModel.sub1(isDarkMode),

      // 선택된 시간/분 텍스트 스타일
      hourMinuteTextStyle: WidgetStateTextStyle.resolveWith(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: ThemeModel.highlightText(isDarkMode),
              // 선택된 상태에서는 하이라이트 텍스트 색상
              fontWeight: FontWeight.bold,
            );
          }
          return TextStyle(
            color: ThemeModel.text(isDarkMode), // 기본 상태의 텍스트 색상
          );
        },
      ),

      dayPeriodShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      dayPeriodColor: ThemeModel.surface(isDarkMode),
      dayPeriodTextColor: ThemeModel.text(isDarkMode),

      dialBackgroundColor: ThemeModel.surface(isDarkMode),
      dialHandColor: ThemeModel.highlight(isDarkMode),
      dialTextColor: WidgetStateColor.resolveWith(
        (states) {
          return states.contains(WidgetState.selected)
              ? ThemeModel.highlightText(isDarkMode)
              : ThemeModel.text(isDarkMode);
        },
      ),
    );
  }

  void _pickDateTime(BuildContext context) async {
    final isDarkMode = ref.watch(themeProvider);

    final DateTime? pickedDateTime = await showOmniDateTimePicker(
      context: context,
      theme:
          (isDarkMode ? ThemeModel.darkTheme : ThemeModel.lightTheme).copyWith(
        datePickerTheme: getDatePickerTheme(isDarkMode),
        // timePickerTheme: getTimePickerTheme(isDarkMode),
      ),
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      is24HourMode: false,
      borderRadius: BorderRadius.zero,
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      actionsBuilder: (onCancel, cancelLabel, onConfirm, confirmLabel) {
        return [
          Expanded(
            child: Container(
              color: isDarkMode ? grey70 : grey80,
              child: CButton(
                style: CButtonStyle.secondary(isDarkMode),
                size: CButtonSize.extraLarge,
                label: '취소',
                onTap: onCancel,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: ThemeModel.highlight(isDarkMode),
              child: CButton(
                size: CButtonSize.extraLarge,
                label: '확인',
                onTap: onConfirm,
              ),
            ),
          )
        ];
      },
    );

    if (pickedDateTime != null) {
      setState(
        () {
          _selectedDateTime = pickedDateTime;
        },
      );
      widget.onDateTimeSelected(pickedDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return CInkWell(
      onTap: () => _pickDateTime(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeModel.surface(isDarkMode),
          border: Border(
            bottom: BorderSide(
              color: ThemeModel.sub5(isDarkMode),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.calendar_month_sharp,
              color: _selectedDateTime == null
                  ? ThemeModel.sub5(isDarkMode)
                  : ThemeModel.text(isDarkMode),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              _selectedDateTime != null
                  ? '${_selectedDateTime!.year}/${_selectedDateTime!.month.toString().padLeft(2, '0')}/${_selectedDateTime!.day.toString().padLeft(2, '0')} '
                      '${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}'
                  : '날짜 및 시각 선택',
              style: TextStyle(
                fontSize: 16,
                color: _selectedDateTime != null
                    ? ThemeModel.text(isDarkMode)
                    : ThemeModel.hintText(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
