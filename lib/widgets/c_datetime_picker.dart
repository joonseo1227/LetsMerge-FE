import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_calendar_picker.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

///
/// [CDateTimePicker] 위젯
///
/// Parameter:
/// - [onDateTimeSelected]: 선택된 날짜 및 시간을 반환하는 콜백 함수
/// - [error]: 에러 상태를 표시할지 여부 (기본값 false)
/// - [errorText]: 에러 상태일 때 표시할 텍스트 (optional)
///
class CDateTimePicker extends ConsumerStatefulWidget {
  final Function(DateTime) onDateTimeSelected;
  final bool error;
  final String? errorText;

  const CDateTimePicker({
    super.key,
    required this.onDateTimeSelected,
    this.error = false,
    this.errorText,
  });

  @override
  ConsumerState<CDateTimePicker> createState() => _CDateTimePickerState();
}

class _CDateTimePickerState extends ConsumerState<CDateTimePicker> {
  static const List<String> _weekdays = ['월', '화', '수', '목', '금', '토', '일'];
  static final DateTime _firstDate = DateTime.now();
  static final DateTime _lastDate = DateTime(
    _firstDate.year,
    _firstDate.month + 1,
    _firstDate.day,
  );

  late final ValueNotifier<int> _selectedHourNotifier;
  late final ValueNotifier<int> _selectedMinuteNotifier;
  late final ValueNotifier<int> _selectedPeriodNotifier;

  bool _hasSelected = false;

  late DateTime _selectedDate;
  late int _selectedHour;
  late int _selectedMinute;
  late String _period;

  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;

  @override
  void initState() {
    super.initState();
    _initializeNotifiers();
    _initializeDateTime();
    _initializeControllers();
  }

  void _initializeNotifiers() {
    _selectedHourNotifier = ValueNotifier<int>(0);
    _selectedMinuteNotifier = ValueNotifier<int>(0);
    _selectedPeriodNotifier = ValueNotifier<int>(0);
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    _selectedDate = now;
    _selectedHour = _convert24To12Hour(now.hour);
    _selectedMinute = now.minute;
    _period = now.hour >= 12 ? '오후' : '오전';
  }

  void _initializeControllers() {
    // 시간 선택기(시)의 인덱스를 12시가 최상단(인덱스 0)에 오도록 설정
    int initialHourIndex;
    if (_selectedHour == 12) {
      initialHourIndex = 0;
    } else {
      // 1시부터 11시는 인덱스가 그대로 1~11
      initialHourIndex = _selectedHour;
    }
    _hourController =
        FixedExtentScrollController(initialItem: initialHourIndex);
    _minuteController =
        FixedExtentScrollController(initialItem: _selectedMinute);
    _periodController =
        FixedExtentScrollController(initialItem: _period == '오전' ? 0 : 1);

    _selectedHourNotifier.value = initialHourIndex;
    _selectedMinuteNotifier.value = _selectedMinute;
    _selectedPeriodNotifier.value = _period == '오전' ? 0 : 1;
  }

  int _convert24To12Hour(int hour) {
    return hour % 12 == 0 ? 12 : hour % 12;
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final isDarkMode = ref.watch(themeProvider);

    _initializeDateTime();
    _initializeControllers();

    await showDialog(
      context: context,
      builder: (context) => _buildDialog(context, isDarkMode),
    );
  }

  Widget _buildDialog(BuildContext context, bool isDarkMode) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildCalendarPicker(isDarkMode),
                  _buildTimePicker(isDarkMode),
                ],
              ),
            ),
          ),
          _buildActionButtons(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildCalendarPicker(bool isDarkMode) {
    return CCalendarPicker(
      initialDate: _selectedDate,
      firstDate: _firstDate,
      lastDate: _lastDate,
      onDateChanged: (date) {
        if (mounted) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
    );
  }

  Widget _buildTimePicker(bool isDarkMode) {
    return Stack(
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
            // 시간 선택기의 경우 1~12 대신 12, 1, 2, ... 11 순으로 표시됨
            _buildNumberPicker(1, 12, _hourController, _selectedHourNotifier),
            _buildNumberPicker(
                0, 59, _minuteController, _selectedMinuteNotifier),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberPicker(
    int minValue,
    int maxValue,
    FixedExtentScrollController controller,
    ValueNotifier<int> selectedNotifier,
  ) {
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
            onSelectedItemChanged: (index) =>
                _handleNumberSelection(index, controller, selectedNotifier),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => _buildNumberPickerItem(
                  index, selectedIndex, minValue, maxValue),
              childCount: maxValue - minValue + 1,
            ),
          ),
        );
      },
    );
  }

// 선택한 숫자(시, 분)에 대해 햅틱 피드백 후 값 업데이트
  void _handleNumberSelection(
    int index,
    FixedExtentScrollController controller,
    ValueNotifier<int> selectedNotifier,
  ) {
    if (!mounted) return;

    HapticFeedback.lightImpact();
    selectedNotifier.value = index;

    if (controller == _hourController) {
      // 시간 선택기의 경우, 인덱스 0이면 12시, 그 외에는 인덱스 값을 그대로 시간으로 사용
      if (index == 0) {
        _selectedHour = 12;
      } else {
        _selectedHour = index;
      }
    } else if (controller == _minuteController) {
      _selectedMinute = index;
    }
  }

// 시간 선택기 아이템 빌더
  Widget? _buildNumberPickerItem(
    int index,
    int selectedIndex,
    int minValue,
    int maxValue,
  ) {
    if (index < 0 || index > maxValue - minValue) return null;

    int value;
    // 시간 선택기의 경우 (minValue 1, maxValue 12) 12시를 첫 번째 아이템으로 표시
    if (minValue == 1 && maxValue == 12) {
      value = index == 0 ? 12 : index;
    } else {
      value = minValue + index;
    }

    final isSelected = selectedIndex == index;

    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(
        value.toString().padLeft(2, '0'),
        style: _getPickerTextStyle(isSelected),
      ),
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
            onSelectedItemChanged: _handlePeriodSelection,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) =>
                  _buildPeriodPickerItem(index, selectedIndex),
              childCount: 2,
            ),
          ),
        );
      },
    );
  }

  void _handlePeriodSelection(int index) {
    if (!mounted) return;

    HapticFeedback.lightImpact();
    _selectedPeriodNotifier.value = index;
    _period = index == 0 ? '오전' : '오후';
  }

  Widget? _buildPeriodPickerItem(int index, int selectedIndex) {
    if (index < 0 || index > 1) return null;

    final period = index == 0 ? '오전' : '오후';
    final isSelected = selectedIndex == index;

    return Container(
      height: 40,
      alignment: Alignment.center,
      child: Text(period, style: _getPickerTextStyle(isSelected)),
    );
  }

  TextStyle _getPickerTextStyle(bool isSelected) {
    final isDarkMode = ref.watch(themeProvider);
    return TextStyle(
      fontSize: 20,
      color: isSelected
          ? ThemeModel.highlightText(isDarkMode)
          : ThemeModel.sub5(isDarkMode),
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
  }

  Widget _buildActionButtons(BuildContext context, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Container(
            color: isDarkMode ? grey70 : grey80,
            child: CButton(
              style: CButtonStyle.secondary(isDarkMode),
              size: CButtonSize.extraLarge,
              label: '취소',
              onTap: () {
                if (mounted) Navigator.pop(context);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: ThemeModel.highlight(isDarkMode),
            child: CButton(
              size: CButtonSize.extraLarge,
              label: '확인',
              onTap: () => _handleConfirmation(context),
            ),
          ),
        ),
      ],
    );
  }

// 확인 버튼 클릭 시 선택된 날짜와 시간이 현재 시간 이후인지 검증
  void _handleConfirmation(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final now = DateTime.now();
    final hour = _convertTo24Hour();
    final dateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      hour,
      _selectedMinute,
    );

    // 선택된 날짜/시간이 현재 시간 이후가 아니라면 에러 다이얼로그 표시
    if (!dateTime.isAfter(now)) {
      showDialog(
        context: context,
        builder: (context) => CDialog(
          title: '날짜/시간을 확인하세요',
          content: Text(
            '현재 시간 이후만 선택할 수 있어요.',
            style: TextStyle(
              color: ThemeModel.text(isDarkMode),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          buttons: [
            CButton(
              size: CButtonSize.extraLarge,
              label: '확인',
              onTap: () {
                if (mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    if (mounted) {
      setState(() {
        _hasSelected = true;
      });
    }
    widget.onDateTimeSelected(dateTime);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  int _convertTo24Hour() {
    if (_period == '오후' && _selectedHour != 12) {
      return _selectedHour + 12;
    }
    if (_period == '오전' && _selectedHour == 12) {
      return 0;
    }
    return _selectedHour;
  }

  String _formatDateTime() {
    return '${_selectedDate.month}월 ${_selectedDate.day}일 '
        '(${_weekdays[_selectedDate.weekday - 1]}) '
        '$_period $_selectedHour:${_selectedMinute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    final content = CInkWell(
      onTap: () => _pickDateTime(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeModel.surface(isDarkMode),
          border: Border(
            bottom: BorderSide(
              color: widget.error
                  ? ThemeModel.danger(isDarkMode)
                  : ThemeModel.sub3(isDarkMode),
              width: widget.error ? 2 : 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: ThemeModel.sub3(isDarkMode),
            ),
            const SizedBox(width: 8),
            Text(
              _hasSelected ? _formatDateTime() : '시간 선택',
              style: TextStyle(
                fontSize: 16,
                color: _hasSelected
                    ? ThemeModel.text(isDarkMode)
                    : ThemeModel.hintText(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.error) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          content,
          const SizedBox(height: 4),
          Text(
            widget.errorText ?? "출발 시각을 선택해주세요.",
            style: TextStyle(
              fontSize: 14,
              color: ThemeModel.danger(isDarkMode),
            ),
          ),
        ],
      );
    } else {
      return content;
    }
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
}
