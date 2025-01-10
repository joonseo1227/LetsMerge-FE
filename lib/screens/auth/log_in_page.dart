import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  bool _isLoading = false;

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
      setState(() => _emailError = '이메일을 입력해주세요.');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = '비밀번호를 입력해주세요.');
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
          _emailError = '이메일 형식을 확인해주세요.';
        } else if (e.toString().contains('wrong-password')) {
          _passwordError = '비밀번호가 틀렸습니다.';
        } else {
          _emailError = '로그인에 실패했습니다. 다시 시도해주세요.';
        }
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/imgs/logo_black.png"),
                ),
                const SizedBox(height: 50),
                CTextField(
                  label: "이메일",
                  controller: _emailController,
                  errorText: _emailError,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CTextField(
                  label: "비밀번호",
                  controller: _passwordController,
                  errorText: _passwordError,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                CInkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: StadiumBorder(),
                    ),
                    child: const Text(
                      '로그인',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () {
                    _login();
                  },
                ),
                const SizedBox(height: 50),
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
    super.dispose();
  }
}