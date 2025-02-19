import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

/// CListTile 크기를 정의하는 enum
enum CListTileSize {
  small,
  medium,
  large,
  extraLarge,
}

/// CListTile 크기별 스타일을 관리하는 클래스
class CListTileSizes {
  static const Map<CListTileSize, EdgeInsets> paddings = {
    CListTileSize.small: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    CListTileSize.medium: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    CListTileSize.large: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    CListTileSize.extraLarge:
        EdgeInsets.symmetric(vertical: 20, horizontal: 24),
  };

  static const Map<CListTileSize, double> textSizes = {
    CListTileSize.small: 14,
    CListTileSize.medium: 16,
    CListTileSize.large: 18,
    CListTileSize.extraLarge: 20,
  };

  static const Map<CListTileSize, double> subtitleSizes = {
    CListTileSize.small: 12,
    CListTileSize.medium: 14,
    CListTileSize.large: 16,
    CListTileSize.extraLarge: 18,
  };

  static const Map<CListTileSize, double> iconSizes = {
    CListTileSize.small: 18,
    CListTileSize.medium: 20,
    CListTileSize.large: 24,
    CListTileSize.extraLarge: 28,
  };
}

class CListTile extends ConsumerWidget {
  final String? label;
  final String? subtitle;
  final IconData? icon;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final CListTileSize size;

  const CListTile({
    super.key,
    this.label,
    this.subtitle,
    this.icon,
    this.trailingIcon = Icons.navigate_next,
    this.onTap,
    this.leading,
    this.trailing,
    this.size = CListTileSize.large,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      color: ThemeModel.surface(isDarkMode),
      child: CInkWell(
        onTap: onTap,
        child: Padding(
          padding: CListTileSizes.paddings[size]!,
          child: Row(
            children: [
              // 왼쪽 아이콘 or 커스텀 leading 위젯
              if (leading != null)
                leading!
              else if (icon != null)
                Icon(
                  icon,
                  size: CListTileSizes.iconSizes[size],
                  color: ThemeModel.sub4(isDarkMode),
                ),

              if (icon != null || leading != null) const SizedBox(width: 16),

              // 중앙 텍스트 영역
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label ?? '',
                      style: TextStyle(
                        fontSize: CListTileSizes.textSizes[size],
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                    if (subtitle != null) ...[
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: CListTileSizes.subtitleSizes[size],
                          fontWeight: FontWeight.w500,
                          color: ThemeModel.sub4(isDarkMode),
                        ),
                      ),
                    ]
                  ],
                ),
              ),

              // 오른쪽 trailing 아이콘 or 커스텀 trailing 위젯
              if (trailing != null)
                trailing!
              else if (trailingIcon != null)
                Icon(
                  trailingIcon,
                  size: CListTileSizes.iconSizes[size],
                  color: ThemeModel.sub3(isDarkMode),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
