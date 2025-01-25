import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class AddAccountNumberPage extends ConsumerStatefulWidget {
  const AddAccountNumberPage({super.key});

  @override
  ConsumerState<AddAccountNumberPage> createState() =>
      _AddAccountNumberPageState();
}

class _AddAccountNumberPageState extends ConsumerState<AddAccountNumberPage> {
  @override
  void initState() {
    super.initState();
  }

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
          // 스크롤 가능한 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CTextField(
                      keyboardType: TextInputType.number,
                      label: '계좌번호',
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    CTextField(
                      label: '이름',
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 버튼 영역
          Container(
            color: ThemeModel.highlight(isDarkMode),
            child: SafeArea(
              top: false,
              child: CButton(
                onTap: () {
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
