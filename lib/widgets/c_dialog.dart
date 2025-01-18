import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/config/color.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';

class CDialog extends ConsumerWidget {
  final String title;
  final String content;
  final List<Widget> buttons;

  const CDialog({
    super.key,
    required this.title,
    required this.content,
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: ThemeModel.text(isDarkMode),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    content,
                    style: TextStyle(
                      color: ThemeModel.text(isDarkMode),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
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
      ),
    );
  }
}
