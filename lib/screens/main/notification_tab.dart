import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget {
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('알림'),
      ),
      body: Center(
        child: const Text('알림'),
      ),
    );
  }
}
