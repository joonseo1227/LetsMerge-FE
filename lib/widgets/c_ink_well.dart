import 'package:flutter/material.dart';

///
/// [CInkWell] 위젯
///
/// Parameter:
/// - [child]: 위젯 내부에 표시될 자식 위젯
/// - [onTap]: 버튼을 눌렀을 때 실행될 함수 (optional, null일 경우 비활성화 상태)
/// - [shrinkScale]: 버튼을 눌렀을 때의 축소 비율 (default: 0.9)
///
class CInkWell extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
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
    // 애니메이션 컨트롤러 초기화
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // 축소 효과를 위한 애니메이션 초기화
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.shrinkScale,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
      reverseCurve: Curves.easeInOut,
    ));
  }

  /// 버튼이 눌릴 때 호출되는 함수
  void _onTapDown(TapDownDetails _) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  /// 버튼을 뗄 때 호출되는 함수
  void _onTapUp(TapUpDetails _) {
    if (widget.onTap != null) {
      // 눌림 상태 해제 및 콜백 실행
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      });
      widget.onTap?.call();
    }
  }

  /// 눌림이 취소될 때 호출되는 함수
  void _onTapCancel() {
    if (widget.onTap != null) {
      Future.delayed(const Duration(milliseconds: 150), () {
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
      // 크기 축소 애니메이션
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          // 버튼 눌림 시 투명도 조절
          opacity: _isPressed ? 0.4 : 1.0,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 애니메이션 컨트롤러 해제
    _animationController.dispose();
    super.dispose();
  }
}
