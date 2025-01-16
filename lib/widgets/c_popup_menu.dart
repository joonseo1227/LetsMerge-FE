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
    Key? key,
    required this.button,
    required this.dropdown,
    this.dropdownWidth,
    this.dropdownHeight,
  }) : super(key: key);

  @override
  ConsumerState<CPopupMenu> createState() => _CPopupMenuState();
}

class _CPopupMenuState extends ConsumerState<CPopupMenu>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isDropdownVisible = false;
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _positionAnimation;

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

    final rightOverflow = buttonPosition.dx + dropdownWidth > screenSize.width;
    final leftOverflow = buttonPosition.dx < 0;

    double? horizontalOffset;
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
              offset: Offset(horizontalOffset ?? 0, buttonSize.height),
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

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
    setState(() => _isDropdownVisible = true);
  }

  void hideDropdown() {
    if (_overlayEntry != null) {
      _animationController.reverse().then((_) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        setState(() => _isDropdownVisible = false);
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
