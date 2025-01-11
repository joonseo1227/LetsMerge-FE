import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/provider/theme_provider.dart';

enum TagColor {
  red,
  magenta,
  purple,
  blue,
  cyan,
  teal,
  green,
  orange,
  yellow,
  grey,
  coolGrey,
  warmGrey,
}

extension TagColorExtension on TagColor {
  Color backgroundColor(bool isDarkMode) {
    switch (this) {
      case TagColor.red:
        return isDarkMode ? red80 : red20;
      case TagColor.magenta:
        return isDarkMode ? magenta80 : magenta20;
      case TagColor.purple:
        return isDarkMode ? purple80 : purple20;
      case TagColor.blue:
        return isDarkMode ? blue80 : blue20;
      case TagColor.cyan:
        return isDarkMode ? cyan80 : cyan20;
      case TagColor.teal:
        return isDarkMode ? teal80 : teal20;
      case TagColor.green:
        return isDarkMode ? green80 : green20;
      case TagColor.orange:
        return orange40;
      case TagColor.yellow:
        return yellow30;
      case TagColor.grey:
        return isDarkMode ? grey80 : grey20;
      case TagColor.coolGrey:
        return isDarkMode ? coolgrey80 : coolgrey20;
      case TagColor.warmGrey:
        return isDarkMode ? warmgrey80 : warmgrey20;
    }
  }

  Color textColor(bool isDarkMode) {
    switch (this) {
      case TagColor.red:
        return isDarkMode ? red40 : red70;
      case TagColor.magenta:
        return isDarkMode ? magenta40 : magenta70;
      case TagColor.purple:
        return isDarkMode ? purple40 : purple70;
      case TagColor.blue:
        return isDarkMode ? blue40 : blue70;
      case TagColor.cyan:
        return isDarkMode ? cyan40 : cyan70;
      case TagColor.teal:
        return isDarkMode ? teal40 : teal70;
      case TagColor.green:
        return isDarkMode ? green40 : green70;
      case TagColor.orange:
        return white;
      case TagColor.yellow:
        return black;
      case TagColor.grey:
        return isDarkMode ? grey40 : grey70;
      case TagColor.coolGrey:
        return isDarkMode ? coolgrey40 : coolgrey70;
      case TagColor.warmGrey:
        return isDarkMode ? warmgrey40 : warmgrey70;
    }
  }
}

///
/// [CTag] 위젯
///
/// 사용자 정의 태그 컴포넌트
///
/// Parameter:
/// - [text]: 태그 내부에 표시할 텍스트
/// - [color]: 태그의 색상 ([TagColor] 타입)
///
/// 기능:
/// - 주어진 색상과 텍스트로 태그 UI 구성
/// - 다크 모드 상태에 따라 배경 및 텍스트 색상 변경
///
class CTag extends ConsumerWidget {
  const CTag({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final TagColor color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: ShapeDecoration(
        color: color.backgroundColor(isDarkMode),
        shape: const StadiumBorder(),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.textColor(isDarkMode),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
