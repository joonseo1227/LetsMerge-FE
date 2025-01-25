import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/add_account_number_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class MyAccountNumberPage extends ConsumerStatefulWidget {
  const MyAccountNumberPage({super.key});

  @override
  ConsumerState<MyAccountNumberPage> createState() =>
      _MyAccountNumberPageState();
}

class _MyAccountNumberPageState extends ConsumerState<MyAccountNumberPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 계좌번호'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CInkWell(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => AddAccountNumberPage(),
                    ),
                  );
                },
                child: Container(
                  color: ThemeModel.surface(isDarkMode),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        size: 24,
                        color: ThemeModel.highlightText(isDarkMode),
                      ),
                      SizedBox(
                        width: 16,
                      ),
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
      ),
    );
  }
}
