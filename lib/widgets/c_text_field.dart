import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';

///
/// [CTextField] 위젯
///
/// 사용자 정의 텍스트 입력 필드
///
/// Parameter:
/// - [label]: 필드 상단에 표시될 레이블 텍스트
/// - [hint]: 입력 필드에 표시될 힌트 텍스트 (optional)
/// - [errorText]: 에러 메시지를 표시할 텍스트 (optional)
/// - [controller]: 텍스트 입력값을 제어하는 컨트롤러 (optional)
/// - [obscureText]: 텍스트를 비밀번호 형태로 숨길지 여부 (default: false)
/// - [keyboardType]: 입력 필드의 키보드 타입 (default: TextInputType.text)
/// - [backgroundColor]: 입력 필드 배경 색상 (optional)
///
class CTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? backgroundColor;

  const CTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
  });

  @override
  State<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 레이블 텍스트
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            color: grey100,
          ),
        ),
        const SizedBox(height: 4),
        // 텍스트 입력 필드
        SizedBox(
          height: 48,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: grey40),
              filled: true,
              fillColor: widget.backgroundColor ?? white,
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
        ),
        // 에러 메시지 표시
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Column(
            children: [
              const SizedBox(height: 4),
              Text(
                widget.errorText!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: red60,
                ),
              ),
            ],
          )
      ],
    );
  }

  // 에러 발생 시의 경계선 색상 반환
  Color _getErrorBorderColor() {
    return widget.errorText != null && widget.errorText!.isNotEmpty
        ? red60
        : grey60;
  }

  // Focus 상태에 따른 경계선 색상 반환
  Color _getFocusBorderColor() {
    return _hasFocus ? blue60 : grey60;
  }
}

///
/// [CustomSearchBar] 위젯
///
/// 검색 기능을 위한 사용자 정의 텍스트 입력 필드
///
/// Parameter:
/// - [hint]: 입력 필드에 표시될 힌트 텍스트 (optional)
/// - [controller]: 텍스트 입력값을 제어하는 컨트롤러 (optional)
/// - [backgroundColor]: 입력 필드 배경 색상 (optional)
/// - [onSubmitted]: 텍스트 입력 완료 시 호출될 콜백 함수 (optional)
///
class CustomSearchBar extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final Function(String)? onSubmitted;

  const CustomSearchBar({
    super.key,
    this.hint,
    this.controller,
    this.backgroundColor,
    this.onSubmitted,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
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
    return SizedBox(
      height: 48,
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: grey40),
          filled: true,
          fillColor: widget.backgroundColor ?? white,
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
          prefixIcon: Icon(
            Icons.search,
            color: _hasFocus ? blue60 : grey60,
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
      ),
    );
  }

  // 에러 상태의 경계선 색상 반환
  Color _getErrorBorderColor() {
    return grey60;
  }

  // Focus 상태에 따른 경계선 색상 반환
  Color _getFocusBorderColor() {
    return _hasFocus ? blue60 : grey60;
  }
}
