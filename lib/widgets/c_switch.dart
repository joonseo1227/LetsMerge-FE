import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

///
/// [CSwitch] 위젯
///
/// Parameter:
/// - [onChanged]: 스위치 값이 변경되었을 때 실행되는 콜백 함수
/// - [value]: 초기 스위치 상태 (true 또는 false)
///
class CSwitch extends ConsumerStatefulWidget {
  final Function(bool value) onChanged;
  final bool value;

  const CSwitch({
    super.key,
    required this.onChanged,
    required this.value,
  });

  @override
  _CSwitchState createState() => _CSwitchState();
}

class _CSwitchState extends ConsumerState<CSwitch> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 44,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.value
                  ? ThemeModel.highlight(isDarkMode)
                  : ThemeModel.sub2(isDarkMode),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            left: widget.value ? 24 : 4,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
