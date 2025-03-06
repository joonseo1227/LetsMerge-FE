import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:url_launcher/url_launcher.dart';

class TaxiGroupOpenAppPage extends ConsumerStatefulWidget {
  const TaxiGroupOpenAppPage({super.key});

  @override
  ConsumerState<TaxiGroupOpenAppPage> createState() =>
      _TaxiGroupOpenAppPageState();
}

class _TaxiGroupOpenAppPageState extends ConsumerState<TaxiGroupOpenAppPage> {
  /// 특정 앱 실행 함수
  Future<void> _launchApp(String url, String storeUrl) async {
    final Uri appUri = Uri.parse(url);
    if (await canLaunchUrl(appUri)) {
      await launchUrl(appUri);
    } else {
      // 앱이 설치되지 않은 경우 스토어로 이동
      await launchUrl(Uri.parse(storeUrl),
          mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('어느 앱을 열까요?'),
        titleSpacing: 0,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CInkWell(
              onTap: () => _launchApp(
                'kakaot://launch', // 카카오T 실행 URL
                'https://play.google.com/store/apps/details?id=com.kakao.taxi', // 구글 플레이 스토어 URL
              ),
              child: Container(
                color: ThemeModel.surface(isDarkMode),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('assets/imgs/kakao_t.jpg'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '카카오 T',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 32,
            ),
            CInkWell(
              onTap: () => _launchApp(
                'uber://', // 우버 실행 URL
                'https://play.google.com/store/apps/details?id=com.ubercab', // 구글 플레이 스토어 URL
              ),
              child: Container(
                color: ThemeModel.surface(isDarkMode),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.asset('assets/imgs/uber.jpg'),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Uber',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
