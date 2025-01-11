import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
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
    );
  }
}
