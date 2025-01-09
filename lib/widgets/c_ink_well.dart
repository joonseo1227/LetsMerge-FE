import 'package:flutter/material.dart';

class CInkWell extends StatefulWidget {
  final Widget child;
  final Function onPressed;
  final double shrinkScale;

  const CInkWell({
    super.key,
    required this.child,
    required this.onPressed,
    this.shrinkScale = 0.98,
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
    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    Future.delayed(Duration(milliseconds: 150), () {
      setState(() => _isPressed = false);
      _animationController.reverse();
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    Future.delayed(Duration(milliseconds: 150), () {
      setState(() => _isPressed = false);
      _animationController.reverse();
    });
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
