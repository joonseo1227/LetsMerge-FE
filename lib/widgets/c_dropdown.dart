import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';

///
/// [CDropdown] 위젯
///
/// Parameter:
/// - [label]: 필드 상단에 표시될 레이블 텍스트 (optional)
/// - [hint]: 선택되지 않았을 때 표시할 기본 텍스트 (default: "선택")
/// - [items]: 드롭다운에 표시할 아이템 리스트 (required)
/// - [initialValue]: 초기 선택 값 (optional)
/// - [onChanged]: 선택한 값이 변경되었을 때 호출되는 콜백 (optional)
/// - [itemAsString]: 아이템을 문자열로 변환하는 함수 (optional, 기본값은 toString)
///
class CDropdown<T> extends ConsumerStatefulWidget {
  final String? label;
  final String hint;
  final List<T> items;
  final T? initialValue;
  final ValueChanged<T>? onChanged;
  final String Function(T)? itemAsString;

  const CDropdown({
    super.key,
    this.label,
    this.hint = "선택",
    required this.items,
    this.initialValue,
    this.onChanged,
    this.itemAsString,
  });

  @override
  ConsumerState<CDropdown<T>> createState() => _CDropdownState<T>();
}

class _CDropdownState<T> extends ConsumerState<CDropdown<T>> {
  T? selectedItem;
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();

  @override
  void initState() {
    super.initState();
    selectedItem = widget.initialValue;
  }

  // 선택된 아이템이 있으면 해당 값을, 없으면 hint 텍스트를 반환
  String _getDisplayText() {
    if (selectedItem != null) {
      return widget.itemAsString?.call(selectedItem!) ??
          selectedItem.toString();
    }
    return widget.hint;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              color: ThemeModel.sub6(isDarkMode),
            ),
          ),
          const SizedBox(height: 4),
        ],
        CPopupMenu(
          key: popupMenuKey,
          button: Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getDisplayText(),
                  style: TextStyle(
                    fontSize: 16,
                    color: selectedItem != null
                        ? ThemeModel.text(isDarkMode)
                        : ThemeModel.hintText(isDarkMode),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: ThemeModel.hintText(isDarkMode),
                ),
              ],
            ),
          ),
          dropdownWidth: MediaQuery.of(context).size.width - 32,
          dropdown: Container(
            constraints: const BoxConstraints(maxHeight: 320),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const Divider(
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return CInkWell(
                  onTap: () {
                    setState(() {
                      selectedItem = item;
                    });
                    widget.onChanged?.call(item);
                    popupMenuKey.currentState?.hideDropdown();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.itemAsString?.call(item) ?? item.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
