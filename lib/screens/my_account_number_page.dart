import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/models/bank_model.dart';
import 'package:letsmerge/provider/account_provider.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/account_number/add_account_number_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_tag.dart';

class MyAccountNumberPage extends ConsumerWidget {
  const MyAccountNumberPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final accounts = ref.watch(userProvider)?.accounts ?? [];

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
                              account.accountNumber,
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
                      Navigator.of(context).push(
                        CupertinoPageRoute(builder: (_) => const AddAccountNumberPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.add, size: 24, color: ThemeModel.highlightText(isDarkMode)),
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