import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';

///
/// [CDialog]
///
/// Parameter:
/// - [title]: 대화상자의 제목 (optional)
/// - [content]: 대화상자의 내용 위젯 (optional)
/// - [buttons]: 대화상자 하단에 표시될 버튼 리스트
///
class CDialog extends ConsumerWidget {
  final String? title;
  final Widget? content;
  final List<Widget> buttons;

  const CDialog({
    super.key,
    this.title,
    this.content,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: ThemeModel.surface(isDarkMode),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: TextStyle(
                          color: ThemeModel.text(isDarkMode),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (title != null)
                      const SizedBox(
                        height: 16,
                      ),
                    if (content != null) content!,
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: buttons.map((button) {
              return Expanded(
                child: Container(
                  color: (button as CButton).style?.backgroundColor ?? blue60,
                  child: button,
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
