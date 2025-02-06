import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

///
/// [CDateTimePicker] 위젯
///
/// Parameter:
/// - [onDateTimeSelected]: 선택된 날짜 및 시간을 반환하는 콜백 함수
///
class CDateTimePicker extends ConsumerStatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const CDateTimePicker({super.key, required this.onDateTimeSelected});

  @override
  ConsumerState<CDateTimePicker> createState() => _CDateTimePickerState();
}

class _CDateTimePickerState extends ConsumerState<CDateTimePicker> {
  DateTime _selectedDate = DateTime.now();
  late int _selectedHour;
  late int _selectedMinute;
  late String _period;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  int _selectedHourIndex = 0;
  int _selectedMinuteIndex = 0;
  int _selectedPeriodIndex = 0;

  final ValueNotifier<int> _selectedHourNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _selectedMinuteNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _selectedPeriodNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    _selectedHour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    _selectedMinute = now.minute;
    _period = now.hour >= 12 ? '오후' : '오전';

    _selectedHourIndex = _selectedHour - 1;
    _selectedMinuteIndex = _selectedMinute;
    _selectedPeriodIndex = _period == '오전' ? 0 : 1;

    _hourController =
        FixedExtentScrollController(initialItem: _selectedHourIndex);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinuteIndex);
    _periodController =
        FixedExtentScrollController(initialItem: _selectedPeriodIndex);

    //초기값
    _selectedHourNotifier.value = _selectedHourIndex;
    _selectedMinuteNotifier.value = _selectedMinuteIndex;
    _selectedPeriodNotifier.value = _selectedPeriodIndex;
  }

  void _pickDateTime(BuildContext context) async {
    final isDarkMode = ref.watch(themeProvider);

    _initializeDateTime();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Theme(
                        data: (isDarkMode
                                ? ThemeModel.darkTheme
                                : ThemeModel.lightTheme)
                            .copyWith(
                          datePickerTheme: DatePickerThemeData(
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
                            headerBackgroundColor:
                                ThemeModel.surface(isDarkMode),
                          ),
                        ),
                        child: CalendarDatePicker(
                          initialDate: _selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          onDateChanged: (date) {
                            if (mounted) {
                              setState(() {
                                _selectedDate = date;
                              });
                            }
                          },
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 40,
                            color: isDarkMode ? grey80 : grey10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildPeriodPicker(),
                              _buildPicker(1, 12, _hourController,
                                  _selectedHourNotifier),
                              _buildPicker(0, 59, _minuteController,
                                  _selectedMinuteNotifier),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: isDarkMode ? grey70 : grey80,
                      child: CButton(
                        style: CButtonStyle.secondary(isDarkMode),
                        size: CButtonSize.extraLarge,
                        label: '취소',
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: ThemeModel.highlight(isDarkMode),
                      child: CButton(
                        size: CButtonSize.extraLarge,
                        label: '확인',
                        onTap: () {
                          int hour = _period == '오후' && _selectedHour != 12
                              ? _selectedHour + 12
                              : _period == '오전' && _selectedHour == 12
                                  ? 0
                                  : _selectedHour;
                          DateTime dateTime = DateTime(
                            _selectedDate.year,
                            _selectedDate.month,
                            _selectedDate.day,
                            hour,
                            _selectedMinute,
                          );
                          widget.onDateTimeSelected(dateTime);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPicker(
      int minValue,
      int maxValue,
      FixedExtentScrollController controller,
      ValueNotifier<int> selectedNotifier) {
    return ValueListenableBuilder<int>(
      valueListenable: selectedNotifier,
      builder: (context, selectedIndex, _) {
        return SizedBox(
          height: 160,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            controller: controller,
            itemExtent: 40,
            diameterRatio: 1.5,
            perspective: 0.004,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              if (mounted) {
                selectedNotifier.value = index;

                if (controller == _hourController) {
                  _selectedHour = minValue + index;
                } else if (controller == _minuteController) {
                  _selectedMinute = minValue + index;
                }
              }
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index > maxValue - minValue) return null;
                final value = minValue + index;
                final isSelected = selectedIndex == index;

                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    value.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected
                          ? ThemeModel.highlightText(ref.watch(themeProvider))
                          : ThemeModel.sub5(ref.watch(themeProvider)),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
              childCount: maxValue - minValue + 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodPicker() {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedPeriodNotifier,
      builder: (context, selectedIndex, _) {
        return SizedBox(
          height: 150,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            controller: _periodController,
            itemExtent: 40,
            diameterRatio: 1.5,
            perspective: 0.004,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              if (mounted) {
                _selectedPeriodNotifier.value = index;
                _period = index == 0 ? '오전' : '오후';
              }
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index > 1) return null;
                final period = index == 0 ? '오전' : '오후';
                final isSelected = selectedIndex == index;

                return Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 20,
                      color: isSelected
                          ? ThemeModel.highlightText(ref.watch(themeProvider))
                          : ThemeModel.sub5(ref.watch(themeProvider)),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
              childCount: 2,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    _selectedHourNotifier.dispose();
    _selectedMinuteNotifier.dispose();
    _selectedPeriodNotifier.dispose();
    super.dispose();
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
              color: ThemeModel.sub5(
                isDarkMode,
              ),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: ThemeModel.sub5(isDarkMode),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              // 월, 일, 요일(한글 약어), 기간, 시간(분은 2자리) 순서로 표시
              '${_selectedDate.month}월 ${_selectedDate.day}일 '
              '(${[
                '월',
                '화',
                '수',
                '목',
                '금',
                '토',
                '일'
              ][_selectedDate.weekday - 1]}) '
              '$_period ${_selectedHour}:${_selectedMinute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 16,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
