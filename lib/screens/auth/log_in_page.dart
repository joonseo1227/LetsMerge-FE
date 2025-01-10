import 'package:flutter/material.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: '이메일'
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                    hintText: '암호'
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
