import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:shimmer/shimmer.dart';

///
/// [CSkeleton] 위젯
///
/// Parameter:
/// - [key]: Flutter의 기본 키 값 (optional)
///
class CSkeleton extends ConsumerStatefulWidget {
  const CSkeleton({super.key});

  @override
  _CSkeletonState createState() => _CSkeletonState();
}

class _CSkeletonState extends ConsumerState<CSkeleton> {
  double _opacity = 0.0; // 초기 투명도

  @override
  void initState() {
    super.initState();
    _fadeIn();
  }

  void _fadeIn() {
    Future.delayed(
      const Duration(milliseconds: 250),
      () {
        if (mounted) {
          setState(
            () {
              _opacity = 1.0;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedOpacity(
          opacity: _opacity, // 페이드인 애니메이션 적용
          duration: const Duration(milliseconds: 300), // 페이드인 지속 시간
          child: Shimmer.fromColors(
            baseColor: ThemeModel.surface(isDarkMode),
            highlightColor: ThemeModel.sub1(isDarkMode),
            period: const Duration(milliseconds: 800), // 기존 애니메이션 유지
            child: Container(
              width: constraints.maxWidth, // 부모의 너비
              height: constraints.maxHeight, // 부모의 높이
              decoration: BoxDecoration(
                color: ThemeModel.surface(isDarkMode),
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
