import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_toggle_button.dart';
import 'package:letsmerge/widgets/c_calendar_picker.dart';

///
/// [CPeriodPicker] 위젯
///
/// - 1개월: 종료일은 오늘, 시작일은 오늘로부터 1개월 전
/// - 3개월: 종료일은 오늘, 시작일은 오늘로부터 3개월 전
/// - 기간 설정: 달력을 통해 시작일을 선택 (종료일은 오늘 고정)
///
class CPeriodPicker extends ConsumerStatefulWidget {
  const CPeriodPicker({super.key});

  @override
  ConsumerState<CPeriodPicker> createState() => _CPeriodPickerState();
}

class _CPeriodPickerState extends ConsumerState<CPeriodPicker> {

  int selectedPeriod = 0;
  int selectedOrder = 0;

  DateTime? _customStartDate;

  late DateTime _confirmedStartDate;

  DateTime get _today => DateTime.now();

  DateTime get _computedStartDate {
    if (selectedPeriod == 0) {
      return DateTime(_today.year, _today.month - 1, _today.day);
    } else if (selectedPeriod == 1) {
      return DateTime(_today.year, _today.month - 3, _today.day);
    } else if (selectedPeriod == 2) {
      return _customStartDate ?? DateTime(_today.year, _today.month, _today.day);
    }
    return DateTime(_today.year, _today.month - 1, _today.day);
  }

  @override
  void initState() {
    super.initState();
    final now = _today;
    _confirmedStartDate = DateTime(now.year, now.month - 1, now.day);
  }

  Future<void> _pickPeriodTime(BuildContext context) async {
    final isDarkMode = ref.watch(themeProvider);
    final DateTime? newStartDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => _buildDialog(context, isDarkMode),
    );
    if (newStartDate != null) {
      setState(() {
        _confirmedStartDate = newStartDate;
      });
    }
  }

  Widget _buildCustomCalendarPicker(bool isDarkMode, void Function(void Function()) setStateDialog) {
    return CCalendarPicker(
      initialDate: _customStartDate ?? _computedStartDate,
      firstDate: DateTime(_today.year - 1),
      lastDate: _today,
      onDateChanged: (date) {
        setStateDialog(() {
          _customStartDate = date;
        });
      },
    );
  }

  Widget _buildDialog(BuildContext context, bool isDarkMode) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: StatefulBuilder(
        builder: (context, setStateDialog) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "기간 설정",
                          style: TextStyle(
                            color: ThemeModel.text(isDarkMode),
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CToggleButton(
                          buttonCount: 3,
                          labels: ['1개월', '3개월', '기간 설정'],
                          initialSelectedIndex: selectedPeriod,
                          onToggle: (index) {
                            setStateDialog(() {
                              selectedPeriod = index;
                              if (selectedPeriod != 2) {
                                _customStartDate = null;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        CToggleButton(
                          buttonCount: 2,
                          labels: ['최신순', '오래된순'],
                          initialSelectedIndex: selectedOrder,
                          onToggle: (index) {
                            setStateDialog(() {
                              selectedOrder = index;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: ThemeModel.surface(isDarkMode),
                            border: Border(
                              bottom: BorderSide(
                                color: ThemeModel.sub5(isDarkMode),
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "선택한 기간",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.highlightText(isDarkMode),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${_formatDate(_computedStartDate)} - ${_formatDate(_today)}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeModel.text(isDarkMode),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedPeriod == 2) ...[
                          const SizedBox(height: 16),
                          Text(
                            "선택한 날짜부터 오늘 날짜까지 조회합니다.",
                            style: TextStyle(
                              fontSize: 16,
                              color: ThemeModel.highlightText(isDarkMode),
                            ),
                          ),
                          _buildCustomCalendarPicker(isDarkMode, setStateDialog),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CButton(
                      size: CButtonSize.extraLarge,
                      label: '취소',
                      style: CButtonStyle.secondary(isDarkMode),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: CButton(
                      size: CButtonSize.extraLarge,
                      label: '확인',
                      style: CButtonStyle.primary(isDarkMode),
                      onTap: () {
                        Navigator.of(context).pop(_computedStartDate);
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}.${date.month}.${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    return CInkWell(
      onTap: () => _pickPeriodTime(context),
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
          children: [
            Text(
              "기간 설정",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ThemeModel.highlightText(isDarkMode),
              ),
            ),
            const Spacer(),
            Text(
              "${_formatDate(_confirmedStartDate)} - ${_formatDate(_today)}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
          ],
        ),
      ),
    );
  }
}