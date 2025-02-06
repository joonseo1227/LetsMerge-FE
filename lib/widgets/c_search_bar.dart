import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/server/rest_api.dart';

///
/// [CSearchBar] 위젯
///
/// Parameter:
/// - [hint]: 입력 필드에 표시될 힌트 텍스트 (optional)
/// - [controller]: 텍스트 입력값을 제어하는 컨트롤러 (optional)
/// - [backgroundColor]: 입력 필드 배경 색상 (optional)
/// - [focusNode]: 텍스트 필드의 포커스를 제어할 FocusNode (optional)
/// - [onSubmitted]: 텍스트 입력 완료 시 호출될 콜백 함수 (optional)
///
class CSearchBar extends ConsumerStatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;

  const CSearchBar({
    super.key,
    this.hint,
    this.controller,
    this.backgroundColor,
    this.focusNode,
    this.onSubmitted,
  });

  @override
  ConsumerState<CSearchBar> createState() => _CSearchBarState();
}

class _CSearchBarState extends ConsumerState<CSearchBar> {
  late FocusNode _internalFocusNode;
  late FocusNode _activeFocusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _activeFocusNode = widget.focusNode ?? _internalFocusNode;
    _activeFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _activeFocusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _activeFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return TextField(
      keyboardAppearance: isDarkMode ? Brightness.dark : Brightness.light,
      controller: widget.controller,
      focusNode: _activeFocusNode,
      textAlign: TextAlign.start,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(
        color: ThemeModel.text(isDarkMode),
      ),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(16),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: ThemeModel.hintText(isDarkMode),
        ),
        filled: true,
        fillColor: widget.backgroundColor ?? ThemeModel.surface(isDarkMode),
        enabledBorder: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(
            color: ThemeModel.sub5(isDarkMode),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(
            color: _getFocusBorderColor(),
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: _getFocusBorderColor(),
        ),
        suffixIcon: widget.controller?.text.isNotEmpty ?? false
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller?.clear();
                },
              )
            : null,
      ),
      onSubmitted: widget.onSubmitted,
    );
  }

  // Focus 상태에 따른 경계선 색상 반환
  Color _getFocusBorderColor() {
    final isDarkMode = ref.watch(themeProvider);

    return _hasFocus
        ? ThemeModel.highlight(isDarkMode)
        : ThemeModel.sub5(isDarkMode);
  }
}
