import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';
import 'package:letsmerge/widgets/c_dialog.dart';
import 'package:letsmerge/widgets/c_dropdown.dart';
import 'package:letsmerge/widgets/c_text_field.dart';

class ReportPage extends ConsumerStatefulWidget {
  const ReportPage({super.key});

  @override
  ConsumerState<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends ConsumerState<ReportPage> {
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedReason;
  final List<String> _reasons = ['부적절한 행동', '스팸 또는 광고', '허위 정보', '기타'];

  @override
  void dispose() {
    _targetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('신고'),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CTextField(
                      label: '신고 대상',
                      hint: '신고할 사용자 또는 대상',
                      controller: _targetController,
                    ),
                    const SizedBox(height: 32),
                    CDropdown<String>(
                      label: '신고 사유',
                      hint: '신고 사유 선택',
                      onChanged: (reason) {
                        setState(() => _selectedReason = reason);
                      },
                      items: _reasons,
                    ),
                    const SizedBox(height: 32),
                    CTextField(
                      label: '상세 설명',
                      hint: '신고 내용',
                      controller: _descriptionController,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: ThemeModel.highlight(isDarkMode),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: SafeArea(
              top: false,
              child: CButton(
                onTap: () {
                  _submitReport();
                },
                size: CButtonSize.extraLarge,
                label: '제출',
                icon: Icons.navigate_next,
                width: double.maxFinite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitReport() {
    final target = _targetController.text;
    final reason = _selectedReason;
    final description = _descriptionController.text;
    final isDarkMode = ref.watch(themeProvider);

    if (target.isEmpty || reason == null || description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('모든 항목을 입력해주세요.'),
        ),
      );
      return;
    }

    // TODO: 서버에 신고 요청 보내기

    showDialog(
      context: context,
      builder: (context) {
        return CDialog(
          title: '신고 완료',
          content: Text(
            '신고가 접수되었습니다.',
            style: TextStyle(
              color: ThemeModel.text(isDarkMode),
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
