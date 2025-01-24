import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/provider/theme_provider.dart';
import 'package:letsmerge/widgets/c_button.dart';

class ButtonGalleryPage extends ConsumerWidget {
  const ButtonGalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final List<Map<String, CButtonStyle Function(bool)>> styles = [
      {'Primary': CButtonStyle.primary},
      {'Secondary': CButtonStyle.secondary},
      {'Tertiary': CButtonStyle.tertiary},
      {'Danger': CButtonStyle.danger},
      {'Ghost': CButtonStyle.ghost},
    ];

    final List<CButtonSize> sizes = CButtonSize.values;

    return Scaffold(
      appBar: AppBar(
        title: Text('ButtonGalleryPage'),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final size in sizes) ...[
                for (final styleEntry in styles) ...[
                  CButton(
                    label: '${size.name} / ${styleEntry.keys.first}',
                    icon: Icons.star,
                    size: size,
                    style: styleEntry.values.first(isDarkMode),
                    onTap: () {},
                  ),
                  const SizedBox(height: 16),
                ],
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
