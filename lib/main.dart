import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/screens/auth/log_in_page.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/server/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // 플러터 엔진 초기화 (비동기 작업 전에 반드시 호출)
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 위치 권한 요청
  await _handleLocationPermission();

  // 환경변수(.env 파일) 로드
  await dotenv.load(fileName: 'assets/config/.env');

  // 네이버 지도 API 초기화
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
  );

  // 미리 저장된 다크모드 설정 불러오기
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;

  // 다크모드 초기 상태를 가진 ThemeNotifier 생성
  final themeNotifier = ThemeNotifier(isDarkMode);

  // themeProvider를 override하여, 앱 실행 시부터 다크모드 적용을 반영
  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => themeNotifier),
      ],
      child: const MyApp(),
    ),
  );
}

// 위치 권한 요청 처리
Future<void> _handleLocationPermission() async {
  var status = await Permission.location.status;

  if (!status.isGranted) {
    status = await Permission.location.request();
  }

  if (status.isGranted) {
    debugPrint('Location Permission Allowed');
  } else if (status.isDenied) {
    debugPrint('Location Permission Denied');
  } else if (status.isPermanentlyDenied) {
    // 영구 거절 시 앱 설정 화면을 열어 권한을 직접 변경하도록 유도
    await openAppSettings();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 다크모드 상태 값
    final isDarkMode = ref.watch(themeProvider);
    // 사용자 인증 상태
    final user = ref.watch(authProvider);

    return MaterialApp(
      title: '렛츠머지',
      debugShowCheckedModeBanner: false,
      // 다크모드 상태에 따라 ThemeMode를 결정
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // 라이트/다크 테마 설정
      theme: ThemeModel.lightTheme,
      darkTheme: ThemeModel.darkTheme,
      // 로그인 여부에 따라 다른 첫 화면을 보여줌
      home: user != null ? const MainPage() : const LogInPage(),
    );
  }
}
