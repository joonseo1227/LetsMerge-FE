import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

///
/// [CSearchBar] 위젯
///
/// Parameter:
/// - [hint]: 입력 필드에 표시될 힌트 텍스트 (optional)
/// - [controller]: 텍스트 입력값을 제어하는 컨트롤러 (optional)
/// - [backgroundColor]: 입력 필드 배경 색상 (optional)
/// - [onSubmitted]: 텍스트 입력 완료 시 호출될 콜백 함수 (optional)
///
class CSearchBar extends ConsumerStatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final Function(String)? onSubmitted;

  const CSearchBar({
    super.key,
    this.hint,
    this.controller,
    this.backgroundColor,
    this.onSubmitted,
  });

  @override
  ConsumerState<CSearchBar> createState() => _CSearchBarState();
}

class _CSearchBarState extends ConsumerState<CSearchBar> {
  late FocusNode _focusNode; // Focus 상태를 감지하기 위한 FocusNode
  bool _hasFocus = false; // 현재 Focus 상태를 나타냄

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange); // Focus 상태 변화 감지 리스너 추가
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange); // 리스너 제거
    _focusNode.dispose();
    super.dispose();
  }

  // Focus 상태 변화 시 호출되는 메서드
  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
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
