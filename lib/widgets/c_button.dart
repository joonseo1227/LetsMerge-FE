import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

/// 버튼 크기를 정의하는 enum
enum CButtonSize {
  small,
  medium,
  large,
  extraLarge,
  x2Large,
}

/// 버튼 스타일을 관리하는 클래스
class CButtonStyle {
  final Color backgroundColor;
  final Color labelColor;
  final Color iconColor;
  final BorderSide? border;

  const CButtonStyle({
    required this.backgroundColor,
    required this.labelColor,
    required this.iconColor,
    this.border,
  });

  /// 기본 스타일 (Primary 스타일)
  static const CButtonStyle primary = CButtonStyle(
    backgroundColor: blue60,
    labelColor: white,
    iconColor: white,
  );

  /// Secondary 스타일
  static const CButtonStyle secondary = CButtonStyle(
    backgroundColor: grey80,
    labelColor: white,
    iconColor: white,
  );

  /// Tertiary 스타일
  static const CButtonStyle tertiary = CButtonStyle(
    backgroundColor: Colors.transparent,
    labelColor: blue60,
    iconColor: blue60,
    border: BorderSide(
      color: blue60,
      width: 1,
    ),
  );

  /// Danger 스타일
  static const CButtonStyle danger = CButtonStyle(
    backgroundColor: red60,
    labelColor: white,
    iconColor: white,
  );

  /// Ghost 스타일
  static const CButtonStyle ghost = CButtonStyle(
    backgroundColor: Colors.transparent,
    labelColor: blue60,
    iconColor: blue60,
  );
}

/// 버튼 크기를 관리하는 클래스
class CButtonSizes {
  static const Map<CButtonSize, EdgeInsets> sizes = {
    CButtonSize.small: EdgeInsets.all(8),
    CButtonSize.medium: EdgeInsets.all(12),
    CButtonSize.large: EdgeInsets.all(16),
    CButtonSize.extraLarge: EdgeInsets.all(16),
    CButtonSize.x2Large: EdgeInsets.all(16),
  };

  static const Map<CButtonSize, double> textSizes = {
    CButtonSize.small: 12,
    CButtonSize.medium: 14,
    CButtonSize.large: 16,
    CButtonSize.extraLarge: 16,
    CButtonSize.x2Large: 20,
  };

  static const Map<CButtonSize, double> iconSizes = {
    CButtonSize.small: 16,
    CButtonSize.medium: 20,
    CButtonSize.large: 24,
    CButtonSize.extraLarge: 28,
    CButtonSize.x2Large: 32,
  };
}

///
/// [CButton] 위젯
///
/// Parameter:
/// - [label]: 버튼에 표시될 텍스트
/// - [icon]: 버튼에 표시될 아이콘
/// - [size]: 버튼 크기 (CButtonSize.small, CButtonSize.large 등)
/// - [style]: 버튼의 스타일 (CButtonStyle.primary, CButtonStyle.tertiary 등)
/// - [width]: 버튼의 고정 너비
/// - [onTap]: 버튼을 눌렀을 때 실행되는 콜백 함수
///
class CButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final CButtonSize size;
  final CButtonStyle style;
  final double? width;
  final VoidCallback? onTap;

  const CButton({
    super.key,
    this.label,
    this.icon,
    this.size = CButtonSize.large,
    this.style = CButtonStyle.primary,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onTap == null;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1.0,
      child: CInkWell(
        onTap: isDisabled ? null : onTap,
        child: Container(
          padding: CButtonSizes.sizes[size]!,
          width: width,
          decoration: BoxDecoration(
            color: style.backgroundColor,
            border: style.border != null
                ? Border.fromBorderSide(style.border!)
                : null,
          ),
          child: Row(
            mainAxisSize: width != null ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (label != null)
                Text(
                  label!,
                  style: TextStyle(
                    color: style.labelColor,
                    fontSize: CButtonSizes.textSizes[size],
                  ),
                ),
              if (icon != null) ...[
                if (label != null && width == null) SizedBox(width: 8),
                if (width != null) Spacer(),
                Icon(
                  icon,
                  color: style.iconColor,
                  size: CButtonSizes.iconSizes[size],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
