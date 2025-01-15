import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';
import 'package:shimmer/shimmer.dart';

class CSkeleton extends StatefulWidget {
  const CSkeleton({Key? key}) : super(key: key);

  @override
  _CSkeletonState createState() => _CSkeletonState();
}

class _CSkeletonState extends State<CSkeleton> {
  double _opacity = 0.0; // 초기 투명도

  @override
  void initState() {
    super.initState();
    _fadeIn();
  }

  void _fadeIn() {
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedOpacity(
          opacity: _opacity, // 페이드인 애니메이션 적용
          duration: const Duration(milliseconds: 300), // 페이드인 지속 시간
          child: Shimmer.fromColors(
            baseColor: grey20,
            highlightColor: grey10,
            period: const Duration(milliseconds: 800), // 기존 애니메이션 유지
            child: Container(
              width: constraints.maxWidth, // 부모의 너비
              height: constraints.maxHeight, // 부모의 높이
              decoration: BoxDecoration(
                color: grey30,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}