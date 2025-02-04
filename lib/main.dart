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
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('1. WidgetsFlutterBinding initialized.');

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('2. Firebase initialized.');

  // 위치 권한 요청
  await _handleLocationPermission();
  debugPrint('3. Location permission handled.');

  // 환경변수 로드
  await dotenv.load(fileName: 'assets/config/.env');
  debugPrint('4. Environment variables loaded.');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_PROJECT_URL'] ?? "",
    anonKey: dotenv.env['SUPABASE_API_KEY'] ?? "",
  );

  // 네이버 지도 API 초기화
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
  );
  debugPrint('5. NaverMap SDK initialized.');

  // SharedPreferences 및 다크모드 설정 불러오기
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  debugPrint('6. Dark mode status loaded: $isDarkMode');

  // 다크모드 설정
  final themeNotifier = ThemeNotifier(isDarkMode);

  // 앱 실행
  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith((ref) => themeNotifier),
      ],
      child: MyApp(),
    ),
  );
  debugPrint('7. App started.');
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
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 다크모드 상태 값
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: '렛츠머지',
      debugShowCheckedModeBanner: false,
      // 다크모드 상태에 따라 ThemeMode를 결정
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // 라이트/다크 테마 설정
      theme: ThemeModel.lightTheme,
      darkTheme: ThemeModel.darkTheme,
      // 로그인 여부에 따라 다른 첫 화면을 보여줌
      home: StreamBuilder(
        stream: _supabase.auth.onAuthStateChange,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }

          final session = snapshot.hasData ? snapshot.data!.session : null;

          if (session != null) {
            return MainPage();
          } else {
            return LogInPage();
          }
        },
      ),
    );
  }
}
