import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';

///
/// [CSwitch] 커스텀 스위치 위젯
///
/// Parameter:
/// - [onChanged]: 스위치 값이 변경되었을 때 실행되는 콜백 함수
/// - [value]: 초기 스위치 상태 (true 또는 false)
///
class CSwitch extends StatefulWidget {
  final Function(bool value) onChanged; // 스위치 값 변경 콜백 함수
  final bool value; // 초기 스위치 상태

  const CSwitch({
    required this.onChanged,
    required this.value,
  });

  @override
  _CSwitchState createState() => _CSwitchState();
}

class _CSwitchState extends State<CSwitch> {
  bool _isSwitched = false; // 현재 스위치 상태

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // 스위치 상태를 반전
          _isSwitched = !_isSwitched;
        });

        // 변경된 상태를 콜백 함수로 전달
        widget.onChanged(_isSwitched);
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
              color: _isSwitched ? blue60 : grey30, // 상태에 따른 색상 변경
            ),
          ),
          // 스위치 핸들 (슬라이더)
          AnimatedPositioned(
            duration: Duration(milliseconds: 150), // 애니메이션 지속 시간
            curve: Curves.easeInOut, // 애니메이션 커브
            left: _isSwitched ? 28 : 4, // 핸들의 위치 설정
            child: GestureDetector(
              onHorizontalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  // 드래그된 위치를 계산하여 스위치 상태를 업데이트
                  double newPosition = details.localPosition.dx;
                  if (newPosition < -32) {
                    newPosition = -32;
                  } else if (newPosition > 32) {
                    newPosition = 32;
                  }
                  _isSwitched = newPosition > 0.0;
                });
              },
              child: Container(
                width: 24, // 핸들의 너비
                height: 24, // 핸들의 높이
                decoration: BoxDecoration(
                  shape: BoxShape.circle, // 원형 모양
                  color: white, // 핸들의 색상
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
