import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letsmerge/models/theme_model.dart';
import 'package:letsmerge/provider/theme_provider.dart';

class TermsDetailPage extends ConsumerStatefulWidget {
  final String title;
  final String content;

  const TermsDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  ConsumerState<TermsDetailPage> createState() => _TermsDetailPageState();
}

class _TermsDetailPageState extends ConsumerState<TermsDetailPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: SafeArea(
            child: Text(
              widget.content,
              style: TextStyle(
                fontSize: 16,
                color: ThemeModel.text(isDarkMode),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
