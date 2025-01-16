import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class CPopupMenu extends ConsumerStatefulWidget {
  final Widget button;
  final Widget dropdown;
  final double? dropdownWidth;
  final double? dropdownHeight;

  const CPopupMenu({
    Key? key,
    required this.button,
    required this.dropdown,
    this.dropdownWidth,
    this.dropdownHeight,
  }) : super(key: key);

  @override
  ConsumerState<CPopupMenu> createState() => _CPopupMenuState();
}

class _CPopupMenuState extends ConsumerState<CPopupMenu> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownVisible = false;

  @override
  void dispose() {
    hideDropdown();
    super.dispose();
  }

  void showDropdown() {
    final isDarkMode = ref.watch(themeProvider);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size buttonSize = renderBox.size;
    final Offset buttonPosition = renderBox.localToGlobal(Offset.zero);

    // 화면 크기 가져오기
    final Size screenSize = MediaQuery.of(context).size;

    // 드롭다운 너비 계산
    final dropdownWidth = widget.dropdownWidth ?? buttonSize.width;

    // 드롭다운이 화면을 벗어나는지 확인
    final rightOverflow = buttonPosition.dx + dropdownWidth > screenSize.width;
    final leftOverflow = buttonPosition.dx < 0;

    // 드롭다운 위치 계산
    double? horizontalOffset;
    if (rightOverflow && !leftOverflow) {
      // 오른쪽 화면을 벗어나는 경우
      horizontalOffset = -(dropdownWidth - buttonSize.width);
    } else if (!rightOverflow && leftOverflow) {
      // 왼쪽 화면을 벗어나는 경우
      horizontalOffset = 0;
    } else {
      // 화면 내에 있는 경우, 버튼 위치 기준으로 정렬
      horizontalOffset = buttonPosition.dx > screenSize.width / 2
          ? -(dropdownWidth - buttonSize.width)
          : 0;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 배경 터치 감지
          Positioned.fill(
            child: GestureDetector(
              onTap: hideDropdown,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // 드롭다운 컨텐츠
          Positioned(
            width: dropdownWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(horizontalOffset ?? 0, buttonSize.height),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: widget.dropdownHeight,
                  decoration: BoxDecoration(
                    color: ThemeModel.surface(isDarkMode),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: widget.dropdown,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isDropdownVisible = true);
  }

  void hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isDropdownVisible = false);
  }

  void toggleDropdown() {
    if (_isDropdownVisible) {
      hideDropdown();
    } else {
      showDropdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: CInkWell(
        onTap: toggleDropdown,
        child: widget.button,
      ),
    );
  }
}
