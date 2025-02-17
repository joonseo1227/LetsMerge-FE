import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/auth/create_account_page.dart';
import 'package:letsmerge/screens/main/main_page.dart';
import 'package:letsmerge/service/auth_service.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  final supabase = Supabase.instance.client;
  final authService = AuthService();

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

    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signInWithEmailPassword(email, password);

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) => MainPage(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      setState(() {
        if (e.toString().contains('invalid-email')) {
          _emailError = '이메일 형식을 확인하십시오.';
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

    return AnnotatedRegion(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
            ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: isDarkMode
                        ? SvgPicture.asset('assets/imgs/logo_grey10.svg')
                        : SvgPicture.asset('assets/imgs/logo_grey100.svg'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '렛츠머지 시작하기',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
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
                        isLoading: _isLoading,
                        label: '로그인',
                        icon: Icons.navigate_next,
                        width: double.maxFinite,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Text(
                    '계정이 없으신가요?',
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeModel.text(isDarkMode),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CButton(
                    onTap: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => CreateAccountPage(),
                        ),
                      );
                    },
                    label: '계정 생성',
                    icon: Icons.navigate_next,
                    style: CButtonStyle.tertiary(isDarkMode),
                    width: double.maxFinite,
                  ),
                ],
              ),
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
