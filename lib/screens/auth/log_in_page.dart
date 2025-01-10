import 'package:flutter/material.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

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
              CTextField(
                keyboardType: TextInputType.emailAddress,
                label: '이메일',
                hint: 'example@example.com',
                backgroundColor: white,
              ),
              SizedBox(
                height: 16,
              ),
              CTextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                label: '암호',
                backgroundColor: white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
