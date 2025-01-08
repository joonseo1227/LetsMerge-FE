import 'package:flutter/material.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/screens/main/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '머지해요',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeModel.lightTheme,
      darkTheme: ThemeModel.darkTheme,
      home: const MainPage(),
    );
  }
}
