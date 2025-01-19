import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/screens/settings_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class AllTab extends ConsumerStatefulWidget {
  const AllTab({super.key});

  @override
  ConsumerState<AllTab> createState() => _AllTabState();
}

class _AllTabState extends ConsumerState<AllTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final user = ref.watch(authProvider);

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('전체'),
          actions: [
            CInkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => SettingsPage(),
                  ),
                );
              },
              child: SizedBox(
                width: 32,
                height: 32,
                child: Icon(
                  Icons.settings,
                  size: 28,
                  color: ThemeModel.sub3(isDarkMode),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                            user?.displayName ?? '사용자 이름 없음',
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
