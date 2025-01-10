import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nicknameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  // 에러 상태 초기화
  void _clearError() {
    setState(() {
      _nicknameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
  }

  //유효성 검사
  bool _validate() {
    _clearError();
    setState(() {
      _nicknameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });

    if (_nicknameController.text.isEmpty) {
      setState(() => _nicknameError = '닉네임을 입력해주세요.');
      return false;
    }
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = '이메일을 입력해주세요.');
      return false;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 6) {
      setState(() => _passwordError = '비밀번호는 6자 이상이어야 합니다.');
      return false;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = '비밀번호가 일치하지 않습니다.');
      return false;
    }

    return true; // 모든 유효성 검사를 통과한 경우
  }

  Future<void> _signUp() async {
    final authNotifier = ref.read(authProvider.notifier);

    if (!_validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final nickname = _nicknameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signUpWithEmail(email, password, nickname);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        if (e.toString().contains('email')) {
          _emailError = '유효하지 않은 이메일이거나 이미 사용 중입니다.';
        } else if (e.toString().contains('password')) {
          _passwordError = '비밀번호를 다시 확인해주세요.';
        } else {
          _nicknameError = '다시 시도해주세요.';
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
                  label: "닉네임",
                  controller: _nicknameController,
                  errorText: _nicknameError,
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                CTextField(
                  label: "비밀번호 확인",
                  controller: _confirmPasswordController,
                  errorText: _confirmPasswordError,
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
                      '회원가입',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  onTap: () {
                    _signUp();
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
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
