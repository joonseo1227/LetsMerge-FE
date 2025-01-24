import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

///
/// [CTextField] 위젯
///
/// Parameter:
/// - [label]: 필드 상단에 표시될 레이블 텍스트
/// - [hint]: 입력 필드에 표시될 힌트 텍스트 (optional)
/// - [errorText]: 에러 메시지를 표시할 텍스트 (optional)
/// - [controller]: 텍스트 입력값을 제어하는 컨트롤러 (optional)
/// - [obscureText]: 텍스트를 비밀번호 형태로 숨길지 여부 (default: false)
/// - [keyboardType]: 입력 필드의 키보드 타입 (default: TextInputType.text)
/// - [backgroundColor]: 입력 필드 배경 색상 (optional)
/// - [focusNode]: 입력 필드의 포커스를 제어하기 위한 FocusNode (optional)
///
class CTextField extends ConsumerStatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  final FocusNode? focusNode;

  const CTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.focusNode,
  });

  @override
  ConsumerState<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends ConsumerState<CTextField> {
  late FocusNode _focusNode; // Focus 상태를 감지하기 위한 FocusNode
  bool _hasFocus = false; // 현재 Focus 상태를 나타냄

  @override
  void initState() {
    super.initState();
    // 전달된 FocusNode가 있으면 사용하고, 없으면 새로 생성
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange); // Focus 상태 변화 감지 리스너 추가
  }

  @override
  void dispose() {
    // 외부에서 전달받은 FocusNode는 해제하지 않음
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange); // 리스너 제거
      _focusNode.dispose();
    }
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 레이블 텍스트
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            color: ThemeModel.text(isDarkMode),
          ),
        ),
        const SizedBox(height: 4),
        // 텍스트 입력 필드
        TextField(
          keyboardAppearance: isDarkMode ? Brightness.dark : Brightness.light,
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
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
                color: _getErrorBorderColor(),
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
            suffixIcon: widget.controller?.text.isNotEmpty ?? false
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      widget.controller?.clear();
                    },
                  )
                : null,
          ),
        ),
        // 에러 메시지 표시
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 4),
              Text(
                widget.errorText!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ThemeModel.danger(isDarkMode),
                ),
              ),
            ],
          )
      ],
    );
  }

  // 에러 발생 시의 경계선 색상 반환
  Color _getErrorBorderColor() {
    final isDarkMode = ref.watch(themeProvider);

    return widget.errorText != null && widget.errorText!.isNotEmpty
        ? ThemeModel.danger(isDarkMode)
        : ThemeModel.sub5(isDarkMode);
  }

  // Focus 상태에 따른 경계선 색상 반환
  Color _getFocusBorderColor() {
    final isDarkMode = ref.watch(themeProvider);

    return _hasFocus
        ? ThemeModel.highlight(isDarkMode)
        : ThemeModel.sub5(isDarkMode);
  }
}
