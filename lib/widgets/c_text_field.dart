import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';

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
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

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
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            color: grey100,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 48,
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(
                color: grey40,
              ),
              filled: true,
              fillColor: widget.backgroundColor ?? grey10,
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
        if (widget.errorText != null && widget.errorText!.isNotEmpty)
          Column(
            children: [
              const SizedBox(
                height: 4,
              ),
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

  Color _getErrorBorderColor() {
    return widget.errorText != null && widget.errorText!.isNotEmpty
        ? red60
        : grey60;
  }

  Color _getFocusBorderColor() {
    return _hasFocus ? blue50 : grey60;
  }
}

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
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

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
          hintStyle: const TextStyle(
            color: grey40,
          ),
          filled: true,
          fillColor: widget.backgroundColor ?? grey10,
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
          prefixIcon: Icon(Icons.search, color: _hasFocus ? blue50 : grey60),
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

  Color _getErrorBorderColor() {
    return grey60;
  }

  Color _getFocusBorderColor() {
    return _hasFocus ? blue50 : grey60;
  }
}
