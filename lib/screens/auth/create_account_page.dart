import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/terms_model.dart';
import 'package:letsmerge/provider/auth_provider.dart';
import 'package:letsmerge/screens/terms_detail_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_checkbox.dart';
import 'package:letsmerge/widgets/c_list_tile.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final supabase = Supabase.instance.client;
  final authService = AuthProvider();

  final _nameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _isButtonEnabled = ValueNotifier(false);

  String? _nameError;
  String? _nicknameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _isLoading = false;
  bool _isAllAgreed = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
    _nicknameController.addListener(_updateButtonState);
    _emailController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
    _confirmPasswordController.addListener(_updateButtonState);
  }

  // 버튼 활성화 상태 업데이트
  void _updateButtonState() {
    final isNameNotEmpty = _nameController.text.trim().isNotEmpty;
    final isNicknameNotEmpty = _nicknameController.text.trim().isNotEmpty;
    final isEmailNotEmpty = _emailController.text.trim().isNotEmpty;
    final isPasswordNotEmpty = _passwordController.text.trim().isNotEmpty;
    final isConfirmPasswordNotEmpty =
        _confirmPasswordController.text.trim().isNotEmpty;

    _isButtonEnabled.value = isNameNotEmpty &&
        isNicknameNotEmpty &&
        isEmailNotEmpty &&
        isPasswordNotEmpty &&
        isConfirmPasswordNotEmpty &&
        _isAllAgreed;
  }

  // 에러 상태 초기화
  void _clearError() {
    setState(() {
      _nameError = null;
      _nicknameError = null;
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
    if (_nicknameController.text.isEmpty) {
      setState(() => _nicknameError = '닉네임을 입력하십시오.');
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
    final name = _nameController.text;
    final nickname = _nicknameController.text;
    final email = _emailController.text;
    final password = _confirmPasswordController.text;

    if (!_validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await authService.signUpWithEmailPassword(
          email, password, name, nickname);

      if (!mounted) return;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('계정 생성'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  label: '닉네임',
                  controller: _nicknameController,
                  errorText: _nicknameError,
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
                  height: 32,
                ),
                TermsAgreementWidget(
                  onAgreementChanged: (bool isAgreed) {
                    setState(() {
                      _isAllAgreed = isAgreed;
                    });
                    _updateButtonState();
                  },
                ),
                const SizedBox(
                  height: 32,
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _isButtonEnabled,
                  builder: (context, isEnabled, child) {
                    return CButton(
                      onTap: isEnabled ? _signUp : null,
                      isLoading: _isLoading,
                      label: '다음',
                      icon: Icons.navigate_next,
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

class TermsAgreementWidget extends StatefulWidget {
  final Function(bool) onAgreementChanged;

  const TermsAgreementWidget({
    super.key,
    required this.onAgreementChanged,
  });

  @override
  State<TermsAgreementWidget> createState() => _TermsAgreementWidgetState();
}

class _TermsAgreementWidgetState extends State<TermsAgreementWidget> {
  Map<String, bool> _isAgreed = {};
  late Future<Map<String, TermsModel>> _termsData;
  bool _isAllChecked = false;

  @override
  void initState() {
    super.initState();
    _termsData = _loadTermsData();
  }

  Future<Map<String, TermsModel>> _loadTermsData() async {
    final data =
        await rootBundle.loadString('assets/data/terms_and_policies.json');
    final jsonData = json.decode(data) as Map<String, dynamic>;
    final termsMap = jsonData.map(
      (key, value) => MapEntry(
        key,
        TermsModel.fromJson(value),
      ),
    );
    _isAgreed = {for (var key in termsMap.keys) key: false};
    return termsMap;
  }

  void _toggleAllAgreements(bool value) {
    setState(() {
      _isAllChecked = value;
      _isAgreed.updateAll((key, _) => value);
      widget.onAgreementChanged(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, TermsModel>>(
      future: _termsData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              '데이터를 불러오는 중 오류가 발생했습니다.',
            ),
          );
        }

        final termsData = snapshot.data!;
        final keys = termsData.keys.toList();

        return Column(
          children: [
            CListTile(
              leading: CCheckbox(
                value: _isAllChecked,
                label: '전체 동의',
                onChanged: (value) => _toggleAllAgreements(value),
              ),
              trailingIcon: null,
              onTap: () => _toggleAllAgreements(!_isAllChecked),
            ),
            const Divider(),
            ...keys.map((key) {
              return CListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => TermsDetailPage(
                        title: termsData[key]!.title,
                        content: termsData[key]!.content,
                      ),
                    ),
                  );
                },
                leading: CCheckbox(
                  value: _isAgreed[key] ?? false,
                  label: termsData[key]!.title,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed[key] = value;
                      _isAllChecked =
                          _isAgreed.values.every((element) => element);
                      widget.onAgreementChanged(_isAllChecked);
                    });
                  },
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
