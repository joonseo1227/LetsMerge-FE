import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class CListTile extends ConsumerStatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  const CListTile({
    super.key,
    this.label,
    this.icon,
    this.onTap,
  });

  @override
  ConsumerState<CListTile> createState() => _CListTileState();
}

class _CListTileState extends ConsumerState<CListTile> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Container(
      color: ThemeModel.surface(isDarkMode),
      child: Column(
        children: [
          CInkWell(
            onTap: widget.onTap,
            child: Container(
              color: ThemeModel.surface(isDarkMode),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (widget.icon != null)
                    Icon(
                      widget.icon,
                      size: 24,
                      color: ThemeModel.sub4(isDarkMode),
                    ),
                  if (widget.icon != null)
                    SizedBox(
                      width: 16,
                    ),
                  Text(
                    widget.label ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.navigate_next,
                    color: ThemeModel.sub3(isDarkMode),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
