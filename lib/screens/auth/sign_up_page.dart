import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  // 버튼 활성화 상태 업데이트
  void _updateButtonState() {
    final isNameNotEmpty = _nameController.text.trim().isNotEmpty;
    final isEmailNotEmpty = _emailController.text.trim().isNotEmpty;
    final isPasswordNotEmpty = _passwordController.text.trim().isNotEmpty;
    final isConfirmPasswordNotEmpty =
        _confirmPasswordController.text.trim().isNotEmpty;

    _isButtonEnabled.value = isNameNotEmpty &&
        isEmailNotEmpty &&
        isPasswordNotEmpty &&
        isConfirmPasswordNotEmpty;
  }

  // 에러 상태 초기화
  void _clearError() {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
  }

  // 유효성 검사
  bool _validate() {
    _clearError();

    if (_nameController.text.isEmpty) {
      setState(() => _nameError = '이름을 입력하십시오.');
      return false;
    }
    if (_emailController.text.isEmpty) {
      setState(() => _emailError = '이메일을 입력하십시오.');
      return false;
    }
    if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 6) {
      setState(() => _passwordError = '암호는 6자 이상이어야 합니다.');
      return false;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = '암호가 일치하지 않습니다.');
      return false;
    }

    return true;
  }

  Future<void> _signUp() async {
    final authNotifier = ref.read(authProvider.notifier);

    if (!_validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      await authNotifier.signUpWithEmail(email, password, name);
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        if (e.toString().contains('email')) {
          _emailError = '유효하지 않은 이메일이거나 이미 사용 중입니다.';
        } else if (e.toString().contains('password')) {
          _passwordError = '암호를 확인하십시오.';
        } else {
          _nameError = '다시 시도하십시오.';
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
                  label: '이름',
                  controller: _nameController,
                  errorText: _nameError,
                  hint: '홍길동',
                ),
                const SizedBox(
                  height: 16,
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
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 16,
                ),
                CTextField(
                  label: '암호 재입력',
                  controller: _confirmPasswordController,
                  errorText: _confirmPasswordError,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 24,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return CButton(
                      onTap: isEnabled ? _signUp : null,
                      label: '회원 가입',
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isButtonEnabled.dispose();
    super.dispose();
  }
}