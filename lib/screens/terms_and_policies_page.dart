import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/terms_model.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/screens/terms_detail_page.dart';
import 'package:letsmerge/widgets/c_ink_well.dart';

class TermsAndPoliciesPage extends ConsumerStatefulWidget {
  const TermsAndPoliciesPage({super.key});

  @override
  _TermsAndPoliciesPageState createState() => _TermsAndPoliciesPageState();
}

class _TermsAndPoliciesPageState extends ConsumerState<TermsAndPoliciesPage> {
  late Future<Map<String, TermsModel>> _termsData;

  @override
  void initState() {
    super.initState();
    _termsData = _loadTermsData();
  }

  Future<Map<String, TermsModel>> _loadTermsData() async {
    final data =
        await rootBundle.loadString('assets/data/terms_and_policies.json');
    final jsonData = json.decode(data) as Map<String, dynamic>;
    return jsonData.map(
      (key, value) => MapEntry(
        key,
        TermsModel.fromJson(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('약관 및 정책'),
        titleSpacing: 0,
      ),
      body: FutureBuilder<Map<String, TermsModel>>(
        future: _termsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('데이터를 불러오는 중 오류가 발생했습니다.'));
          }

          final termsData = snapshot.data!;
          final keys = termsData.keys.toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: ThemeModel.surface(isDarkMode),
                    child: Column(
                      children: keys.map((key) {
                        return _buildCInkWell(
                          context,
                          isDarkMode,
                          terms: termsData[key]!,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCInkWell(BuildContext context, bool isDarkMode,
      {required TermsModel terms}) {
    return CInkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TermsDetailPage(
              title: terms.title,
              content: terms.content,
            ),
          ),
        );
      },
      child: Container(
        color: ThemeModel.surface(isDarkMode),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              terms.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.navigate_next,
              color: ThemeModel.sub3(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }
}
