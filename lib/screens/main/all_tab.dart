import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class AllTab extends ConsumerStatefulWidget {
  const AllTab({super.key});

  @override
  ConsumerState<AllTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<AllTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return AnnotatedRegion(
      value:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  CInkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.all(16),
                      color: ThemeModel.surface(isDarkMode),
                      child: Row(
                        children: [
                          Container(
                            height: 64,
                            width: 64,
                            decoration: ShapeDecoration(
                              color: blue20,
                              shape: CircleBorder(),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            '홍길동',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ThemeModel.text(isDarkMode),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.navigate_next,
                            color: ThemeModel.text(isDarkMode),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
