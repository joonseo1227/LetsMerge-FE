import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

///
/// [CCheckbox] 위젯
///
/// Parameter:
/// - [value]: 체크박스의 현재 상태 (true 또는 false)
/// - [onChanged]: 체크박스 상태가 변경될 때 호출되는 콜백 함수
/// - [label]: 체크박스 옆에 표시될 레이블 텍스트 (optional)
/// - [size]: 체크박스의 크기 (기본값: 20)
///
class CCheckbox extends ConsumerWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final double size;

  const CCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final bool isDisabled = onChanged == null;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: CInkWell(
        onTap: isDisabled ? null : () => onChanged?.call(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: value
                    ? ThemeModel.highlight(isDarkMode)
                    : Colors.transparent,
                border: Border.all(
                  color: value
                      ? ThemeModel.highlight(isDarkMode)
                      : ThemeModel.text(isDarkMode),
                  width: 1,
                ),
              ),
              child: value
                  ? Icon(
                      Icons.check,
                      size: size * 0.75,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (label != null) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeModel.text(isDarkMode),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
