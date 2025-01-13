import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/server/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _handleLocationPermission();
  await dotenv.load(fileName: 'assets/config/.env');
  // 네이버 지도 API 키 초기 설정
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
  );
  runApp(ProviderScope(child: const MyApp()));
}

Future<void> _handleLocationPermission() async {
  var status = await Permission.location.status;
  if (!status.isGranted) {
    status = await Permission.location.request();
  }

  if (status.isGranted) {
    print('위치 권한이 허용되었습니다.');
  } else if (status.isDenied) {
    print('위치 권한이 거부되었습니다.');
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: '렛츠머지',
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeModel.lightTheme,
      darkTheme: ThemeModel.darkTheme,
      home: const MainPage(),
    );
  }
}