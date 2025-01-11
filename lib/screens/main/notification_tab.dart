import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class NotificationTab extends ConsumerStatefulWidget {
  const NotificationTab({super.key});

  @override
  ConsumerState<NotificationTab> createState() => _NotificationTabState();
}

class _NotificationTabState extends ConsumerState<NotificationTab> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: Center(
        child: Text(
          '알림',
          style: TextStyle(
            color: ThemeModel.text(isDarkMode),
          ),
        ),
      ),
    );
  }
}
