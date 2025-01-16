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
  final Function(bool value) onChanged; // 스위치 값 변경 콜백 함수
  final bool value; // 부모로부터 전달받는 스위치 상태

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
        // 스위치 상태를 반전하고 부모에게 알림
        widget.onChanged(!widget.value);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 스위치 배경
          Container(
            width: 56,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32), // 둥근 모서리 처리
              color: widget.value
                  ? ThemeModel.highlight(isDarkMode)
                  : ThemeModel.sub2(isDarkMode), // 부모 상태에 따라 색상 변경
            ),
          ),
          // 스위치 핸들 (슬라이더)
          AnimatedPositioned(
            duration: Duration(milliseconds: 150), // 애니메이션 지속 시간
            curve: Curves.easeInOut, // 애니메이션 커브
            left: widget.value ? 28 : 4, // 부모 상태에 따라 핸들 위치 설정
            child: Container(
              width: 24, // 핸들의 너비
              height: 24, // 핸들의 높이
              decoration: BoxDecoration(
                shape: BoxShape.circle, // 원형 모양
                color: white, // 핸들의 색상
              ),
            ),
          ),
        ],
      ),
    );
  }
}
