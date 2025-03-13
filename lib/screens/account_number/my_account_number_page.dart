import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/bank_model.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/provider/user_fetch_notifier.dart';
import 'package:letsmerge/screens/account_number/add_account_number_page.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_tag.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyAccountNumberPage extends ConsumerWidget {
  MyAccountNumberPage({super.key});
  final User? user = Supabase.instance.client.auth.currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final accounts = ref.watch(userAccountsProvider(user?.id ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 계좌번호'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: ThemeModel.surface(isDarkMode),
              child: Column(
                children: [
                  ...accounts.map((account) {
                    final bankInfo = bankList.firstWhere(
                          (bank) => bank.name == account.bankName,
                    );

                    return CInkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              account.account,
                              style: TextStyle(
                                color: ThemeModel.text(isDarkMode),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            CTag(
                              color: bankInfo.color,
                              text: bankInfo.name,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  CInkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CDialog(
                            title: '확인 필요',
                            content: Text(
                              '사용자는 렛츠머지 앱에서 계좌번호를 직접 입력 및 등록하며, 본 정보의 정확성을 스스로 확인해야 합니다. 본 서비스는 계좌번호의 유효성을 검증하지 않으며, 잘못된 정보 입력으로 인해 발생하는 금전적 손실, 정산 오류 등에 대해 책임을 지지 않습니다. 이에 동의하지 않을 경우, 계좌번호를 등록하지 마시기 바랍니다.',
                              style: TextStyle(
                                color: ThemeModel.text(isDarkMode),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            buttons: [
                              CButton(
                                style: CButtonStyle.secondary(isDarkMode),
                                size: CButtonSize.extraLarge,
                                label: '동의 안 함',
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              CButton(
                                size: CButtonSize.extraLarge,
                                label: '동의',
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (_) =>
                                      const AddAccountNumberPage(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            size: 24,
                            color: ThemeModel.highlightText(isDarkMode),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '계좌 추가하기',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: ThemeModel.highlightText(isDarkMode),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
