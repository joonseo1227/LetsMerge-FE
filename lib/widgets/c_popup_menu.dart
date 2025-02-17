import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

///
/// [CPopupMenu] 위젯
///
/// Parameter:
/// - [button]: 드롭다운 메뉴를 여는 버튼 위젯
/// - [dropdown]: 드롭다운에 표시될 콘텐츠 위젯
/// - [dropdownWidth]: 드롭다운의 너비 (optional, 기본값은 버튼의 너비)
/// - [dropdownHeight]: 드롭다운의 높이 (optional)
///
class CPopupMenu extends ConsumerStatefulWidget {
  final Widget button;
  final Widget dropdown;
  final double? dropdownWidth;
  final double? dropdownHeight;

  const CPopupMenu({
    super.key,
    required this.button,
    required this.dropdown,
    this.dropdownWidth,
    this.dropdownHeight,
  });

  @override
  CPopupMenuState createState() => CPopupMenuState();
}

class CPopupMenuState extends ConsumerState<CPopupMenu>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownVisible = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;
  LocalHistoryEntry? _historyEntry; // 뒤로가기 처리를 위한 LocalHistoryEntry

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _positionAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    // 위젯이 dispose될 때 드롭다운이 있다면 숨김
    hideDropdown();
    _animationController.dispose();
    super.dispose();
  }

  void showDropdown() {
    final isDarkMode = ref.watch(themeProvider);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size buttonSize = renderBox.size;
    final Offset buttonPosition = renderBox.localToGlobal(Offset.zero);

    final Size screenSize = MediaQuery.of(context).size;
    final dropdownWidth = widget.dropdownWidth ?? buttonSize.width;

    // 오른쪽 또는 왼쪽으로 오버플로우가 발생하는지 계산
    final rightOverflow = buttonPosition.dx + dropdownWidth > screenSize.width;
    final leftOverflow = buttonPosition.dx < 0;

    double horizontalOffset;
    if (rightOverflow && !leftOverflow) {
      horizontalOffset = -(dropdownWidth - buttonSize.width);
    } else if (!rightOverflow && leftOverflow) {
      horizontalOffset = 0;
    } else {
      horizontalOffset = buttonPosition.dx > screenSize.width / 2
          ? -(dropdownWidth - buttonSize.width)
          : 0;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // 오버레이 외부를 터치하면 드롭다운 숨김
          Positioned.fill(
            child: GestureDetector(
              onTap: hideDropdown,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            width: dropdownWidth,
            child: CompositedTransformFollower(
              link: _layerLink,
              offset: Offset(horizontalOffset, buttonSize.height),
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _positionAnimation,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: widget.dropdownHeight,
                      decoration: BoxDecoration(
                        color: ThemeModel.surface(isDarkMode),
                      ),
                      child: widget.dropdown,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Overlay에 드롭다운 추가
    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() => _isDropdownVisible = true);

    // 뒤로가기 시 드롭다운이 사라지도록 LocalHistoryEntry 추가
    _historyEntry = LocalHistoryEntry(onRemove: _handleDropdownDismissed);
    ModalRoute.of(context)?.addLocalHistoryEntry(_historyEntry!);
  }

  // LocalHistoryEntry가 제거될 때(뒤로가기 등) 호출되는 콜백
  void _handleDropdownDismissed() {
    _historyEntry = null;
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      if (mounted) {
        setState(() => _isDropdownVisible = false);
      }
    });
  }

  void hideDropdown() {
    if (!_isDropdownVisible) return;

    if (_historyEntry != null) {
      // LocalHistoryEntry가 있으면 pop하여 onRemove 콜백(_handleDropdownDismissed)을 실행시킴
      Navigator.of(context).pop();
    } else {
      // 이미 history entry가 없는 경우 직접 애니메이션 후 오버레이 제거
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        if (mounted) {
          setState(() => _isDropdownVisible = false);
        }
      });
    }
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
