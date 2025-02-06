import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/bank_model.dart';
import 'package:letsmerge/models/user_model.dart';
import 'package:letsmerge/provider/account_provider.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_text_field.dart';
import 'package:letsmerge/widgets/c_popup_menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddAccountNumberPage extends ConsumerStatefulWidget {
  const AddAccountNumberPage({super.key});

  @override
  ConsumerState<AddAccountNumberPage> createState() =>
      _AddAccountNumberPageState();
}

class _AddAccountNumberPageState extends ConsumerState<AddAccountNumberPage> {
  final supabase = Supabase.instance.client;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CDialog(
          title: '계좌 등록',
          content: Text(
            message,
            style: TextStyle(
              color: ThemeModel.text(ref.read(themeProvider)),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          buttons: [
            CButton(
              size: CButtonSize.extraLarge,
              label: '확인',
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  BankInfo? selectedBank;
  final TextEditingController accountController = TextEditingController();
  final GlobalKey<CPopupMenuState> popupMenuKey = GlobalKey<CPopupMenuState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: CInkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: SizedBox(
            width: 32,
            height: 32,
            child: Icon(
              Icons.close,
              size: 28,
              color: ThemeModel.text(isDarkMode),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '은행 선택',
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeModel.text(isDarkMode),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CPopupMenu(
                      key: popupMenuKey,
                      button: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: ThemeModel.surface(isDarkMode),
                          border: Border(
                            bottom: BorderSide(
                              color: ThemeModel.sub5(isDarkMode),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedBank?.name ?? '은행을 선택하세요.',
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedBank != null
                                    ? ThemeModel.text(isDarkMode)
                                    : ThemeModel.hintText(isDarkMode),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: ThemeModel.hintText(isDarkMode),
                            ),
                          ],
                        ),
                      ),
                      dropdownWidth: MediaQuery.of(context).size.width - 32,
                      dropdown: Container(
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: bankList.map((bank) {
                            return CInkWell(
                              onTap: () {
                                setState(() => selectedBank = bank);
                                popupMenuKey.currentState?.hideDropdown();
                              },
                              child: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: Text(
                                  bank.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: ThemeModel.text(isDarkMode),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CTextField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      label: '계좌번호',
                      controller: accountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(14),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "'${supabase.auth.currentUser?.userMetadata?['name']}'님 본인 명의의 계좌 번호를 입력하세요.",
                      style: TextStyle(
                        fontSize: 14,
                        color: ThemeModel.highlightText(isDarkMode),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: ThemeModel.highlight(isDarkMode),
            child: SafeArea(
              top: false,
              child: CButton(
                onTap: () {
                  final accountNumber = accountController.text;
                  if (accountController.text.isEmpty) {
                    _showErrorDialog('계좌번호를 입력해주세요.');
                    return;
                  } else if (accountNumber.length < 10 ||
                      accountNumber.length > 14) {
                    _showErrorDialog('유효한 계좌번호를 입력해주세요.');
                    return;
                  }
                  if (selectedBank == null) {
                    _showErrorDialog('은행을 선택해주세요.');
                    return;
                  }

                  ref.read(userProvider.notifier).addAccount(
                        Account(
                          accountNumber: accountController.text,
                          bankName: selectedBank!.name,
                        ),
                      );
                  Navigator.pop(context);
                },
                size: CButtonSize.extraLarge,
                label: '계좌 등록',
                icon: Icons.navigate_next,
                width: double.maxFinite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
