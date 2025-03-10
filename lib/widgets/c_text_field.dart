import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

///
/// [CTextField] 위젯
///
/// Parameter:
/// - [label]: 필드 상단에 표시될 레이블 텍스트 (optional)
/// - [hint]: 입력 필드에 표시될 힌트 텍스트 (optional)
/// - [errorText]: 에러 메시지를 표시할 텍스트 (optional)
/// - [controller]: 텍스트 입력값을 제어하는 컨트롤러 (optional)
/// - [obscureText]: 텍스트를 비밀번호 형태로 숨길지 여부 (default: false)
/// - [keyboardType]: 입력 필드의 키보드 타입 (default: TextInputType.text)
/// - [backgroundColor]: 입력 필드 배경 색상 (optional)
/// - [focusNode]: 입력 필드의 포커스를 제어하기 위한 FocusNode (optional)
/// - [onChanged]: 입력값이 변경될 때 호출되는 콜백 함수 (optional)
/// - [maxLines]: 입력 필드의 최대 줄 수 (default: 1)
///
class CTextField extends ConsumerStatefulWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const CTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.focusNode,
    this.onChanged,
    this.inputFormatters,
    this.maxLines = 1,
  });

  @override
  ConsumerState<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends ConsumerState<CTextField> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

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
        if (widget.label != null)
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              color: ThemeModel.sub6(isDarkMode),
            ),
          ),
        if (widget.label != null) const SizedBox(height: 4),
        TextField(
          keyboardAppearance: isDarkMode ? Brightness.dark : Brightness.light,
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: ThemeModel.text(isDarkMode),
          ),
          maxLines: widget.maxLines,
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
                      if (widget.onChanged != null) {
                        widget.onChanged!('');
                      }
                      setState(() {});
                    },
                  )
                : null,
          ),
          onChanged: widget.onChanged,
        ),
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

  Color _getErrorBorderColor() {
    final isDarkMode = ref.watch(themeProvider);
    return widget.errorText != null && widget.errorText!.isNotEmpty
        ? ThemeModel.danger(isDarkMode)
        : ThemeModel.sub3(isDarkMode);
  }

  Color _getFocusBorderColor() {
    final isDarkMode = ref.watch(themeProvider);
    return _hasFocus
        ? ThemeModel.highlight(isDarkMode)
        : ThemeModel.sub3(isDarkMode);
  }
}
