import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';

/// 토글버튼 위젯
///
/// [buttonCount]: 생성할 버튼의 개수
/// [labels]: 각 버튼에 표시할 텍스트 리스트.
/// [onToggle]: 버튼이 선택될 때 호출되는 콜백 함수 (선택된 버튼의 인덱스 전달)
/// [initialSelectedIndex]: 초기 선택 인덱스 (기본값 0)
/// [buttonSize]: CButton의 크기 (기본값 CButtonSize.large)
class CToggleButton extends ConsumerStatefulWidget {
  final int buttonCount;
  final List<String> labels;
  final ValueChanged<int>? onToggle;
  final int initialSelectedIndex;
  final CButtonSize buttonSize;

  const CToggleButton({
    super.key,
    required this.buttonCount,
    required this.labels,
    this.onToggle,
    this.initialSelectedIndex = 0,
    this.buttonSize = CButtonSize.large,
  });

  @override
  ConsumerState<CToggleButton> createState() => _CToggleButtonState();
}

class _CToggleButtonState extends ConsumerState<CToggleButton> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    return Container(
      color: ThemeModel.surface(isDarkMode),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(widget.buttonCount, (index) {
          final bool isSelected = index == selectedIndex;
          final String labelText =
              widget.labels.length > index ? widget.labels[index] : '';
          return Expanded(
            child: CButton(
              label: labelText,
              size: widget.buttonSize,
              style: isSelected
                  ? CButtonStyle.primary(isDarkMode)
                  : CButtonStyle.ghost(isDarkMode),
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                if (widget.onToggle != null) {
                  widget.onToggle!(index);
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
