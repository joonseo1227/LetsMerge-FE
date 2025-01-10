import 'package:flutter/material.dart';

class CInkWell extends StatefulWidget {
  final Widget child;

  /// 버튼을 눌렀을 때 실행될 함수
  /// null일 경우 비활성화 상태로 동작
  final VoidCallback? onTap;

  /// 버튼을 눌렀을 때의 축소 비율 (기본값: 0.9)
  final double shrinkScale;

  const CInkWell({
    super.key,
    required this.child,
    this.onTap,
    this.shrinkScale = 0.9,
  });

  @override
  _CInkWellState createState() => _CInkWellState();
}

class _CInkWellState extends State<CInkWell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.shrinkScale,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onTap != null) {
      Future.delayed(Duration(milliseconds: 150), () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      });
      widget.onTap?.call();
    }
  }

  void _onTapCancel() {
    if (widget.onTap != null) {
      Future.delayed(Duration(milliseconds: 150), () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          opacity: _isPressed ? 0.4 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}