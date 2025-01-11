import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  // 버튼 활성화 상태 업데이트
  void _updateButtonState() {
    final isEmailNotEmpty = _emailController.text.trim().isNotEmpty;
    final isPasswordNotEmpty = _passwordController.text.trim().isNotEmpty;
    _isButtonEnabled.value = isEmailNotEmpty && isPasswordNotEmpty;
  }

  // 에러 상태 초기화
  void _clearError() {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });
  }

  // 유효성 검사
  bool _validate() {
    _clearError();

    if (_emailController.text.isEmpty) {
      setState(() => _emailError = '이메일을 입력하십시오.');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = '암호를 입력하십시오.');
      return false;
    }

    return true;
  }

  Future<void> _login() async {
    final authNotifier = ref.read(authProvider.notifier);

    if (!_validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signInWithEmail(email, password);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        if (e.toString().contains('user-not-found')) {
          _emailError = '등록되지 않은 이메일입니다.';
        } else if (e.toString().contains('invalid-email')) {
          _emailError = '이메일 형식을 확인하십시오.';
        } else if (e.toString().contains('wrong-password')) {
          _passwordError = '일치하지 않는 암호입니다.';
        } else {
          _emailError = '이메일 또는 암호를 확인하십시오.';
        }
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 80,
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/imgs/logo_black.png'),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Let\'s Merge 시작하기',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: ThemeModel.text(isDarkMode),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                CTextField(
                  label: '이메일',
                  controller: _emailController,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                  hint: 'example@example.com',
                ),
                const SizedBox(
                  height: 16,
                ),
                CTextField(
                  label: '암호',
                  controller: _passwordController,
                  errorText: _passwordError,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return CButton(
                      onTap: isEnabled ? _login : null,
                      label: '로그인',
                      width: double.maxFinite,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }
}